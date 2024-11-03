package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.system.Capabilities;

import states.ModsMenuState;

class FPSCounter extends Sprite
{
    public var currentFPS(default, null):Int;
    public var memoryMegas(get, never):Float;

    var developerModeText:String;
    var stateInfoTxt:String = '';
    var configTipsTxt:String = '';
    var background:Shape;
    var textField:TextField;

    @:noCompletion private var times:Array<Float>;

    public function new()
    {
        super();

        currentFPS = 0;

        background = new Shape();
        addChild(background);

        textField = new TextField();
        textField.selectable = false;
        textField.mouseEnabled = false;
        textField.defaultTextFormat = new TextFormat(Paths.font('vcr.ttf'), 14, 0x000000);
        textField.autoSize = LEFT;
        textField.multiline = true;
        textField.text = "FPS: ";
        addChild(textField);

        times = [];
    }

    var deltaTimeout:Float = 0.0;
    var fpsMode:Int = 0;
    var canChangeFPSType:Bool = true;

    var reSetupGame:FlxTimer = new FlxTimer();

    private override function __enterFrame(deltaTime:Float):Void
    {
        if (deltaTimeout > 1000) {
            deltaTimeout = 0.0;
            return;
        }

        if (CoolVars.globalVars.get('developerMode'))
        {
            if (fpsMode == 0)
            {
                developerModeText = LanguageManager.getPhrase('fpsCounterInfo')[0];
            } else {
                developerModeText = '\n\n' + LanguageManager.getPhrase('fpsCounterInfo')[0];
            }
        } else {
            developerModeText = '';
        }
        
        if (CoolUtil.getCurrentSubState() == null)
        {
            if (CoolUtil.getCurrentState()[0])
            {
                stateInfoTxt = '\n\n' + LanguageManager.getPhrase('fpsCounterInfo')[4] + 'states.ScriptState (' + CoolUtil.getCurrentState()[1] + ')';
            } else {
                stateInfoTxt = '\n\n' + LanguageManager.getPhrase('fpsCounterInfo')[4] + CoolUtil.getCurrentState()[1];
            }
        } else {
            if (CoolUtil.getCurrentState()[0])
            {
                stateInfoTxt = '\n\n' + LanguageManager.getPhrase('fpsCounterInfo')[4] + 'states.ScriptState (' + CoolUtil.getCurrentState()[1] + ')' + '\n' +
                LanguageManager.getPhrase('fpsCounterInfo')[5] + CoolUtil.getCurrentSubState();
            } else {
                stateInfoTxt = '\n\n' + LanguageManager.getPhrase('fpsCounterInfo')[4] + CoolUtil.getCurrentState()[1] + '\n' +
                LanguageManager.getPhrase('fpsCounterInfo')[5] + CoolUtil.getCurrentSubState();
            }
        }

        if (FlxG.keys.justPressed.F3 && canChangeFPSType && !FlxG.keys.pressed.CONTROL && !FlxG.keys.pressed.SHIFT)
        {
            switch (fpsMode)
            {
                case 0:
                    fpsMode = 1;
                case 1:
                    fpsMode = 2;
                case 2:
                    fpsMode = 3;
                case 3:
                    fpsMode = 4;
                case 4:
                    fpsMode = 0;
            }

            canChangeFPSType = false;

            new FlxTimer().start(0.2, function(tmr:FlxTimer)
            {
                canChangeFPSType = true;
            });
        }

        if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.SHIFT && CoolVars.globalVars.get('developerMode') && CoolUtil.getCurrentState()[1] != 'states.PlayState')
        {
            configTipsTxt = '\n\n' + LanguageManager.getPhrase('fpsCounterInfo')[1];

            if (FlxG.keys.justPressed.F3)
            {
                this.visible = false;
                
                LanguageManager.phrases = [];

                for (key in CoolVars.globalVars.keys())
                {
                    if (key != 'engineVersion' && key != 'consoleVisible')
                    {
                        CoolVars.globalVars.remove(key);
                    }
                }
                
                CoolVars.globalVars.set('initialConfig', false);
                CoolVars.globalVars.set('reconfigureData', CoolUtil.getCurrentState());
                
                MusicBeatState.switchState(new ScriptState('configGame'));
            }
            if (FlxG.keys.justPressed.TAB)
            {
				MusicBeatState.switchState(new ModsMenuState());
            }
        } else {
            configTipsTxt = '';
        }

