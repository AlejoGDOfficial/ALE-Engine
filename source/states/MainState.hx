package states;

import openfl.Lib;
import openfl.display.StageScaleMode;

import debug.FPSCounter;

class MainState extends MusicBeatState
{
    public static var fpsVar:FPSCounter;

    override public function create()
    {
        ClientPrefs.loadPrefs();

        AlphaCharacter.loadAlphabetData();
    
        cpp.WindowsCPP.setWindowLayered();
        cpp.WindowsCPP.setWindowBorderColor(32, 32, 32);
    
        CoolVars.globalVars.set('engineVersion', 'Alpha 6');
    
        Paths.clearStoredMemory();

        super.create();

        #if !mobile
        fpsVar = new FPSCounter();
        FlxG.game.addChild(fpsVar);
        Lib.current.stage.align = "tl";
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        #end

		FlxTransitionableState.skipNextTransIn = true;

        MusicBeatState.switchState(new ScriptState());
    }
}