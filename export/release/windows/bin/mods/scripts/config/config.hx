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

function setNewLanguages()
{
    setLanguages(['english', 'spanish'], ['eng', 'span']);

    setupStatesLanguages();
    setupGlobalLanguages();
    setupObjectsLanguages();
    setupOptionsLanguages();
}

function setupGlobalLanguages()
{
    setPhrase('difficultiesEasy', ['Easy', 'Fácil']);
    setPhrase('difficultiesNormal', ['Normal', 'Normal']);
    setPhrase('difficultiesHard', ['Hard', 'Difícil ']);
}

function setupObjectsLanguages()
{
    setPhrase('dialogueSkip', ['Press BACK to Skip', 'Presiona VOLVER para Saltar']);

    setPhrase('fpsTxt', [
        ['DEVELOPER MODE', 'Press F3 to reconfigure the game...', 'FPS: ', 'Memory: ', 'Window Position: ', 'Window Resolution: ', 'Screen Resolution: ', 'Operating System: '], 
        ['MODO DESARROLLADOR', 'Presiona F3 para reconfigurar el juego...', 'FPS: ', 'Memoria: ', 'Posición de la Ventana: ', 'Resolución de la Ventana: ', 'Resolución de la Pantalla: ', 'Sistema Operativo: ']
    ]);
}

