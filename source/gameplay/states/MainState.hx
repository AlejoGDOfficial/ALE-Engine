package states;

import openfl.Lib;
import openfl.display.StageScaleMode;

import debug.FPSCounter;

import cpp.WindowsCPP;

class MainState extends MusicBeatState
{
    fpsVar:FPSCounter;

    override public function create()
    {
        ClientPrefs.loadPrefs();

        AlphaCharacter.loadAlphabetData();
    
        WindowsCPP.setWindowLayered();

        WindowsCPP.setWindowBorderColor(32, 32, 32);
    
        Paths.clearStoredMemory();

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
        } catch(error:Dynamic) {
            trace(error);
        }

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

        MusicBeatState.switchState(new ScriptState(CoolVars.scriptFromInitialState));
    }
}