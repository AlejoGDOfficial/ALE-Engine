package core.config;

import openfl.Lib;
import openfl.display.StageScaleMode;

import utils.debug.FPSCounter;

import cpp.WindowsCPP;

class MainState extends MusicBeatState
{
    public static var fpsVar:FPSCounter;

    override public function create()
    {
        ClientPrefs.loadPrefs();
    
        WindowsCPP.setWindowLayered();
        WindowsCPP.setWindowBorderColor(32, 32, 32);
    
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

		Mods.pushGlobalMods();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

        super.create();

        #if !mobile
        fpsVar = new FPSCounter();
        FlxG.game.addChild(fpsVar);
        Lib.current.stage.align = "tl";
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        #end

        try
        {
            var jsonToLoad:String = Paths.modFolders('data.json');
            if(!FileSystem.exists(jsonToLoad))
                jsonToLoad = Paths.getSharedPath('data.json');
    
            var jsonData = haxe.Json.parse(sys.io.File.getContent(jsonToLoad));
    
            CoolVars.scriptFromInitialState = jsonData.initialState;
            CoolVars.scriptFromPlayStateIfStoryMode = jsonData.fromPlayStateIfStoryMode;
            CoolVars.scriptFromPlayStateIfFreeplay = jsonData.fromPlayStateIfFreeplay;
            CoolVars.scriptFromEditors = jsonData.fromEditors;
            CoolVars.scriptFromOptions = jsonData.fromOptions;

            trace('Initial State: ' + CoolVars.scriptFromInitialState);
            trace('From PlayState if Story Mode: ' + CoolVars.scriptFromPlayStateIfStoryMode);
            trace('From PlayState if Freeplay: ' + CoolVars.scriptFromPlayStateIfFreeplay);
            trace('From Editors: ' + CoolVars.scriptFromEditors);
            trace('From Options: ' + CoolVars.scriptFromOptions);
        } catch(error:Dynamic) {
            trace(error);
        }

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

        MusicBeatState.switchState(new ScriptState(CoolVars.scriptFromInitialState));
    }
}