import backend.LanguageManager;

function onCreate()
{
    setupLanguages();

    switchToScriptState('introState');
}

function setupLanguages()
{
    LanguageManager.setLanguages(['English', 'Spanish'], ['eng', 'span']);
}