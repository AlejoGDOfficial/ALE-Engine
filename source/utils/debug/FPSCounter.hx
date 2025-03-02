package utils.debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.system.Capabilities;
#if cpp import cpp.vm.Gc; #end
import flixel.util.FlxStringUtil;
import haxe.ds.StringMap;
import haxe.Timer;
import openfl.display.DisplayObject;
import openfl.events.Event;
import flash.events.KeyboardEvent;

@:access(core.backend.MusicBeatState)
class FPSCounter extends Sprite
{
    var fields:Array<TextField>;
    var visibility:Array<Bool>;
    var maps:Array<String>;

    var otherFields:Array<TextField>;
    var otherVisibility:Array<Bool>;
    var otherMaps:Array<String>;

    var shapes:Array<AttachedShape>;

    override public function new()
    {
        super();

        FlxG.signals.preUpdate.add(theUpdate);

        fields = new Array<TextField>();
        visibility = new Array<Bool>();
        maps = new Array<String>();
        
        otherFields = new Array<TextField>();
        otherVisibility = new Array<Bool>();
        otherMaps = new Array<String>();

        shapes = new Array<AttachedShape>();
        
        createDebugText('fpsField', 2, 20, false, true);
        #if windows createDebugText('memoryField', 32, 16, false, true); #end
        createDebugText('developerField', 57, 12, false, CoolVars.developerMode);
        createDebugText('stateField', 80, 16, true, false);
        createDebugText('conductorField', 130, 16, true, true);
        createDebugText('windowField', 240, 16, true, false);
        createDebugText('deviceField', 288, 16, true, false);
        createDebugText('versionField', 345, 16, false, CoolVars.outdated);
        createDebugText('tipsField', 425, 16, false, false);

		FlxG.stage.nativeWindow.addEventListener(Event.DEACTIVATE, onFocusLost);
		FlxG.stage.nativeWindow.addEventListener(Event.ACTIVATE, onFocus);

        activateListeners();
    }

    function activateListeners()
    {
        FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
        FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
    }

    function deactivateListeners()
    {
        FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
        FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
    }
    
    function onFocusLost(event:Event)
    {
        deactivateListeners();
    }

    function onFocus(event:Event)
    {
        activateListeners();
    }

    var ctrlPressed:Bool = false;
    var shiftPressed:Bool = false;
    var pressedF5:Bool = false;
    var pressedF1:Bool = false;
    var pressedF2:Bool = false;
    var pressedF3:Bool = false;
    var pressedF4:Bool = false;

    function onKeyPress(event:KeyboardEvent)
    {
        if (event.keyCode == 17) ctrlPressed = true;

        if (event.keyCode == 16) shiftPressed = true;

        if (ctrlPressed && shiftPressed)
        {
            if (!Std.is(FlxG.state, gameplay.states.game.PlayState) && !Std.is(FlxG.state, core.config.MainState))
            {
                switch (event.keyCode)
                {
                    case 114:
                        if (!pressedF3)
                        {
                            CoolUtil.resetEngine();
    
                            pressedF3 = true;
                        }
                    case 18:
                        if (!pressedF5)
                        {
                            MusicBeatState.instance.openSubState(new gameplay.states.substates.ModsMenuSubState());
    
                            pressedF5 = true;
                        }
                }
            }
            
            switch (event.keyCode)
            {
                case 112:
                    if (!pressedF1)
                    {
                        for (shape in shapes) shape.visible = !shape.visible;

                        pressedF1 = true;
                    }
                case 113:
                    if (!pressedF2)
                    {
                        orientationLeft = !orientationLeft;

                        pressedF2 = true;
                    }
                case 115:
                    if (!pressedF4)
                    {
                        if (CoolVars.outdated) CoolUtil.browserLoad("https://gamebanana.com/mods/562650");

                        pressedF4 = true;
                    }
            }
        } else if (event.keyCode == 114 && !pressedF3) {
            if (selInt < fields.length) selInt++;
            else selInt = 0;
            
            if (selInt == fields.length) for (i in 0...visibility.length) visibility[i] = false;
            else visibility[selInt] = true;

            pressedF3 = true;
        } 
    }
    
