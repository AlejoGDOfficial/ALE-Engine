function onCreate()
{
    setGlobalVars();

    finishConfig();
}

function setGlobalVars()
{
    setGlobalVar('developerMode', true);

    setGlobalVar('initialState', 'introState');
    setGlobalVar('fromPlayStateIfStoryMode', 'storyMenuState');
    setGlobalVar('fromPlayStateIfFreeplay', 'freeplayState');
    setGlobalVar('fromEditors', 'masterEditorMenu');
    setGlobalVar('fromOptions', 'mainMenuState');
}

function finishConfig()
{
    MusicBeatState.switchState(new ScriptState(getGlobalVar('initialState')));
}