function setupOptionsLanguages()
{
    //Note Color / Color de las Notas
    setPhrase('optionsNoteColors', ['Note Colors', 'Color de las Notas']);

    setPhrase('optionsNoteColorsTip', [
        'Press RESET to Reset the selected Note Part', 
        'Presiona REINICIAR para Reiniciar la Parte seleccionada de la Nota'
    ]);
    setPhrase('optionsNoteColorsHoldTip', [
        ['Hold ', ' + Press RESET key to fully reset the selected Note.'], 
        ['Mantén presionado ', ' + presiona RESET para reiniciar por completo la Note Seleccionada.']
    ]);
    
    setPhrase('optionsNoteColorsLB', ['Left Shoulder Button', 'Botón de Hombro Izquierdo']);
    
    //Controls / Controles
    setPhrase('optionsControls', ['Controls', 'Controles']);

    setPhrase('optionsControlsGroupNotes', ['NOTES', 'NOTAS']);
    setPhrase('optionsControlsGroupUI', ['UI', 'MENUS']);
    setPhrase('optionsControlsGroupVolume', ['VOLUME', 'VOLUMEN']);
    setPhrase('optionsControlsGroupDebug', ['DEBUG', 'DEPURACION']);

    setPhrase('optionsControlsKeyNoteLeft', ['Left', 'Izq.']);
    setPhrase('optionsControlsKeyNoteDown', ['Down', 'Abaj.']);
    setPhrase('optionsControlsKeyNoteUp', ['Up', 'Arri.']);
    setPhrase('optionsControlsKeyNoteRight', ['Right', 'Der.']);

    setPhrase('optionsControlsKeyUILeft', ['Left', 'Izq.']);
    setPhrase('optionsControlsKeyUIDown', ['Down', 'Abaj.']);
    setPhrase('optionsControlsKeyUIUp', ['Up', 'Arri.']);
    setPhrase('optionsControlsKeyUIRight', ['Right', 'Der.']);

    setPhrase('optionsControlsKeyReset', ['Reset', 'Reinic.']);
    setPhrase('optionsControlsKeyAccept', ['Accept', 'Acept.']);
    setPhrase('optionsControlsKeyBack', ['Back', 'Volver']);
    setPhrase('optionsControlsKeyPause', ['Pause', 'Pausa']);
    
    setPhrase('optionsControlsKeyVolumeMute', ['Mute', 'Silen.']);
    setPhrase('optionsControlsKeyVolumeUp', ['Up', 'Subir']);
    setPhrase('optionsControlsKeyVolumeDown', ['Down', 'Bajar']);
    
    setPhrase('optionsControlsKeyDebug1', ['Cht. Ed.', 'Ed. Cht.']);
    setPhrase('optionsControlsKeyDebug2', ['Ch. Ed.', 'Ed. Prs.']);
    
    setPhrase('optionsControlsRebinding1', ['Rebinding ', 'Re-Asignando ']);
    setPhrase('optionsControlsRebinding2', ['Hold Esc to Cancel\nHold BackSpace to Delete', 'Esc para Cancelar\nBKSP para Borrar']);
    
    setPhrase('optionsControlsResetToDefaultKeys', ['Reset to Default Keys', 'Restablecer Controles']);

    //Adjust Delay and Combo / Ajustar Retraso y Combo
    setPhrase('optionsAdjustDelayAndCombo', ['Adjust Delay and Combo', 'Ajustar Retraso y Combo']);

    setPhrase('optionsAdjustDelayAndComboSwitchOnAccept', ['(Press ACCEPT to Switch)', '(Presiona ACEPTAR para Cambiar)']);
    setPhrase('optionsAdjustDelayAndComboSwitchOnStart', ['(Press Start to Switch)', '(Presiona Start para Cambiar)']);

    setPhrase('optionsAdjustDelayAndComboRatingOffset', ['Rating Offset: ', 'Compensación de la Puntuación:']);
    setPhrase('optionsAdjustDelayAndComboNumbersOffset', ['Numbers Offset: ', 'Compensación de los Números:']);

    setPhrase('optionsAdjustDelayAndComboComboOffset', ['Combo Offset', 'Compensación del Combo']);
    setPhrase('optionsAdjustDelayAndComboNoteDelay', ['Note/Beat Delay', 'Retraso de las Notas']);
    
    setPhrase('optionsAdjustDelayAndComboBeatHit', ['Beat Hit!', 'Golpe de Beat!']);
    setPhrase('optionsAdjustDelayAndComboDelayCurrentOffset', [['Current Offset: ', ' ms'], ['Compensación Actual: ', ' ms']]);
    
    //Graphics / Gráficos
    setPhrase('optionsGraphics', ['Graphics', 'Gráficos']);
    setPhrase('optionsGraphicsMenu', ['Graphics Settings', 'Configuraciones de Gráficos']);

    setPhrase('optionsGraphicsLowQuality', ['Low Quality', 'Baja Calidad']);
    setPhrase('optionsGraphicsLowQualityDesc', [
        'If checked, disables some background details, decreases loading times and improves performance', 
        'Si es marcado, remueve algunos detalles en los fondos, disminuyendo los tiempos de carga y mejorando el rendimiento.'
    ]);
    setPhrase('optionsGraphicsAntiAliasing', ['Anti-Aliasing', 'Suavizado de Bordes']);
    setPhrase('optionsGraphicsAntiAliasingDesc', [
        'If unchecked, disables anti-aliasing, increases performance at cost of sharper visuals.', 
        'Si es desmarcado, desactiva el suavizado, aumentando el rendimiento al costo de mayor nitidez visual.'
    ]);
    setPhrase('optionsGraphicsShaders', ['Shaders', 'Shaders']);
    setPhrase('optionsGraphicsShadersDesc', [
        'If unchecked, disables shaders. It\'s used for some visual effects, and also CPU intensive for weaker PCs.', 
        'Si es desmarcado, desactiva los shaders. Son usados para algunos efectos visuales, y también para un uso intensivo de la CPU en las PCs más débiles.'
    ]);
    setPhrase('optionsGraphicsGPUCaching', ['GPU Caching', 'Almacenamiento en el caché de la CPU']);
    setPhrase('optionsGraphicsGPUCachingDesc', [
        'If checked, allows the GPU to be used for caching textures, decreasing RAM usage. Don\'t turn this on if you have a shitty Graphics Card.', 
        'Si es marcado, permite que la GPU sea usada para almacenar texturas en caché, disminuyendo el uso de RAM. No actives esto si tienes una Targeta Gráfica de mierda.'
    ]);
    setPhrase('optionsGraphicsFramerate', ['Framerate', 'Tasa de Actualización']);
    setPhrase('optionsGraphicsFramerateDesc', [
        'Pretty self explanatorio, isn\'t it?', 
        'Se explica solo, no?'
    ]);
    
    //Visuals / Visuales
    setPhrase('optionsVisuals', ['Visuals', 'Visuales']);
    setPhrase('optionsVisualsMenu', ['Visuals Settings', 'Opciones Visuales']);

    setPhrase('optionsVisualsSplashOpacity', ['Note Splash Opacity', 'Opacidad de las Salpicaduras']);
    setPhrase('optionsVisualsSplashOpacityDesc', [
        'How much transparent should the Note Splashes be.', 
        'Qué tan transparentes deben ser las Salpicaduras.'
    ]);
    setPhrase('optionsVisualsFlashingLights', ['Flashing Lights', 'Luces Interminentes']);
    setPhrase('optionsVisualsFlashingLightsDesc', [
        'Uncheck this if you\'re sensitive to flashing lights!', 
        'Desactiva esto si eres sensible a las luces intermitentes!'
    ]);
    setPhrase('optionsVisualsPauseMusic', ['Flashing Lights', 'Luces Interminentes']);
    setPhrase('optionsVisualsPauseMusicDesc', [
        'What song do you prefer for the Pause Screen?', 
        'Qué canción prefieres que suene cuando Pausas?'
    ]);
    setPhrase('optionsVisualsDiscordRichPresence', ['Discord Rich Presence', 'Rich Presence de Discord']);
    setPhrase('optionsVisualsDiscordRichPresenceDesc', [
        'Uncheck this to prevent accidental leaks, it will hide the Application from your "Playing" box on Discord.', 
        'Desmarca esto para evitar filtraciones, esto ocultará a la Aplicación de tu sección "Jugando" de Discord.'
    ]);
    setPhrase('optionsVisualsDiscordComboStacking', ['Combo Stacking', 'Apilación del Combo']);
    setPhrase('optionsVisualsDiscordComboStackingDesc', [
        'If unchecked, Ratings and Combo won\'t stack, saving on System Memory and making them easier to read.', 
        'Si es desmarcado, las Puntuaciones y los Combos no se apilarán, guardandose en la Memoria del Sistema y haciéndolos más fáciles de leer.'
    ]);

    //Gameplay / Jugabilidad
    setPhrase('optionsGameplay', ['Gameplay', 'Jugabilidad']);
    setPhrase('optionsGameplayMenu', ['Gameplay Settings', 'Opciones de Jugabilidad']);
    setPhrase('optionsGameplayDownscroll', ['Downscroll', 'Desplazamiento hacia abajo']);
    setPhrase('optionsGameplayDownscrollDesc', [
        'If checked, notes go Down insted of Up, simple enough.', 
        'Si es marcado, las notas iran hacia Abajo en vez de ir hacia Arriba, bastante simple.'
    ]);
    setPhrase('optionsGameplayGhostTapping', ['Ghost Tapping', 'Toque Fantasma']);
    setPhrase('optionsGameplayGhostTappingDesc', [
        'If checked, you won\'t get misses from pressing keys while there are no notes able to be hit.', 
        'Si es marcada, no vas a tener Errores presionando las teclas mientras no hayan notas que se deban golpear.'
    ]);
    setPhrase('optionsGameplayAutoPause', ['Auto Pause', 'Pausa Automática']);
    setPhrase('optionsGameplayAutoPauseDesc', [
        'If checked, the game automatically pauses if the screen isn\'t on focus.', 
        'Si es marcada, el juego automáticamente se detendrá si se desenfoca la ventana del mismo.'
    ]);
    setPhrase('optionsGameplayDisableResetButton', ['Disable Reset Button', 'Desactivar el botón para Reiniciar']);
    setPhrase('optionsGameplayDisableResetButtonDesc', [
        'If checked, pressing Reset won\'t do anything.', 
        'Si es marcada, presionar Reset no hará nada'
    ]);
    setPhrase('optionsGameplayRatingOffset', ['Rating Offset', 'Compensación de la Puntuación']);
    setPhrase('optionsGameplayRatingOffsetDesc', [
        'Changes how late/early you have to hit for a "Sick!!" Higher values mean you have to hit later.', 
        'Cambia que tan tarde/temprano debes golpear una nota para un "Perfecto!!" Entre más alto sea el valor, más tarde debes golpear la nota.'
    ]);
    setPhrase('optionsGameplaySickHitWindow', ['Sick!! Hit Window', 'Margen de Acierto para un Perfecto!!']);
    setPhrase('optionsGameplaySickHitWindowDesc', [
        'Changes the amount of time you have for hitting a "Sick!!" in milliseconds.', 
        'Cambia la cantidad de tiempo que tienes para obtener un "Perfecto!!" en milisegundos.'
    ]);
    setPhrase('optionsGameplayGoodHitWindow', ['Good! Hit Window', 'Margen de Acierto para un Bien!']);
    setPhrase('optionsGameplayGoodHitWindowDesc', [
        'Changes the amount of time you have for hitting a "Good!" in milliseconds.', 
        'Cambia la cantidad de tiempo que tienes para obtener un "Bien!" en milisegundos.'
    ]);
    setPhrase('optionsGameplayBadHitWindow', ['Bad Hit Window', 'Margen de Acierto para "Bad"']);
    setPhrase('optionsGameplayBadHitWindowDesc', [
        'Changes the amount of time you have for hitting a "Bad" in milliseconds.', 
        'Cambia la cantidad de tiempo que tienes para obtener un "Mal" en milisegundos.'
    ]);
    setPhrase('optionsGameplaySafeFrames', ['Safe Frames', 'Margen de Acierto']);
    setPhrase('optionsGameplaySafeFramesDesc', [
        'Changes how many frames you have for hitting a note earlier or late.',
        'Cambia la cantidad de fotogramas que tienes para golpear una nota tarde o temprano.'
    ]);
    
    //Language / Idioma
    setPhrase('optionsLanguage', ['Language', 'Idioma']);
    setPhrase('optionsLanguageEnglish', ['English', 'Inglés']);
    setPhrase('optionsLanguageSpanish', ['Spanish', 'Español']);
}