    function onKeyRelease(event:KeyboardEvent)
    {
        switch (event.keyCode)
        {
            case 17:
                ctrlPressed = false;
            case 16:
                shiftPressed = false;
            case 112:
                pressedF1 = false;
            case 113:
                pressedF2 = false;
            case 114:
                pressedF3 = false;
            case 115:
                pressedF4 = false;
            case 18:
                pressedF5 = false;
        }
    }
    
    function createDebugText(name:String, y:Int, size:Int, doPush:Bool, condition:Bool)
    {
        var field:TextField = new TextField();
        field.selectable = false;
        field.mouseEnabled = false;
        field.defaultTextFormat = new TextFormat(Paths.font('rajdhani.ttf'), size, 0xFFFFFFFF);
        field.autoSize = LEFT;
        field.multiline = true;
        field.text = 'FPS Counter Text Field';
        field.x = -10;
        field.y = y;
        field.alpha = 0;
        
        var shape:AttachedShape = new AttachedShape(field);
        
        addChild(shape);
        addChild(field);

        if (doPush)
        {
            fields.push(field);
            visibility.push(false);
            maps.push(name);
        } else {
            otherFields.push(field);
            otherVisibility.push(condition);
            otherMaps.push(name);
        }

        shapes.push(shape);
    }
    
    var times:Array<Float> = [];
    
    var currentFPS:Int = 0;
    
    var deltaTimeout:Float = 0.0;

    var orientationLeft:Bool = true;
    
    function theUpdate()
    {
		currentFPS = Math.floor(CoolUtil.fpsLerp(currentFPS, FlxG.elapsed == 0 ? 0 : (1 / FlxG.elapsed), 0.25));
        
        updateText();
    }

    public var selInt = -1;

    public var timer:Float = 0;

    public var memoryPeak:Float = 0;