        final now:Float = haxe.Timer.stamp() * 1000;
        times.push(now);
        while (times[0] < now - 1000) times.shift();

        currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;		
        updateText();
        deltaTimeout += deltaTime;
    }

    public dynamic function updateText():Void 
    {
        switch (fpsMode)
        {
            case 0:
                textField.text = developerModeText
                + configTipsTxt;
            case 1:
                textField.text = '' + LanguageManager.getPhrase('fpsCounterInfo')[2] + currentFPS
                + '\n' + 
                LanguageManager.getPhrase('fpsCounterInfo')[3] + flixel.util.FlxStringUtil.formatBytes(memoryMegas)
                + developerModeText
                + configTipsTxt;
            case 2:
                textField.text = '' + LanguageManager.getPhrase('fpsCounterInfo')[2] + currentFPS
                + '\n' + 
                LanguageManager.getPhrase('fpsCounterInfo')[3] +  flixel.util.FlxStringUtil.formatBytes(memoryMegas)
                + stateInfoTxt
                + developerModeText
                + configTipsTxt;
            case 3:
                textField.text = '' + LanguageManager.getPhrase('fpsCounterInfo')[2] + currentFPS
                + '\n' + 
                LanguageManager.getPhrase('fpsCounterInfo')[3] +  flixel.util.FlxStringUtil.formatBytes(memoryMegas)
                + stateInfoTxt 
                + '\n\n' + 
                LanguageManager.getPhrase('fpsCounterInfo')[6] + Lib.application.window.x + ' - ' + Lib.application.window.y
                + '\n' +
                LanguageManager.getPhrase('fpsCounterInfo')[7] + Lib.application.window.width + ' x ' + Lib.application.window.height
                + developerModeText
                + configTipsTxt;
            case 4:
                textField.text = '' + LanguageManager.getPhrase('fpsCounterInfo')[2] + currentFPS
                + '\n' + 
                LanguageManager.getPhrase('fpsCounterInfo')[3] +  flixel.util.FlxStringUtil.formatBytes(memoryMegas)
                + stateInfoTxt + '\n\n' + 
                LanguageManager.getPhrase('fpsCounterInfo')[6] + Lib.application.window.x + ' - ' + Lib.application.window.y
                + '\n' +
                LanguageManager.getPhrase('fpsCounterInfo')[7] + Lib.application.window.width + ' x ' + Lib.application.window.height
                + '\n\n' +
                LanguageManager.getPhrase('fpsCounterInfo')[8] + Capabilities.screenResolutionX + ' x ' + openfl.system.Capabilities.screenResolutionY
                + '\n' +
                LanguageManager.getPhrase('fpsCounterInfo')[9] + Capabilities.os
                + developerModeText
                + configTipsTxt;
        }

        if (currentFPS < FlxG.drawFramerate * 0.5)
        {
            textField.textColor = FlxColor.RED;
        } else {
            textField.textColor = FlxColor.WHITE;
        }

        textField.x = 10;
        textField.y = 5;

        background.graphics.clear();
        background.graphics.beginFill(0x000000, 0.5);

        var textFieldText:String = textField.text;

        if (textFieldText.replace(' ', '') == '')
        {
            background.graphics.drawRect(0, 0, 0, 0);
        } else {
            background.graphics.drawRect(0, 0, textField.width + textField.x * 2, textField.height + textField.y * 2);
        }
        background.graphics.endFill();

        background.x = 0;
        background.y = 0;
    }

    function get_memoryMegas():Float
    {
        return cast(System.totalMemory, UInt);
    }
}
