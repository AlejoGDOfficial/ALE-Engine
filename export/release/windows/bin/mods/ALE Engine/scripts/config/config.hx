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
    if (getGlobalVar('initialConfig'))
    {
        setGlobalVar('initialConfig', false);
        MusicBeatState.switchState(new ScriptState(getGlobalVar('initialState')));
    } else {
        if (getGlobalVar("reconfigureData")[0])
        {
            MusicBeatState.switchState(new ScriptState(getGlobalVar("reconfigureData")[1]));
        } else {
            switchToSomeStates(getGlobalVar("reconfigureData")[1]);
        }
    }
}