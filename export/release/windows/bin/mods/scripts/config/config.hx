import backend.LanguageManager;

function onCreate()
{
    setupLanguages();

    switchToScriptState('introState');
}

function setupLanguages()
{
    LanguageManager.setLanguages(['english', 'spanish'], ['eng', 'span']);

    LanguageManager.setPhrase('introStatePhrases', [
        [
            'ALE ENGINE BY', 
            'ALE ENGINE BY',
            'ALE ENGINE BY\nALEJOGDOFFICIAL',
            '',
            'POWERED BY',
            'POWERED BY',
            'POWERED BY\nPSYCH ENGINE',
            '',
            'DON\'T TOUCH',
            'DON\'T TOUCH',
            'DON\'T TOUCH\nMY SOURCE CODE',
            '',
            'FRIDAY',
            'FRIDAY\nNIGHT',
            'FRIDAY\nNIGHT\nFUNKIN\'',
            'FRIDAY\nNIGHT\nFUNKIN\'\nALE ENGINE'
        ],
        [
            'ALE ENGINE POR', 
            'ALE ENGINE POR',
            'ALE ENGINE POR\nALEJOGDOFFICIAL',
            '',
            'POTENCIADO POR',
            'POTENCIADO POR',
            'POTENCIADO POR\nPSYCH ENGINE',
            '',
            'NO TOQUES',
            'NO TOQUES',
            'NO TOQUES\nMI CODIGO FUENTE',
            '',
            'FRIDAY',
            'FRIDAY\nNIGHT',
            'FRIDAY\nNIGHT\nFUNKIN\'',
            'FRIDAY\nNIGHT\nFUNKIN\'\nALE ENGINE'
        ]
    ]);
}