function setupStatesLanguages()
{
    //Play State
    setPhrase('playStateScoreTxt', [['Score: ', 'Misses: ', 'Rating: '], ['Puntaje: ', 'Errores: ', 'Calificación: ']]);
    setPhrase('playStateBotPlay', ['BotPlay', 'Automático']);

    //Intro State
    setPhrase('introStatePhrases', [
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

    //Loading State
    setPhrase('loadingStateLoadingTxt', ['Now loading', 'Cargando']);

    //Pause SubState
    setPhrase('pauseSubStateResume', ['Resume', 'Resumir']);
    setPhrase('pauseSubStateRestartSong', ['Restart Song', 'Reiniciar la Canción']);
    setPhrase('pauseSubStateLeaveCharting Mode', ['Leave Charting Mode', 'Salir del Modo Charter']);
    setPhrase('pauseSubStateSkipTime', ['Skip Time', 'Adelantar/Restrasar canción a']);
    setPhrase('pauseSubStateEndSong', ['End Song', 'Terminar la Canción']);
    setPhrase('pauseSubStateChangeDifficulty', ['Change Difficulty', 'Cambiar la Dificultad']);
    setPhrase('pauseSubStateBack', ['Back', 'Volver']);
    setPhrase('pauseSubStateTogglePractice Mode', ['Toggle Practice Mode', 'Alternar Modo Práctica']);
    setPhrase('pauseSubStateToggleBotPlay', ['Toggle BotPlay', 'Alternar Modo Automático']);
    setPhrase('pauseSubStateOptions', ['Options', 'Opciones']);
    setPhrase('pauseSubStateExitToMenu', ['Exit to Menu', 'Volver al Menú']);
    setPhrase('pauseSubStatePracticeMode', ['Practice Mode', 'Modo Práctica']);
    setPhrase('pauseSubStateChartingMode', ['Charting Mode', 'Modo Charter']);

    setPhrase('pauseSubStateBlueBalled', ['BlueBalled: ', 'Muertes: ']);

    //Freeplay State
    setPhrase('freeplayStateResetScore', ['Reset the score of', 'Reiniciar el puntaje de']);
    setPhrase('freeplayStateYes', ['Yes', 'No']);
    setPhrase('freeplayStateNo', ['No', 'No']);
}

function finishConfig()
{
    if (getGlobalVar('initialConfig'))
    {
        showFPSText();
        setGlobalVar('initialConfig', false);
        switchToScriptState('introState');
    } else {
        if (getGlobalVar("reconfigureData")[0])
        {
            switchToScriptState(getGlobalVar("reconfigureData")[1]);
        } else {
            switchToSomeStates(getGlobalVar("reconfigureData")[1]);
        }
    }
}