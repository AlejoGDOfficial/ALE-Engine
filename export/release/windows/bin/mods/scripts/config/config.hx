import backend.LanguageManager;
import backend.CoolVars;
import states.ScriptState;

var initialConfig:Bool = CoolVars.scriptInitialConfig;

function onCreate()
{
    setLanguages();

    CoolVars._developerMode = true;
    CoolVars.initialState = 'introState';
	CoolVars.fromPlayStateIfStoryMode = 'storyMenuState';
	CoolVars.fromPlayStateIfFreeplay = 'freeplayState';
	CoolVars.fromEditors = 'masterEditorMenu';
	CoolVars.fromOptions = 'mainMenuState';

    finishConfig();
}

function setLanguages()
{
    LanguageManager.setLanguages(['english', 'spanish'], ['eng', 'span']);

    setupGlobalLanguages();
    setupObjectsLanguages();
    setupOptionsLanguages();
    setupStatesLanguages();
}

function setupGlobalLanguages()
{
    LanguageManager.setPhrase('difficultiesEasy', ['Easy', 'Fácil']);
    LanguageManager.setPhrase('difficultiesNormal', ['Normal', 'Normal']);
    LanguageManager.setPhrase('difficultiesHard', ['Hard', 'Difícil ']);
}

function setupObjectsLanguages()
{
    LanguageManager.setPhrase('dialogueSkip', ['Press BACK to Skip', 'Presiona VOLVER para Saltar']);

    LanguageManager.setPhrase('fpsTxt', [
        ['DEVELOPER MODE', 'FPS: ', 'Memory: ', 'Window Position: ', 'Window Resolution: ', 'Screen Resolution: ', 'Operating System: '],
        ['MODO DESARROLLADOR', 'FPS: ', 'Memoria: ', 'Posición de la Ventana: ', 'Resolución de la Ventana: ', 'Resolución de la Pantalla: ', 'Sistema Operativo: ']
    ]);
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
        ['Hold ', ' + Press RESET key to fully reset the selected Note.'], 
        ['Mantén presionado ', ' + presiona RESET para reiniciar por completo la Note Seleccionada.']
    ]);
    
    LanguageManager.setPhrase('optionsNoteColorsLB', ['Left Shoulder Button', 'Botón de Hombro Izquierdo']);
    
    //Controls / Controles
    LanguageManager.setPhrase('optionsControls', ['Controls', 'Controles']);

    LanguageManager.setPhrase('optionsControlsGroupNotes', ['NOTES', 'NOTAS']);
    LanguageManager.setPhrase('optionsControlsGroupUI', ['UI', 'MENUS']);
    LanguageManager.setPhrase('optionsControlsGroupVolume', ['VOLUME', 'VOLUMEN']);
    LanguageManager.setPhrase('optionsControlsGroupDebug', ['DEBUG', 'DEPURACION']);

    LanguageManager.setPhrase('optionsControlsKeyNoteLeft', ['Left', 'Izq.']);
    LanguageManager.setPhrase('optionsControlsKeyNoteDown', ['Down', 'Abaj.']);
    LanguageManager.setPhrase('optionsControlsKeyNoteUp', ['Up', 'Arri.']);
    LanguageManager.setPhrase('optionsControlsKeyNoteRight', ['Right', 'Der.']);

    LanguageManager.setPhrase('optionsControlsKeyUILeft', ['Left', 'Izq.']);
    LanguageManager.setPhrase('optionsControlsKeyUIDown', ['Down', 'Abaj.']);
    LanguageManager.setPhrase('optionsControlsKeyUIUp', ['Up', 'Arri.']);
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
    
    LanguageManager.setPhrase('optionsControlsRebinding1', ['Rebinding ', 'Re-Asignando ']);
    LanguageManager.setPhrase('optionsControlsRebinding2', ['Hold Esc to Cancel\nHold BackSpace to Delete', 'Esc para Cancelar\nBKSP para Borrar']);
    
    LanguageManager.setPhrase('optionsControlsResetToDefaultKeys', ['Reset to Default Keys', 'Restablecer Controles']);

    //Adjust Delay and Combo / Ajustar Retraso y Combo
    LanguageManager.setPhrase('optionsAdjustDelayAndCombo', ['Adjust Delay and Combo', 'Ajustar Retraso y Combo']);

    LanguageManager.setPhrase('optionsAdjustDelayAndComboSwitchOnAccept', ['(Press ACCEPT to Switch)', '(Presiona ACEPTAR para Cambiar)']);
    LanguageManager.setPhrase('optionsAdjustDelayAndComboSwitchOnStart', ['(Press Start to Switch)', '(Presiona Start para Cambiar)']);

    LanguageManager.setPhrase('optionsAdjustDelayAndComboRatingOffset', ['Rating Offset: ', 'Compensación de la Puntuación:']);
    LanguageManager.setPhrase('optionsAdjustDelayAndComboNumbersOffset', ['Numbers Offset: ', 'Compensación de los Números:']);

    LanguageManager.setPhrase('optionsAdjustDelayAndComboComboOffset', ['Combo Offset', 'Compensación del Combo']);
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
    LanguageManager.setPhrase('optionsGameplayDownscroll', ['Downscroll', 'Desplazamiento hacia abajo']);
    LanguageManager.setPhrase('optionsGameplayDownscrollDesc', [
        'If checked, notes go Down insted of Up, simple enough.', 
        'Si es marcado, las notas iran hacia Abajo en vez de ir hacia Arriba, bastante simple.'
    ]);
    LanguageManager.setPhrase('optionsGameplayGhostTapping', ['Ghost Tapping', 'Toque Fantasma']);
    LanguageManager.setPhrase('optionsGameplayGhostTappingDesc', [
        'If checked, you won\'t get misses from pressing keys while there are no notes able to be hit.', 
        'Si es marcada, no vas a tener Errores presionando las teclas mientras no hayan notas que se deban golpear.'
    ]);
    LanguageManager.setPhrase('optionsGameplayAutoPause', ['Auto Pause', 'Pausa Automática']);
    LanguageManager.setPhrase('optionsGameplayAutoPauseDesc', [
        'If checked, the game automatically pauses if the screen isn\'t on focus.', 
        'Si es marcada, el juego automáticamente se detendrá si se desenfoca la ventana del mismo.'
    ]);
    LanguageManager.setPhrase('optionsGameplayDisableResetButton', ['Disable Reset Button', 'Desactivar el botón para Reiniciar']);
    LanguageManager.setPhrase('optionsGameplayDisableResetButtonDesc', [
        'If checked, pressing Reset won\'t do anything.', 
        'Si es marcada, presionar Reset no hará nada'
    ]);
    LanguageManager.setPhrase('optionsGameplayRatingOffset', ['Rating Offset', 'Compensación de la Puntuación']);
    LanguageManager.setPhrase('optionsGameplayRatingOffsetDesc', [
        'Changes how late/early you have to hit for a "Sick!!" Higher values mean you have to hit later.', 
        'Cambia que tan tarde/temprano debes golpear una nota para un "Perfecto!!" Entre más alto sea el valor, más tarde debes golpear la nota.'
    ]);
    LanguageManager.setPhrase('optionsGameplaySickHitWindow', ['Sick!! Hit Window', 'Margen de Acierto para un Perfecto!!']);
    LanguageManager.setPhrase('optionsGameplaySickHitWindowDesc', [
        'Changes the amount of time you have for hitting a "Sick!!" in milliseconds.', 
        'Cambia la cantidad de tiempo que tienes para obtener un "Perfecto!!" en milisegundos.'
    ]);
    LanguageManager.setPhrase('optionsGameplayGoodHitWindow', ['Good! Hit Window', 'Margen de Acierto para un Bien!']);
    LanguageManager.setPhrase('optionsGameplayGoodHitWindowDesc', [
        'Changes the amount of time you have for hitting a "Good!" in milliseconds.', 
        'Cambia la cantidad de tiempo que tienes para obtener un "Bien!" en milisegundos.'
    ]);
    LanguageManager.setPhrase('optionsGameplayBadHitWindow', ['Bad Hit Window', 'Margen de Acierto para "Bad"']);
    LanguageManager.setPhrase('optionsGameplayBadHitWindowDesc', [
        'Changes the amount of time you have for hitting a "Bad" in milliseconds.', 
        'Cambia la cantidad de tiempo que tienes para obtener un "Mal" en milisegundos.'
    ]);
    LanguageManager.setPhrase('optionsGameplaySafeFrames', ['Safe Frames', 'Margen de Acierto']);
    LanguageManager.setPhrase('optionsGameplaySafeFramesDesc', [
        'Changes how many frames you have for hitting a note earlier or late.',
        'Cambia la cantidad de fotogramas que tienes para golpear una nota tarde o temprano.'
    ]);
    
    //Language / Idioma
    LanguageManager.setPhrase('optionsLanguage', ['Language', 'Idioma']);
    LanguageManager.setPhrase('optionsLanguageEnglish', ['English', 'Inglés']);
    LanguageManager.setPhrase('optionsLanguageSpanish', ['Spanish', 'Español']);
}

