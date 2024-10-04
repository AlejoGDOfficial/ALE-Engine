package debug;

import flixel.FlxG;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import openfl.display.Shape;
import openfl.display.Sprite;

class FPSCounter extends Sprite
{
    public var currentFPS(default, null):Int;
    public var memoryMegas(get, never):Float;

    var developerModeText:String;
    var background:Shape;
    var textField:TextField;

    @:noCompletion private var times:Array<Float>;

    public function new()
    {
        super();

        if (CoolVars._developerMode)
        {
            developerModeText = 'DEVELOPER MODE';
        } else {
            developerModeText = '';
        }

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

    private override function __enterFrame(deltaTime:Float):Void
    {
        if (deltaTimeout > 1000) {
            deltaTimeout = 0.0;
            return;
        }

        if (FlxG.keys.justPressed.F3 && canChangeFPSType)
        {
            switch (fpsMode)
            {
                case 0:
                    fpsMode = 1;
                case 1:
                    fpsMode = 2;
                case 2:
                    fpsMode = 0;
            }

            canChangeFPSType = false;

            new FlxTimer().start(0.2, function(tmr:FlxTimer)
            {
                canChangeFPSType = true;
            });
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
                textField.text = 'FPS: ${currentFPS}'
                + '\n' + 
                'Memory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}'
                + '\n\n' + developerModeText;
            case 1:
                textField.text = 'FPS: ${currentFPS}'
                + '\n' + 
                'Memory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}'
                + '\n\n' +
                'Window Position: ' + openfl.Lib.application.window.x + ' - ' + openfl.Lib.application.window.y
                + '\n' +
                'Window Resolution: ' + openfl.Lib.application.window.width + ' x ' + openfl.Lib.application.window.height
                + '\n\n' + developerModeText;
            case 2:
                textField.text = 'FPS: ${currentFPS}'
                + '\n' + 
                'Memory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}'
                + '\n\n' +
                'Window Position: ' + openfl.Lib.application.window.x + ' - ' + openfl.Lib.application.window.y
                + '\n' +
                'Window Resolution: ' + openfl.Lib.application.window.width + ' x ' + openfl.Lib.application.window.height
                + '\n\n' +
                'Screen Resolution: ' + openfl.system.Capabilities.screenResolutionX + ' x ' + openfl.system.Capabilities.screenResolutionY
                + '\n' +
                'Operating System: ' + openfl.system.Capabilities.os
                + '\n\n' + developerModeText;
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
        background.graphics.drawRect(0, 0, textField.width + textField.x * 2, textField.height + textField.y * 2);
        background.graphics.endFill();

        background.x = 0;
        background.y = 0;
    }

    function get_memoryMegas():Float
    {
        return cast(System.totalMemory, UInt);
    }
}