    function updateText()
    {
        timer += FlxG.elapsed;

        #if cpp if (memoryPeak < Gc.memInfo64(Gc.MEM_INFO_USAGE)) memoryPeak = Gc.memInfo64(Gc.MEM_INFO_USAGE); #end

        if (otherFields != null && otherFields.length > 0)
        {
            for (i in 0...otherFields.length)
            {
                switch (otherMaps[i])
                {
                    case 'fpsField':
                        otherFields[i].text = 'FPS: ' + currentFPS;
                    #if cpp
                    case 'memoryField':
                        otherFields[i].text = 'Memory: ' + FlxStringUtil.formatBytes(Gc.memInfo64(Gc.MEM_INFO_USAGE)) + ' / ' + FlxStringUtil.formatBytes(memoryPeak);
                        otherFields[i].textColor = currentFPS < FlxG.drawFramerate * 0.5 ? FlxColor.PINK : FlxColor.WHITE;
                    #end
                    case 'developerField':
                        otherFields[i].text = (CoolVars.developerMode ? 'DEVELOPER MODE' : '') #if test_build + ' - TEST BUILD - REPORT ITS USE TO @alejogdofficial ON DISCORD' #end;
                    case 'versionField':
                        otherFields[i].text = 'Outdated!' + '\n' + 'Online Version: ' + CoolVars.onlineVersion + '\n' + 'Your Version: ' + CoolVars.engineVersion;
                        otherVisibility[i] = timer < 10 && CoolVars.outdated;
                    case 'tipsField':
                        otherFields[i].text = Std.is(FlxG.state, gameplay.states.game.PlayState) || Std.is(FlxG.state, core.config.MainState) ? 'Press F1 to Toggle FPS Counter Background Visibility' + '\n' + 'Press F2 to Change FPS Counter Orientation' + (CoolVars.outdated ? '\n' + 'Press F4 to Update the Engine' : '') : 'Press ALT to select the mod you want to play' + '\n' + 'Press F1 to Toggle FPS Counter Background Visibility' + '\n' + 'Press F2 to Change FPS Counter Orientation' + '\n' + 'Press F3 to Restart the Engine' + (CoolVars.outdated ? '\n' + 'Press F4 to Update the Engine' : '');
                        otherVisibility[i] = ctrlPressed && shiftPressed;
                    default:
                        otherFields[i].text = '';
                }
    
                otherFields[i].alpha = CoolUtil.fpsLerp(otherFields[i].alpha, otherVisibility[i] ? 1 : 0, 0.2);
                otherFields[i].alpha = Math.max(0, otherFields[i].alpha);
                otherFields[i].x = CoolUtil.fpsLerp(otherFields[i].x, otherVisibility[i] ? (orientationLeft ? 10 : Lib.application.window.width - otherFields[i].width - 10) : (orientationLeft ? -10 : Lib.application.window.width - otherFields[i].width + 10), 0.2);
            }
        }

        if (fields != null && fields.length > 0)
        {
            for (i in 0...fields.length)
            {
                switch (maps[i])
                {
                    case 'stateField':
                        fields[i].text = 'State: ' + (CoolUtil.getCurrentState()[0] ? Type.getClassName(Type.getClass(FlxG.state)) + ' (' + CoolUtil.getCurrentState()[1] + ')' : CoolUtil.getCurrentState()[1]) + '\n' + 'SubState: ' + (CoolUtil.getCurrentSubState()[0] ? Type.getClassName(Type.getClass(FlxG.state.subState)) + ' (' + CoolUtil.getCurrentSubState()[1] + ')' : CoolUtil.getCurrentSubState()[1]);
                    case 'conductorField':
                        fields[i].text = FlxG.sound.music == null ? 'No Song is Playing' : 'Song Position: ' + CoolUtil.floorDecimal(Conductor.songPosition / 1000, 2) + ' / ' + CoolUtil.floorDecimal(FlxG.sound.music.length / 1000, 2) + '\n' + 'Song BPM: ' + Conductor.bpm + '\n' + 'Song Step: ' + MusicBeatState.instance.curStep + '\n' + 'Song Beat: ' + MusicBeatState.instance.curBeat + '\n' + 'Song Section: ' + MusicBeatState.instance.curSection;
                    case 'windowField':
                        fields[i].text = 'Window Position: ' + Lib.application.window.x + ' - ' + Lib.application.window.y + '\n' + 'Window Resolution: ' + Lib.application.window.width + ' x ' + Lib.application.window.height;
                    case 'deviceField':
                        fields[i].text = 'Screen Resolution: ' + Capabilities.screenResolutionX + ' x ' + Capabilities.screenResolutionY + '\n' + 'Operating System: ' + Capabilities.os;
                    default:
                        fields[i].text = '';
                }

                fields[i].alpha = CoolUtil.fpsLerp(fields[i].alpha, visibility[i] ? 1 : 0, 0.2);
                fields[i].alpha = Math.max(0, fields[i].alpha);
                fields[i].x = CoolUtil.fpsLerp(fields[i].x, visibility[i] ? (orientationLeft ? 10 : Lib.application.window.width - fields[i].width - 10) : (orientationLeft ? -10 : Lib.application.window.width - fields[i].width + 10), 0.2);
            }
        }
    }
}

class AttachedShape extends Shape
{
    public var sprTracker:DisplayObject;

    override public function new(sprTracker:DisplayObject)
    {
        super();

        this.sprTracker = sprTracker;

        visible = false;

        addEventListener(Event.ENTER_FRAME, update);
    }

    function update(e:Event)
    {
        graphics.clear();
        graphics.beginFill(0x000000, Math.max(0, sprTracker.alpha - 0.5));
        graphics.beginFill(0x000000, sprTracker.alpha - 0.5);
        graphics.drawRect(sprTracker.x - 10, sprTracker.y, sprTracker.width + 20, sprTracker.height);
        graphics.endFill();
    }
}