function setupStatesLanguages()
{
    //Play State
    LanguageManager.setPhrase('playStateScoreTxt', [['Score: ', 'Misses: ', 'Rating: '], ['Puntaje: ', 'Errores: ', 'Calificación: ']]);
    LanguageManager.setPhrase('playStateBotPlay', ['BotPlay', 'Automático']);

    //Intro State
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

    //Loading State
    LanguageManager.setPhrase('loadingStateLoadingTxt', ['Now loading', 'Cargando']);

    //Pause SubState
    LanguageManager.setPhrase('pauseSubStateResume', ['Resume', 'Resumir']);
    LanguageManager.setPhrase('pauseSubStateRestartSong', ['Restart Song', 'Reiniciar la Canción']);
    LanguageManager.setPhrase('pauseSubStateLeaveCharting Mode', ['Leave Charting Mode', 'Salir del Modo Charter']);
    LanguageManager.setPhrase('pauseSubStateSkipTime', ['Skip Time', 'Adelantar/Restrasar canción a']);
    LanguageManager.setPhrase('pauseSubStateEndSong', ['End Song', 'Terminar la Canción']);
    LanguageManager.setPhrase('pauseSubStateChangeDifficulty', ['Change Difficulty', 'Cambiar la Dificultad']);
    LanguageManager.setPhrase('pauseSubStateTogglePractice Mode', ['Toggle Practice Mode', 'Alternar Modo Práctica']);
    LanguageManager.setPhrase('pauseSubStateToggleBotPlay', ['Toggle BotPlay', 'Alternar Modo Automático']);
    LanguageManager.setPhrase('pauseSubStateOptions', ['Options', 'Opciones']);
    LanguageManager.setPhrase('pauseSubStateExitToMenu', ['Exit to Menu', 'Volver al Menú']);
    LanguageManager.setPhrase('pauseSubStatePracticeMode', ['Practice Mode', 'Modo Práctica']);
    LanguageManager.setPhrase('pauseSubStateChartingMode', ['Charting Mode', 'Modo Charter']);
    LanguageManager.setPhrase('pauseSubStateBlueBalled', ['BlueBalled: ', 'Muertes: ']);

    //Freeplay State
    LanguageManager.setPhrase('freeplayStateResetScore', ['Reset the score of', 'Reiniciar el puntaje de']);
    LanguageManager.setPhrase('freeplayStateYes', ['Yes', 'No']);
    LanguageManager.setPhrase('freeplayStateNo', ['No', 'No']);
}

function finishConfig()
{
    ScriptState.modFPSText(false);
    
    if (initialConfig)
    {
        switchToScriptState(CoolVars.initialState);
    } else {
        if (CoolVars.reconfigureData[0])
        {
            switchToScriptState(CoolVars.reconfigureData[1]);
        } else {
            switchToSomeStates(CoolVars.reconfigureData[1]);
        }
    }
}