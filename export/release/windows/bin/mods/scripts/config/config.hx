import backend.LanguageManager;

function onCreate()
{
    LanguageManager.setLanguages(['english', 'spanish'], ['eng', 'span']);

    setupObjectsLanguages();
    setupStatesLanguages();
    setupOptionsLanguages();

    switchToScriptState('introState');
}

function setupObjectsLanguages()
{
    LanguageManager.setPhrase('dialogueSkip', ['Press BACK to Skip', 'Presiona VOLVER para Saltar']);
}

function setupStatesLanguages()
{
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

    LanguageManager.setPhrase('loadingStateLoadingTxt', ['Now loading', 'Cargando']);
}

function setupOptionsLanguages()
{
    //Note Color / Color de las Notas
    LanguageManager.setPhrase('optionsNoteColors', ['Note Colors', 'Color de las Notas']);

    LanguageManager.setPhrase('optionsNoteColorsTip', [
        'Press RESET to Reset the selected Note Part', 
        'Presiona REINICIAR para Reiniciar la Parte seleccionada de la Nota'
    ]);
    LanguageManager.setPhrase('optionsNoteColorsHoldTip', [
        'Hold Shift + Press RESET key to fully reset the selected Note.', 
        'Mantén presionado Shift + presina RESET para reiniciar por completo la Note Seleccionada.'
    ]);
    
    LanguageManager.setPhrase('optionsNoteColorsLB', ['Shift', 'Botón de Hombro Izquierdo']);
    
    //Controls / Controles
    LanguageManager.setPhrase('optionsControls', ['Controls', 'Controles']);

    LanguageManager.setPhrase('optionsControlsGroupNotes', ['NOTES', 'NOTAS']);
    LanguageManager.setPhrase('optionsControlsGroupUI', ['UI', 'MENUS']);
    LanguageManager.setPhrase('optionsControlsGroupVolume', ['VOLUME', 'VOLUMEN']);
    LanguageManager.setPhrase('optionsControlsGroupDebug', ['DEBUG', 'DEPURACION']);

    LanguageManager.setPhrase('optionsControlsKeyNoteLeft', ['Left', 'Izq.']);
    LanguageManager.setPhrase('optionsControlsKeyNoteDown', ['Down', 'Abaj.']);
    LanguageManager.setPhrase('optionsControlsKeyNoteUP', ['Up', 'Arri.']);
    LanguageManager.setPhrase('optionsControlsKeyNoteRight', ['Right', 'Der.']);

    LanguageManager.setPhrase('optionsControlsKeyUILeft', ['Left', 'Izq.']);
    LanguageManager.setPhrase('optionsControlsKeyUIDown', ['Down', 'Abaj.']);
    LanguageManager.setPhrase('optionsControlsKeyUIUP', ['Up', 'Arri.']);
    LanguageManager.setPhrase('optionsControlsKeyUIRight', ['Right', 'Der.']);

    LanguageManager.setPhrase('optionsControlsKeyReset', ['Reset', 'Reinic.']);
    LanguageManager.setPhrase('optionsControlsKeyAccept', ['Accept', 'Acept.']);
    LanguageManager.setPhrase('optionsControlsKeyBack', ['Back', 'Volver']);
    LanguageManager.setPhrase('optionsControlsKeyPause', ['Pause', 'Pausa']);
    
    LanguageManager.setPhrase('optionsControlsKeyVolumeMute', ['Mute', 'Silen.']);
    LanguageManager.setPhrase('optionsControlsKeyVolumeUp', ['Up', 'Subir']);
    LanguageManager.setPhrase('optionsControlsKeyVolumeDown', ['Down', 'Bajar']);
    
    LanguageManager.setPhrase('optionsControlsKeyDebug1', ['Cht. Ed.', 'Ed. Cht.']);
    LanguageManager.setPhrase('optionsControlsKeyDebug2', ['Ch. Ed.', 'Ed. Prs.']);
    
    LanguageManager.setPhrase('optionsControlsRebinding1', ['Mute', 'Silen.']);
    LanguageManager.setPhrase('optionsControlsRebinding2', ['Up', 'Subir']);
    
    LanguageManager.setPhrase('optionsControlsResetToDefaultKeys', ['Reset to Default Keys', 'Restablecer Controles']);

    //Adjust Delay and Combo / Ajustar Retraso y Combo
    LanguageManager.setPhrase('optionsAdjustDelayAndCombo', ['Adjust Delay and Combo', 'Ajustar Retraso y Combo']);

    LanguageManager.setPhrase('optionsAdjustDelayAndComboSwithcOnAccept', ['(Press ACCEPT to Switch)', '(Presiona ACEPTAR para Cambiar)']);
    LanguageManager.setPhrase('optionsAdjustDelayAndComboSwithcOnStart', ['(Press Start to Switch)', '(Presiona Start para Cambiar)']);

    LanguageManager.setPhrase('optionsAdjustDelayAndComboComboOffset', ['Combo Offset', 'Compensación del Combo']);
    LanguageManager.setPhrase('optionsAdjustDelayAndComboRatingOffset', ['Rating Offset: ', 'Compensación de la Puntuación: ']);
    LanguageManager.setPhrase('optionsAdjustDelayAndComboNumbersOffset', ['Numbers Offset: ', 'Compensación de los Números: ']);

    LanguageManager.setPhrase('optionsAdjustDelayAndComboNoteDelay', ['Note/Beat Delay', 'Retraso de las Notas']);
    LanguageManager.setPhrase('optionsAdjustDelayAndComboBeatHit', ['Beat Hit!', 'Golpe de Beat!']);
    LanguageManager.setPhrase('optionsAdjustDelayAndComboDelayCurrentOffset', [['Current Offset: ', ' ms'], ['Compensación Actual: ', ' ms']]);
    
    //Graphics / Gráficos
    LanguageManager.setPhrase('optionsGraphics', ['Graphics', 'Gráficos']);
    LanguageManager.setPhrase('optionsGraphicsMenu', ['Graphics Settings', 'Configuraciones de Gráficos']);

    LanguageManager.setPhrase('optionsGraphicsLowQuality', ['Low Quality', 'Baja Calidad']);
    LanguageManager.setPhrase('optionsGraphicsLowQualityDesc', [
        'If checked, disables some background details, decreases loading times and improves performance', 
        'Si es marcado, remueve algunos detalles en los fondos, disminuyendo los tiempos de carga y mejorando el rendimiento.'
    ]);
    LanguageManager.setPhrase('optionsGraphicsAntiAliasing', ['Anti-Aliasing', 'Suavizado de Bordes']);
    LanguageManager.setPhrase('optionsGraphicsAntiAliasingDesc', [
        'If unchecked, disables anti-aliasing, increases performance at cost of sharper visuals.', 
        'Si es desmarcado, desactiva el suavizado, aumentando el rendimiento al costo de mayor nitidez visual.'
    ]);
    LanguageManager.setPhrase('optionsGraphicsShaders', ['Shaders', 'Shaders']);
    LanguageManager.setPhrase('optionsGraphicsShadersDesc', [
        'If unchecked, disables shaders. It\'s used for some visual effects, and also CPU intensive for weaker PCs.', 
        'Si es desmarcado, desactiva los shaders. Son usados para algunos efectos visuales, y también para un uso intensivo de la CPU en las PCs más débiles.'
    ]);
    LanguageManager.setPhrase('optionsGraphicsGPUCaching', ['GPU Caching', 'Almacenamiento en el caché de la CPU']);
    LanguageManager.setPhrase('optionsGraphicsGPUCachingDesc', [
        'If checked, allows the GPU to be used for caching textures, decreasing RAM usage. Don\'t turn this on if you have a shitty Graphics Card.', 
        'Si es marcado, permite que la GPU sea usada para almacenar texturas en caché, disminuyendo el uso de RAM. No actives esto si tienes una Targeta Gráfica de mierda.'
    ]);
    LanguageManager.setPhrase('optionsGraphicsFramerate', ['Framerate', 'Tasa de Actualización']);
    LanguageManager.setPhrase('optionsGraphicsFramerateDesc', [
        'Pretty self explanatorio, isn\'t it?', 
        'Se explica solo, no?'
    ]);
    
    //Visuals / Visuales
    LanguageManager.setPhrase('optionsVisuals', ['Visuals', 'Visuales']);
    LanguageManager.setPhrase('optionsVisualsMenu', ['Visuals Settings', 'Opciones Visuales']);

    LanguageManager.setPhrase('optionsVisualsSplashOpacity', ['Note Splash Opacity', 'Opacidad de las Salpicaduras']);
    LanguageManager.setPhrase('optionsVisualsSplashOpacityDesc', [
        'How much transparent should the Note Splashes be.', 
        'Qué tan transparentes deben ser las Salpicaduras.'
    ]);
    LanguageManager.setPhrase('optionsVisualsFlashingLights', ['Flashing Lights', 'Luces Interminentes']);
    LanguageManager.setPhrase('optionsVisualsFlashingLightsDesc', [
        'Uncheck this if you\'re sensitive to flashing lights!', 
        'Desactiva esto si eres sensible a las luces intermitentes!'
    ]);
    LanguageManager.setPhrase('optionsVisualsPauseMusic', ['Flashing Lights', 'Luces Interminentes']);
    LanguageManager.setPhrase('optionsVisualsPauseMusicDesc', [
        'What song do you prefer for the Pause Screen?', 
        'Qué canción prefieres que suene cuando Pausas?'
    ]);
    LanguageManager.setPhrase('optionsVisualsDiscordRichPresence', ['Discord Rich Presence', 'Rich Presence de Discord']);
    LanguageManager.setPhrase('optionsVisualsDiscordRichPresenceDesc', [
        'Uncheck this to prevent accidental leaks, it will hide the Application from your "Playing" box on Discord.', 
        'Desmarca esto para evitar filtraciones, esto ocultará a la Aplicación de tu sección "Jugando" de Discord.'
    ]);
    LanguageManager.setPhrase('optionsVisualsDiscordComboStacking', ['Combo Stacking', 'Apilación del Combo']);
    LanguageManager.setPhrase('optionsVisualsDiscordComboStackingDesc', [
        'If unchecked, Ratings and Combo won\'t stack, saving on System Memory and making them easier to read.', 
        'Si es desmarcado, las Puntuaciones y los Combos no se apilarán, guardandose en la Memoria del Sistema y haciéndolos más fáciles de leer.'
    ]);

    //Gameplay / Jugabilidad
    LanguageManager.setPhrase('optionsGameplay', ['Gameplay', 'Jugabilidad']);
    LanguageManager.setPhrase('optionsGameplayMenu', ['Gameplay Settings', 'Opciones de Jugabilidad']);
    LanguageManager.setPhrase('optionsGameplay', ['', '']);
    LanguageManager.setPhrase('optionsGameplayDesc', [
        '', 
        ''
    ]);
    LanguageManager.setPhrase('optionsGameplay', ['', '']);
    LanguageManager.setPhrase('optionsGameplayDesc', [
        '', 
        ''
    ]);
    LanguageManager.setPhrase('optionsGameplay', ['', '']);
    LanguageManager.setPhrase('optionsGameplayDesc', [
        '', 
        ''
    ]);
    LanguageManager.setPhrase('optionsGameplay', ['', '']);
    LanguageManager.setPhrase('optionsGameplayDesc', [
        '', 
        ''
    ]);
    LanguageManager.setPhrase('optionsGameplay', ['', '']);
    LanguageManager.setPhrase('optionsGameplayDesc', [
        '', 
        ''
    ]);
    LanguageManager.setPhrase('optionsGameplay', ['', '']);
    LanguageManager.setPhrase('optionsGameplayDesc', [
        '', 
        ''
    ]);
    LanguageManager.setPhrase('optionsGameplay', ['', '']);
    LanguageManager.setPhrase('optionsGameplayDesc', [
        '', 
        ''
    ]);
    LanguageManager.setPhrase('optionsGameplay', ['', '']);
    LanguageManager.setPhrase('optionsGameplayDesc', [
        '', 
        ''
    ]);
    LanguageManager.setPhrase('optionsGameplay', ['', '']);
    LanguageManager.setPhrase('optionsGameplayDesc', [
        '', 
        ''
    ]);
    
    //Language / Idioma
    LanguageManager.setPhrase('optionsLanguage', ['Language', 'Idioma']);
}
/*
// Difficulties
difficulty_easy: "Fácil"
difficulty_normal: "Normal"
difficulty_hard: "Difícil"
*/