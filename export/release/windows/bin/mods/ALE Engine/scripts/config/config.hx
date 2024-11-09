function onCreate()
{
    setNewLanguages();

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
        switchToScriptState(getGlobalVar('initialState'));
    } else {
        if (getGlobalVar("reconfigureData")[0])
        {
            switchToScriptState(getGlobalVar("reconfigureData")[1]);
        } else {
            switchToSomeStates(getGlobalVar("reconfigureData")[1]);
        }
    }
}