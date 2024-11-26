package states;

class MainState extends MusicBeatState
{
    override public function create()
    {
        ClientPrefs.loadPrefs();

        LanguageManager.loadPhrases();

        AlphaCharacter.loadAlphabetData();
    
        cpp.WindowsCPP.setWindowLayered();
        cpp.WindowsCPP.setWindowBorderColor(32, 32, 32);
    
        CoolVars.globalVars.set('initialConfig', true);
        CoolVars.globalVars.set('engineVersion', 'Alpha 5');
    
        Paths.clearStoredMemory();

        super.create();

		FlxTransitionableState.skipNextTransIn = true;

        MusicBeatState.switchState(new ScriptState());
    }
}