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

    setupGlobalLanguages();
    setupStatesLanguages();
    setupSubStatesLanguages();
    setupEditorsStatesLanguages();
    setupEditorsSubStatesLanguages();
    setupObjectsLanguages();
    setupOptionsLanguages();
}

function setupGlobalLanguages()
{
    setPhrase('difficultiesEasy', ['Easy', 'Fácil']);
    setPhrase('difficultiesNormal', ['Normal', 'Normal']);
    setPhrase('difficultiesHard', ['Hard', 'Difícil']);
}

function setupObjectsLanguages()
{
    //Dialogue Box (Psych)
    setPhrase('dialogueBoxDialogueSkip', ['Press BACK to Skip', 'Presiona VOLVER para Saltar']);

    //FPS Counter
    setPhrase('fpsCounterInfo', [
        [
            'DEVELOPER MODE', 
            'Press F3 to reconfigure the game...' + '\n' +
            'Press TAB to select the mods you want to play...', 
            'FPS: ', 
            'Memory: ',
            'Current State: ',
            'Current SubState: ',
            'Window Position: ', 
            'Window Resolution: ', 
            'Screen Resolution: ', 
            'Operating System: '
        ], 
        [
            'MODO DESARROLLADOR', 
            'Presiona F3 para reconfigurar el juego...' + '\n' +
            'Presiona TAB para seleccionar los mods que quieres jugar...', 
            'FPS: ', 
            'Memoria: ', 
            'Estado Actual: ',
            'Sub-Estado Actual: ',
            'Posición de la Ventana: ', 
            'Resolución de la Ventana: ', 
            'Resolución de la Pantalla: ', 
            'Sistema Operativo: '
        ]
    ]);

    //File Dialog Handler
    setPhrase('fileDialogHandlerExceptions', [
        [
            'You must finish previous operation before starting a new one.'
        ], 
        [
            'Debes terminar la operación anterior antes de empezar una nueva.'
        ]
    ]);
    setPhrase('fileDialogHandlerTraces', [
        [
            'Saved file to: ',
            'Loaded file from: ',
            'Loaded directory: '
        ], 
        [
            'Se guardó el archivo: ',
            'Se cargó el archivo: ',
            'Directorio Cargado: '
        ]
    ]);

    //Prompt
    setPhrase('promptUnsavedProgress', [
        'There\'s unsaved progress,\nare you sure you want to exit?',
        'Hay progreso sin guardar,\nestás seguro de que quieres salir?'
    ]);
    setPhrase('promptYes', ['OK', 'Aceptar']);
    setPhrase('promptNo', ['Cancel', 'Cancelar']);
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
    setPhrase('optionsGraphicsGPUCaching', ['GPU Caching', 'Almacenamiento en el caché de la GPU']);
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
    setPhrase('optionsVisualsFlashingLights', ['Flashing Lights', 'Luces Intermitentes']);
    setPhrase('optionsVisualsFlashingLightsDesc', [
        'Uncheck this if you\'re sensitive to flashing lights!', 
        'Desactiva esto si eres sensible a las luces intermitentes!'
    ]);
    setPhrase('optionsVisualsPauseMusic', ['Pause Music', 'Música de Pausa']);
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
    setPhrase('optionsGameplayBadHitWindow', ['Bad Hit Window', 'Margen de Acierto para un "Mal"']);
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
    setPhrase('playStateSFC', ['SFC', 'SFC']);
    setPhrase('playStateGFC', ['GFC', 'GFC']);
    setPhrase('playStateFC', ['FC', 'FC']);
    setPhrase('playStateSDCB', ['SDCB', 'RCDI']);
    setPhrase('playStateClear', ['Clear', 'Pasado']);
    setPhrase('playStateNA', ['N/A', 'N/A']);

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

    //Freeplay State
    setPhrase('freeplayStateResetScore', ['Reset the score of', 'Reiniciar el puntaje de']);
    setPhrase('freeplayStateYes', ['Yes', 'No']);
    setPhrase('freeplayStateNo', ['No', 'No']);
    setPhrase('freeplayStateDifficulty', ['DIFFICULTY', 'DIFICULTAD']);

    //Story Menu State
    setPhrase('storyMenuStateTracks', ['TRACKS', 'TEMAS']);

    //Credits State
    setPhrase('creditsStateALEEngineTeam', ['ALE Engine Team', 'Equipo de ALE Engine']);
    setPhrase('creditsStateALEEngineContributors', ['ALE Engine Contributors', 'Contribuidores de ALE Engine']);
    setPhrase('creditsStatePsychEngineTeam', ['Psych Engine Team', 'Equipo de Psych Engine']);

    setPhrase('creditsStateALEEngineMainCrew', [
        [
            ['AlejoGDOfficial', 'alejoGDOfficial', 'Main Programmer and Head', '03B1FC'],
            ['Khorix the Inking', 'khorixTheInking', 'Main Artist/Animator', '494F75'],
            ['Eddy Smashcraft', 'eddySmashcraft', 'Helped with the Translations into Spanish', '5D4FBC']
        ],
        [
            ['AlejoGDOfficial', 'alejoGDOfficial', 'Programador Principal y Cabeza', '03B1FC'],
            ['Khorix the Inking', 'khorixTheInking', 'Principal Artista/Animador', '494F75'],
            ['Eddy Smashcraft', 'eddySmashcraft', 'Ayudó con las Traducciones al Español', '5D4FBC']
        ]
    ]);

    setPhrase('creditsStateALEEngineSecondaryCrew', [
        [
            ['Slushi', 'slushi', 'C++ Functions', '03F2FF']
        ],
        [
            ['Slushi', 'slushi', 'Funciones de C++', '03F2FF']
        ]
    ]);

    setPhrase('creditsStatePsychEngineMainCrew', [
        [
            ['Shadow Mario', 'shadowMario', 'Main Programmer and Head', '444444'],
            ['Riveren', 'riveren', 'Main Artist/Animator', '14967B']
        ],
        [
            ['Shadow Mario', 'shadowMario', 'Programador Principal y Cabeza', '444444'],
            ['Riveren', 'riveren', 'Principal Artista/Animador', '14967B']
        ]
    ]);

    //Master Editor Menu
    setPhrase('masterEditorMenuChartEditor', ['Chart Editor', 'Editor de Chart']);
    setPhrase('masterEditorMenuCharacterEditor', ['Character Editor', 'Editor de Personajes']);
    setPhrase('masterEditorMenuStageEditor', ['Stage Editor', 'Editor de Escenarios']);
    setPhrase('masterEditorMenuDialogueEditor', ['Dialogue Editor', 'Editor de Dialogos']);
    setPhrase('masterEditorMenuDialoguePortraitEditor', ['Dialogue Portrait Editor', 'Editor de Retratos de Dialogo']);
    setPhrase('masterEditorMenuNoteSplashEditor', ['Note Splash Editor', 'Editor de Salpicaduras']);
    setPhrase('masterEditorMenuShowConsole', ['Show Console', 'Mostrar Consola']);
    setPhrase('masterEditorMenuHideConsole', ['Hide Console', 'Esconder Consola']);

    //Mods Menu State
    setPhrase('modsMenuStateReloadButton', ['RELOAD', 'RECARGAR']);
    setPhrase('modsMenuStateEnableAllButton', ['ENABLE ALL', 'ACTIVAR TODO']);
    setPhrase('modsMenuStateDisableAllButton', ['DISABLE ALL', 'DESACTIVAR TODO']);
    setPhrase('modsMenuStateNoModsInstalled', ['NO MODS INSTALLED\nPRESS BACK TO EXIT OR INSTALL A MOD', 'NO HAY MODS\nPRESIONA VOLVER PARA SALIR O INSTALAR UN MOD']);
    setPhrase('modsMenuStateNoModsFound', ['No Mods Found.', 'No se Encontraron Mods.']);
    setPhrase('modsMenuStateModRestart', ['* Moving or Toggling On/Off this Mod will restart the game.', '* Mover o Activar/Desactivar este Mod Reiniciará el Juego.']);
    setPhrase('modsMenuStateAtLeastOneMod', ['At least *ONE MOD* Must be Selected', 'Al menos *UN MOD* debe ser seleccionado']);
}

function setupSubStatesLanguages()
{
    //Pause SubState
    setPhrase('pauseSubStateResume', ['Resume', 'Resumir']);
    setPhrase('pauseSubStateRestartSong', ['Restart Song', 'Reiniciar la Canción']);
    setPhrase('pauseSubStateLeaveChartingMode', ['Leave Charting Mode', 'Salir del Modo Charter']);
    setPhrase('pauseSubStateSkipTime', ['Skip Time', 'Reproducir Canción']);
    setPhrase('pauseSubStateEndSong', ['End Song', 'Terminar la Canción']);
    setPhrase('pauseSubStateChangeDifficulty', ['Change Difficulty', 'Cambiar la Dificultad']);
    setPhrase('pauseSubStateBack', ['Back', 'Volver']);
    setPhrase('pauseSubStateTogglePracticeMode', ['Toggle Practice Mode', 'Alternar Modo Práctica']);
    setPhrase('pauseSubStateToggleBotPlay', ['Toggle BotPlay', 'Alternar Modo Automático']);
    setPhrase('pauseSubStateOptions', ['Options', 'Opciones']);
    setPhrase('pauseSubStateExitToMenu', ['Exit to Menu', 'Volver al Menú']);
    setPhrase('pauseSubStatePracticeMode', ['Practice Mode', 'Modo Práctica']);
    setPhrase('pauseSubStateChartingMode', ['Charting Mode', 'Modo Charter']);
    setPhrase('pauseSubStateEasy', ['Easy', 'Fácil']);
    setPhrase('pauseSubStateNormal', ['Normal', 'Normal']);
    setPhrase('pauseSubStateHard', ['Hard', 'Difícil']);

    setPhrase('pauseSubStateBlueBalled', ['BlueBalled: ', 'Muertes: ']);
}

function setupEditorsStatesLanguages()
{
    //Charting State
    setPhrase('chartingStateFile', [
        [
            'File',
            'New',
            'Open Chart...',
            'Open Autosave...',
            'Open Events...',
            'Save',
            'Save as...',
            'Save Events',
            'Reload Chart',
            'Save (V-Slice)...',
            'ALE to V-Slice...',
            'V-Slice to ALE...',
            'Update (Legacy)...',
            'Preview (F12)',
            'Playtest (Enter)',
            'Exit'
        ], 
        [
            'Archivo',
            'Nuevo',
            'Abrir Chart...',
            'Abrir Autoguardado...',
            'Abrir Eventos...',
            'Guardar',
            'Guardar como...',
            'Guardar Eventos',
            'Recargar Chart',
            'Guardar (V-Slice)...',
            'ALE a V-Slice...',
            'V-Slice a ALE...',
            'Actualizar (Versiones antiguas)...',
            'Previsualización (F12)',
            'Jugar (Enter)',
            'Salir'
        ]
    ]);
    setPhrase('chartingStateEdit', [
        [
            'Edit',
            'Undo',
            'Redo',
            'Select All',
            'Lock Events',
            'Autosave Settings',
            'Clear All Notes',
            'Clear All Events'
        ], 
        [
            'Editar',
            'Deshacer',
            'Rehacer',
            'Seleccionar Todo',
            'Bloquear Eventos',
            'Configurar Autoguardado...',
            'Borrar Todas las Notas',
            'Borrar Todos los Eventos'
        ]
    ]);
    setPhrase('chartingStateEditAutosaveSettings', [
        [
            'Autosave Settings',
            'Time (in minutes):',
            'Enabled',
            'File Limit:'
        ], 
        [
            'Configurar Autoguardado',
            'Tiempo (en minutos):',
            'Activado',
            'Límite de Archivos:'
        ]
    ]);
    setPhrase('chartingStateView', [
        [
            'View',
            'Hide Last Section',
            'Show Last Section',
            'Hide Next Section',
            'Show Next Section',
            'Hide Note Labels',
            'Show Note Labels',
            'Vortex Editor OFF',
            'Vortex Editor ON',
            'Waveform...',
            'Go to...',
            'Theme...',
            'Reset UI Boxes'
        ], 
        [
            'View',
            'Esconder la Sección Anterior',
            'Mostrar la Sección Anterior',
            'Esconder la Siguiente Sección',
            'Mostrar la Siguiente Sección',
            'Hide Note Labels',
            'Mostrar Note Labels',
            'Editor Vórtice Apagado',
            'Editor Vórtice Encendido',
            'Forma de Onda...',
            'Ir a...',
            'Tema...',
            'Reiniciar las Cajas del UI'
        ]
    ]);
    setPhrase('chartingStateViewWaveform', [
        [
            'Waveform Settings',
            'Enabled',
            'Color (HEX):',
            'Intrumental',
            'Main Vocals',
            'Opponent Vocals'
        ],
        [
            'Ajustes de la Forma de Onda',
            'Activado',
            'Color (HEX):',
            'Intrumental',
            'Voces Principales',
            'Voces del Oponente'
        ]
    ]);
    setPhrase('chartingStateViewGoTo', [
        [
            'Go to Time/Section:',
            'Time (in seconds)',
            'Section:',
            'Go To',
            'Cancel'
        ],
        [
            'Ir a Segundo/Sección:',
            'Tiempo (en segundos)',
            'Sección:',
            'Ir a',
            'Cancelar'
        ]
    ]);
    setPhrase('chartingStateViewTheme', [
        [
            'Chart Editor Theme',
            'Light',
            'Default',
            'Dark'
        ],
        [
            'Tema del Editor de Chart',
            'Claro',
            'Por Defecto',
            'Oscuro'
        ]
    ]);
    setPhrase('chartingStateCharting', [
        [
            'Charting',
            'Any options here won\'t actually affect gameplay!',
            'Playback Rate',
            'Mouse Scroll Snap',
            'Ignore Progress Warnings',
            'Hitsound (Player):'
            'Hitsound (Opp.):',
            'Metronome:',
            'Inst. Volume:',
            'Main Vocals:',
            'Opp. Vocals:',
            'Mute'
        ],
        [
            'Charteo',
            'Ninguna de estas opciones afectará al Jugar!',
            'Velocidad',
            'Rueda del Mouse Encaja',
            'Ignorar Advertencias del Progreso',
            'Golpe Sonoro P1:'
            'Golpe Sonoro P2:',
            'Metronome:',
            'Volumen del Inst.:',
            'Voces P1:',
            'Voces P2:',
            'Silenciar'
        ]
    ]);
    setPhrase('chartingStateData', [
        [
            'Data',
            'Game Over Character:',
            'Game Over Death Sound (sounds/):',
            'Game Over Loop Music (music/):',
            'Game Over Retry Music (music/):',
            'Disable Note RGB',
            'Note Texture:',
            'Note Splashes Texture:'
        ],
        [
            'Datos',
            'Personaje al Morir:',
            'Sonido al Morir (sounds/):',
            'Música al Morir (music/):',
            'Música al Revivir (music/):',
            'Desactivar RGB de las Notas',
            'Textura de las Notas:',
            'Textura de las Salpicaduras:'
        ]
    ]);
    setPhrase('chartingStateEvents', [
        [
            'Events',
            'Event:',
            'Value 1:',
            'Value 2:'
        ],
        [
            'Eventos',
            'Evento:',
            'Valor 1:',
            'Valor 2:'
        ]
    ]);
    setPhrase('chartingStateEventList', [
        [
            ['', "Nothing."],
            ['Hey!', "Plays the \"Hey!\" animation from Bopeebo,\nValue 1: BF = Only Boyfriend, GF = Only Girlfriend,\nSomething else = Both.\nValue 2: Custom animation duration,\nleave it blank for 0.6s"],
            ['Set GF Speed', "Sets GF head bopping speed,\nValue 1: 1 = Normal speed,\n2 = 1/2 speed, 4 = 1/4 speed etc.\n\n\nWarning: Value must be integer!"],
            ['Add Camera Zoom', "Self Explanatory\nValue 1: Camera zoom add (Default: 0.015)\nValue 2: UI zoom add (Default: 0.03)\nLeave the values blank if you want to use Default."],
            ['Play Animation', "Plays an animation on a Character,\nonce the animation is completed,\nthe animation changes to Idle\n\nValue 1: Animation to play.\nValue 2: Character (Dad, BF, GF)"],
            ['Camera Follow Pos', "Value 1: X\nValue 2: Y\n\nThe camera won't change the follow point\nafter using this, for getting it back\nto normal, leave both values blank."],
            ['Alt Idle Animation', "Sets a specified postfix after the idle animation name.\nYou can use this to trigger 'idle-alt' if you set\nValue 2 to -alt\n\nValue 1: Character to set (Dad, BF or GF)\nValue 2: New postfix (Leave it blank to disable)"],
            ['Screen Shake', "Value 1: Camera shake\nValue 2: HUD shake\n\nEvery value works as the following example: \"1, 0.05\".\nThe first number (1) is the duration.\nThe second number (0.05) is the intensity."],
            ['Change Character', "Value 1: Character to change (Dad, BF, GF)\nValue 2: New character's name"],
            ['Change Scroll Speed', "Value 1: Scroll Speed Multiplier (1 is default)\nValue 2: Time it takes to change fully in seconds."],
            ['Set Property', "Value 1: Variable name\nValue 2: New value"],
            ['Play Sound', "Value 1: Sound file name\nValue 2: Volume (Default: 1), ranges from 0 to 1"]
        ],
        [
            ['', "Nada."],
            ['Hey!', "Corre la animación Hey!,\nValor 1: BF = Solo Boyfriend, GF = Solo Girlfriend,\nCualquier otra cosa = Ambos.\nValor 2: Duración de la Animación Personalizada,\npor defecto dura 0.6s"],
            ['Set GF Speed', "Asigna la velocidad del movimiento de GF,\nValor 1: 1 = Velocidad normal,\n2 = Velocidad de 1/2, 4 = Velocidad de 1/4... etc.\n\nAviso: El valor debe ser un Número Entero!"],
            ['Add Camera Zoom', "Se explica solo.\nValor 1: Zoom a Añadir (Por Defecto es 0.015)\nValor 2: Añadir Zoom a la Interfaz (Por Defecto es 0.03)\nDeja esto en Blanco si quieres usar el Zoom por defecto."],
            ['Play Animation', "Corre una animación en un Personaje,\nuna vez la animación termina,\nse quita.\n\nValor 1: Animación a correr.\nValor 2: Personaje (Dad, BF, GF)"],
            ['Camera Follow Pos', "Valor 1: X\nValor 2: Y\n\nLa cámara no seguirá otro punto\ndespués de usar esto, para devolverla\na la normalidad, deja ambos valores en blanco."],
            ['Alt Idle Animation', "Establece un sufijo específico después del nombre de la animación para inactividad.\nPuedes usar esto para activar 'idle-alt'\nsi configuras el Valor 2 en -alt\n\nValor 1: Personaje al que aplicar (Dad, BF o GF)\nValor 2: Nuevo sufijo (Déjalo en blanco para desactivar)"],
            ['Screen Shake', "Valor 1: Sacude la Cámara\nValor 2: Sacude la Interfaz\n\nCada valor funciona como en el Siguiente Ejemplo: \"1, 0.05\".\nEl primer número (1) es la duración.\nEl segundo número (0.05) es la Intensidad."],
            ['Change Character', "Valor 1: Personaje a Cambiar (Dad, BF, GF)\nValor 2: Nombre del .json del Nuevo Personaje."],
            ['Change Scroll Speed', "Valor 1: Multiplicador (Por Defecto es 1)\nValor 2: Tiempo que toma el cambio en Segundos."],
            ['Set Property', "Valor 1: Nombre de la Variable\nValor 2: Nuevo Valor"],
            ['Play Sound', "Valor 1: Nombre del Archivo del Sonido\nValor 2: Volumen (Por Defecto es 1), en un rango de 0 a 1"]
        ]
    ]);
    setPhrase('chartingStateNote', [
        [
            'Note',
            'Sustain length:',
            'Note Hit time (ms):',
            'Note Type:'
        ],
        [
            'Nota',
            'Longitud de la Sustancia:',
            'Tiempo para Golpear la Nota (Milisegundos):',
            'Tipo de Nota:'
        ]
    ]);
    setPhrase('chartingStateNoteTypeList', [
        [
            'Alt Animation',
            'Hey!',
            'Hurt Note',
            'GF Sing',
            'No Animation'
        ],
        [
            'Animación',
            'Hey!',
            'Nota de Daño',
            'GF Canta',
            'Sin Animación'
        ]
    ]);
    setPhrase('chartingStateSection', [
        [
            'Section',
            'Must Hit Sec.',
            'GF Section',
            'Alt Anim',
            'Change BPM',
            'Beats per Section:',
            'Copy Section',
            'Paste Section',
            'Clear',
            'Notes',
            'Events',
            'Copy Last Section',
            'Swap Section',
            'Duet Section',
            'Mirror Notes'
        ],
        [
            'Sección',
            'Sección de BF',
            'Sección de GF',
            'Anim. Alt.',
            'Cambiar BPM',
            'Beats por Sección:',
            'Copiar Sección',
            'Pegar Sección',
            'Borrar',
            'Notas',
            'Eventos',
            'Copiar las últimas ? Secciones',
            'Alternar Sección',
            'Duplicar Sección',
            'Invertir las Notas'
        ]
    ]);
    setPhrase('chartingStateSong', [
        [
            'Song Name',
            'Allow Vocals',
            'Reload Audio',
            'BPM:',
            'Scroll Speed:',
            'Audio Offset (ms):',
            'Player:',
            'Opponent:',
            'Girlfriend:',
            'Stage:'
        ],
        [
            'Nombre de la Canción',
            'Permitir Voces',
            'Recargar el Audio',
            'BPM:',
            'Velocidad de Desp.:',
            'Compensación del Audio (ms):',
            'Jugador:',
            'Oponente:',
            'GF:',
            'Escenario:'
        ]
    ]);
    setPhrase('chartingStateHelpText', [
        [
            'Press F1 for Help',
            'W/S/Mouse Wheel - Move Conductor\'s time' + '\n' +
            'A/D - Change Sections' + '\n' +
            'Q/E - Decrease/Increase Note Sustain Length' + '\n' +
            'Hold Shift/Alt - Increase/Decrease move by 4x' + '\n\n' +
            'F12 - Preview Chart' + '\n' +
            'Enter - Playtest Chart' + '\n' +
            'Space - Stop/Resume Song' + '\n\n' +
            'Alt + Click - Select Note(s)' + '\n' +
            'Shift + Click - Select/Unselect Notes(s)' + '\n' +
            'Right Click - Selection Box' + '\n\n' +
            'Z/X - Zoom in/out' + '\n' +
            'Left/Right - Change Snap' + '\n' +
            'Left Bracket / Right Bracket - Change Song Playback Rate' + '\n' +
            'ALT + Left Bracket / Right Bracket - Reset Song Playback Rate' + '\n\n' +
            'Ctrl + Z - Undo' + '\n' +
            'Ctrl + Y - Redo' + '\n' +
            'Ctrl + X - Cut Selected Notes' + '\n' +
            'Ctrl + C - Copy Selected Notes' + '\n' +
            'Ctrl + V - Paste Copied Notes' + '\n' +
            'Ctrl + A - Select all in current Section' + '\n' +
            'Ctrl + S - Quicksave'
        ],
        [
            'Presiona F1 para ver los Atajos',
            'W/S/Rueda del Mouse - Mover el cuadro de Chart' + '\n' +
            'A/D - Cambiar Secciones' + '\n' +
            'Q/E - Aumentar/Disminuir la Longitud de la Sutancia de una Nota' + '\n' +
            'Mantener Presionado Shift/Alt - Aumentar/Disminuir el Movimiento 4x' + '\n\n' +
            'F12 - Previsualizar Chart' + '\n' +
            'Enter - Jugar' + '\n' +
            'Espacio - Parar/Resumir la Canción' + '\n\n' +
            'Alt + Click - Seleccionar Nota(s)' + '\n' +
            'Shift + Click - Seleccionar/Dejar de Selecciónar la(s) Nota(s)' + '\n' +
            'Click Derecho - Caja de Selección' + '\n\n' +
            'Z/X - Disminuir/Aumentar el Zoom' + '\n' +
            'Izquierda/Derecha - Cambiar el Encaje' + '\n\n' +
            'Ctrl + Z - Deshacer' + '\n' +
            'Ctrl + Y - Rehacer' + '\n' +
            'Ctrl + X - Cortar las Notas Seleccionadas' + '\n' +
            'Ctrl + C - Copiar las Notas Seleccionadas' + '\n' +
            'Ctrl + V - Pegar las Notas Cortadas/Copiadas' + '\n' +
            'Ctrl + A - Seleccionar Todo en la Sección Actual' + '\n' +
            'Ctrl + S - Guardado Rápido'
        ]
    ]);
    setPhrase('chartingStateInformation', [
        [
            'Information',
            'Section: ',
            'Beat: ',
            'Step: ',
            'Beat Snap: ',
            'Selected: '
        ], 
        [
            'Información',
            'Sección: ',
            'Beat: ',
            'Paso: ',
            'División del Beat: ',
            'Seleccionado: '
        ]
    ]);
    setPhrase('chartingStateOutputs', [
        [
        ],
        [   
        ]
    ]);

    //Editor Play State
    setPhrase('editorPlayStateGoBack', ['Press ESC to Go back to Chart Editor', 'Presiona ESC para Volver al Editor de Chart']);
    setPhrase('editorPlayStateInfo', [
        [
            'Time: ',
            'Section: ',
            'Beat: ',
            'Step: ',
            'Hits: ',
            'Misses: '
        ],
        [
            'Segundo Actual: ',
            'Sección: ',
            'Beat: ',
            'Paso: ',
            'Golpes: ',
            'Errores: '
        ]
    ]);

    //Character Editor State
    setPhrase('characterEditorStateZoom', ['Zoom', 'Zoom']);
    setPhrase('characterEditorStateFrames', ['Frames: ', 'Fotogramas: ']);
    setPhrase('characterEditorStateGhost', [
        [
            'Ghost',
            'Make Ghost',
            'Highlight Ghost',
            'Opacity:'
        ], 
        [
            'Sombra',
            'Crear Sombra',
            'Sombre Iluminada',
            'Opacidad:'
        ]
    ]);
    setPhrase('characterEditorStateSettings', [
        [
            'Settings',
            'Character:',
            'Playable Character',
            'Reload Character',
            'Load Template'
        ], 
        [
            'Ajustes',
            'Personaje:',
            'Personaje Jugable',
            'Recargar Personaje',
            'Cargar Plantilla'
        ]
    ]);
    setPhrase('characterEditorStateAnimations', [
        [
            'Animations',
            'Animation:',
            'Animation Name:',
            'Animation Symbol Name/Tag:',
            'ADVANCED - Animation Indices:',
            'Framerate:',
            'Should it Loop?',
            'Add/Update',
            'Remove'
        ], 
        [
            'Animaciones',
            'Animación:',
            'Nombre de la Animación:',
            'Nombre/Etiqueta del Símbolo de la Animación:',
            'AVANZADO - Índice de la Animación:',
            'Tasa de Actualización:',
            'No debería parar?',
            'Añadir/Actualizar',
            'Remover'
        ]
    ]);
    setPhrase('characterEditorStateCharacter', [
        [
            'Character',
            'Image file name:',
            'Health icon name:',
            'Vocals File Postfix',
            'Reload Image',
            'Get Icon Color',
            'Sing Animation length:',
            'Flip X',
            'Scale:',
            'No Antialising',
            'Health Bar R/G/B:',
            'Character X/Y:',
            'Camera X/Y:',
            'Save Character'
        ], 
        [
            'Personaje',
            'Nombre del archivo de la imagen:',
            'Nombre del Ícono:',
            'Sufijo del Archivo de las Voces:',
            'Recargar Imagen',
            'Obtener Color del Ícono',
            'Longitud de la Animación de Canto:',
            'Voltear en el Eje X',
            'Escala:',
            'Sin Suavizado',
            'R/G/B de la Barra de Vida:',
            'X/Y del Personaje:',
            'X/Y de la Cámara:',
            'Guardar Personaje'
        ]
    ]);
    setPhrase('characterEditorStateHelpText', [
        [
            'Press F1 for Help',
            'CAMERA' + '\n' +
            'E/Q - Camera Zoom In/Out' + '\n' +
            'J/K/L/I - Move Camera' + '\n' +
            'R - Reset Camera Zoom' + '\n\n' +
            'CHARACTER' + '\n' +
            'Ctrl + R - Reset Current Offset' + '\n' +
            'Ctrl + C - Copy Current Offset' + '\n' +
            'Ctrl + V - Paste Copied Offset on Current Animation' + '\n' +
            'Ctrl + Z - Undo Last Paste or Reset' + '\n' +
            'W/S - Previous/Next Animation' + '\n' +
            'Space - Replay Animation' + '\n' +
            'Arrow Keys/Mouse & Right Click - Move Offset' + '\n' +
            'A/D - Frame Advance (Back/Forward)' + '\n\n' +
            'OTHER' + '\n' +
            'F12 - Toggle Silhoutte' + '\n' +
            'Hold Shift - Move Offset 10x faster and Camera 4x Faster' + '\n' +
            'Hold Control - Move camera 4x slower'
        ], 
        [
            'Presiona F1 para ver los Atajos',
            'CÁMARA' + '\n' +
            'E/Q - Aumentar/Disminuir el Zoom' + '\n' +
            'J/K/L/I - Mover la Cámara' + '\n' +
            'R - Reiniciar el Zoom de la Cámara' + '\n\n' +
            'PERSONAJE' + '\n' +
            'Ctrl + R - Reiniciar la Compensación Actual' + '\n' +
            'Ctrl + C - Copiar la Compensación Actual' + '\n' +
            'Ctrl + V - Pegar la Compensación Copiada en la Animación Actual' + '\n' +
            'Ctrl + Z - Deshacer el Último Dehacer/Reiniciar' + '\n' +
            'W/S - Anterior/Siguiente Animación' + '\n' +
            'Espacio - Correr Animación Actual' + '\n' +
            'Flechas/Mouse & Click Derecho - Mover Compensación' + '\n' +
            'A/D - Ir un Fotograma hacia Atrás/Adelante' + '\n\n' +
            'OTROS' + '\n' +
            'F12 - Alternar la Visibilidad de la Silueta' + '\n' +
            'Mantener Presionado Shift - Mover las Compensaciones 10 Veces Más Rápido y la Cámara 4 Veces Más Rápido' + '\n' +
            'Mantener Presionado Ctrl - Mover la Cámara 4 Veces Más Lento'
        ]
    ]);

    //Stage Editor State
    setPhrase('stageEditorStateSpriteList', [
        [
            'Sprite List',
            '- Boyfriend -',
            '- Opponent -',
            '- Girlfriend -',
            'Move Up',
            'Move Down',
            'New',
            'Duplicate',
            'Delete'
        ],
        [
            'Lista de Sprites',
            '- Boyfriend -',
            '- Opponent -',
            '- Girlfriend -',
            'Mover hacia Arriba',
            'Mover hacia Abajo',
            'Nuevo',
            'Duplicar',
            'Eliminar'
        ]
    ]);
    setPhrase('stageEditorStateSpriteListNew', [
        [
            'New Sprite',
            'No Animation',
            'Animated',
            'Solid Color'
        ],
        [
            'Nuevo Sprite',
            'Sin Animaciones',
            'Animado',
            'Color Sólido'
        ]
    ]);
    setPhrase('stageEditorStateStage', [
        [
            'Stage',
            'Stage:',
            'Reload',
            'Load Template'
        ],
        [
            'Escenario',
            'Escenario:',
            'Recargar',
            'Cargar Plantilla'
        ]
    ]);
    setPhrase('stageEditorStateMeta', [
        [
            'Meta',
            'Preload List',
            'Opponent:',
            'Girlfriend:',
            'Player:'
        ],
        [
            'Metadatos',
            'Lista de Precargado',
            'Oponente:',
            'Girlfriend:',
            'Player:'
        ]
    ]);
    setPhrase('stageEditorStateData', [
        [
            'Data',
            'Compiled Assets:',
            'UI Style:',
            'Hide Girlfriend?',
            'Camera Offsets:',
            'Opponent',
            'Girlfriend',
            'Boyfriend',
            'Camera Data:',
            'Zoom:',
            'Speed:',
            'Save'
        ],
        [
            'Datos',
            'Activos Compilados:',
            'Estilo de la Interfaz:',
            'Esconder a GF?',
            'Compensaciones de la Cámara:',
            'Oponente',
            'Girlfriend',
            'Boyfriend',
            'Datos de la Cámara:',
            'Zoom:',
            'Velocidad:',
            'Guardar'
        ]
    ]);
    setPhrase('stageEditorStateObject', [
        [
            'Name (for Lua/HScript)',
            'Image:',
            'Change Image',
            'Animations'
            'Color:',
            'Scale (X/Y):',
            'Scroll Factor (X/Y):',
            'Opacity:',
            'Anti-Aliasing',
            'Angle:',
            'Flip X',
            'Flip Y',
            'Visible in:',
            'Low Quality',
            'High Quality'
        ],
        [
            'Nombre (para Lua/HScript)',
            'Imagen:',
            'Cambiar Imagen',
            'Animaciones'
            'Color:',
            'Escala (X/Y):',
            'Compensación (X/Y):',
            'Opacidad:',
            'Suavizar',
            'Ángulo:',
            'Inventir en X',
            'Invertir en Y',
            'Visible en:',
            'Baja Calidad',
            'Alta Calidad'
        ]
    ]);
    setPhrase('stageEditorStateCameraTarget', [
        [
            'Opponent',
            'Boyfriend',
            'Girlfriend',
            'Can see Low High Sprites?',
            'Can see Low Quality Sprites?'
        ],
        [
            'Oponente',
            'Boyfriend',
            'Girlfriend',
            'Se pueden ver Sprites de Baja Calidad?',
            'Se pueden ver Sprites de Alta Calidad?'
        ]
    ]);
    setPhrase('stageEditorStateHelpText', [
        [
            'Press F1 for Help',
            'E/Q - Camera Zoom In/Out' + '\n' +
            'J/K/L/I - Move Camera' + '\n' +
            'R - Reset Camera Zoom' + '\n' +
            'Arrow Keys/Mouse & Right Click - Move Object' + '\n\n' +
            'F2 - Toggle HUD' + '\n' +
            'F12 - Toggle Selection Rectangle' + '\n' +
            'Hold Shift - Move Objects and Camera 4x Faster' + '\n' +
            'Hold Control - Move Obejects pixel-by-pixel and Camera 4x Slower'
        ],
        [
            'Presiona F1 para Ver los Atajos',
            'E/Q - Aumentar/Disminuir el Zoom' + '\n' +
            'J/K/L/I - Mover la Cámara' + '\n' +
            'R - Reiniciar el Zoom' + '\n' +
            'Flechas/Mouse & Click Derecho - Mover Objeto' + '\n\n' +
            'F2 - Alternar la Visibilidad de la Interfaz' + '\n' +
            'F12 - Alternar la Visibilidad del Rectángulo de Selección' + '\n' +
            'Mantener Presionado Shift - Mover Objectos y la Cámara 4 Veces Más Rápido' + '\n' +
            'Mantener Presionado Control - Mover Objetos Pixel por Pixel y la Cámara 4 Veces Más Lento'
        ]
    ]);
    setPhrase('stageEditorStateErrors', [
        [
            'Can\'t load files outside of "images/" folder.',
            'Only Animated Sprites can hold Animation Data.'
        ],
        [
            'No se pueden cargar archivos fuera da la carpeta "images/"',
            'Solo los Sprites Animados pueden tener Datos de Animación.'
        ]
    ]);

    //Dialogue Editor State
    setPhrase('dialogueEditorStateInfo', [
        [
            'Press O to remove the current dialogue line, Press P to add another line after the current one.',
            'Line: ',
            ' - Press A or D to scroll',
            'Animation: ',
            ' - Press W or S to scroll'
        ],
        [
            'Presiona O para remover la línea de diálogo actual, Presiona P para añadir otra línea justo después de la actual.',
            'Línea: ',
            ' - Presiona A o D para cambiar',
            'Animación: ',
            ' - Presiona W o S para cambiar'
        ]
    ]);
    setPhrase('dialogueEditorStateDialogueLine', [
        [
            'Dialogue Line',
            'Character:',
            'Interval/Speed (ms)',
            'Angry Textbox',
            'Sound file name:',
            'Text:',
            'Load Digalogue',
            'Save Dialogue'
        ],
        [
            'Línea de Diálogo',
            'Personaje:',
            'Intérvalo/Velocidad (milisegundos)',
            'Enojado',
            'Nombre del Archivo de Sonido:',
            'Texto:',
            'Cargar Diálogo',
            'Guardar Diálogo'
        ]
    ]);

    //Dialogue Character Editor State
    setPhrase('dialogueCharacterEditorStateInfo', [
        [
            'Animation: ',
            ' - Press W or S to scroll',
            'JKLI - Move camera (Hold Shift to move 4x faster)' + '\n' +
            'Q/E - Zoom out/in' + '\n' +
            'R - Reset Camera' + '\n' +
            'H - Toggle Speech Bubble' + '\n' +
            'Espacio - Reset text'
        ],
        [
            'Animación: ',
            ' - Presiona W o S para cambiar',
            'JKLI - Mover la cámara (Manten presionado Shift para moverte 4 veces más rápido)' + '\n' +
            'Q/E - Disminuir/Aumentar el Zoom' + '\n' +
            'R - Reiniciar la Cámara' + '\n' +
            'H - Alternar la visibilidad de la Burbuja' + '\n' +
            'Espacio - Reiniciar Texto'
        ]
    ]);
    setPhrase('dialogueCharacterEditorStateCharacterType', [
        [
            'Character Type',
            'Left',
            'Center',
            'Right'
        ],
        [
            'Tipo de Personaje',
            'Izquierda',
            'Centro',
            'Derecha'
        ]
    ]);
    setPhrase('dialogueCharacterEditorStateAnimations', [
        [
            'Animations:',
            'Animation name:',
            'Loop name on .XML file:',
            'Idle/Finised name on .XML file:'
        ],
        [
            'Animaciones:',
            'Nombre de la Animación:',
            'Nombre del Bucle en el .XML:',
            'Nombre de la Animación de Inactividad en el .XML:'
        ]
    ]);
    setPhrase('dialogueCharacterEditorStateCharacter', [
        [
            'Character',
            'Image file name:',
            'Position Offset:',
            'Scale:',
            'No Antialiasing',
            'Save Character',
            'Load Character',
            'Reload Image'
        ],
        [
            'Personaje',
            'Nombre del archivo de la Imagen:',
            'Compensación de la Posición:',
            'Escala:',
            'Sin Suavizar',
            'Guardar Personaje',
            'Cargar Personaje',
            'Recargar Imagen'
        ]
    ]);

    //Note Splash Editor State
    setPhrase('noteSplashEditorStateInfo', [
        [
            'Copied Offsets: ',
            'Current Animation: '
        ],
        [
            'Compensaciones Copiadas: ',
            'Animacion Actual: '
        ]
    ]);
    setPhrase('noteSplashEditorStateProperties', [
        [
            'Properties',
            'Image:',
            'Reload Image',
            'Scale:',
            'Animations:',
            'Allow RGB?',
            'Allow Pixel?',
            'Save',
            'Template',
            'Convert TXT'
        ],
        [
            'Propiedades',
            'Imagen:',
            'Recargar Imagen',
            'Escala:',
            'Animaciones:',
            'Permitir RGB?',
            'Perimitir Pixel?',
            'Guardar',
            'Plantilla',
            'Convertir TXT'
        ]
    ]);
    setPhrase('noteSplashEditorStateAnimation', [
        [
            'Animation',
            'Animation Name:',
            'Animation Prefix:',
            'Indices (OPTIONAL):',
            'Note Data:',
            'Minimum FPS:',
            'Maximum FPS:',
            'Add',
            'Remove'
        ],
        [
            'Animación',
            'Nombre de la Animación:',
            'Prefijo de la Animación:',
            'Índices (OPCIONAL):',
            'Datos de la Nota:',
            'Mínimos FPS:',
            'Máximos FPS:',
            'Añadir',
            'Remover'
        ]
    ]);
    setPhrase('noteSplashEditorStateShader', [
        [
            'Shader',
            'Red:',
            'Green:',
            'Blue:',
            'Do not replace',
            'Color to Replace'
        ],
        [
            'Shader',
            'Rojo:',
            'Verde:',
            'Azul:',
            'No reemplazar',
            'Color a Reemplazar'
        ]
    ]);
}

function setupEditorsSubStatesLanguages()
{
    //Gameplay Changers Substate
    setPhrase('gameplayChangersSubstatePracticeMode', ['Practice Mode', 'Modo Práctica']);
    setPhrase('gameplayChangersSubstateBotplay', ['BotPlay', 'Automático']);

    //Preload List SubState
    setPhrase('preloadListSubStateUI', [
        [
            'Preload List',
            'Load File',
            'Load Folder',
            'Low Qual.',
            'High Qual.',
            'Story Mode',
            'Save'
        ],
        [
            'Lista de Precargado',
            'Cargar Archivo',
            'Cargar Carpeta',
            'Baja Cal.',
            'Alta Cal.',
            'Modo Hist.',
            'Guardar'
        ]
    ]);
    setPhrase('preloadListSubStateOutputs', [
        [
            'File added to preload: ',
            'File is already preloaded automatically!',
            'File must be inside images/music/songs subfolder!',
            'File must be inside assets/mods folder!',
            'File is not inside ALE Engine\'s folder!',
            'Load a .PNG/.OGG File...',
            'Unsupported Extension: ',
            'Load a folder...'
        ],
        [
            'Archivo añadido para precargar: ',
            'El archivo ya está precargado correctamente!',
            'El archivo debe estar dentro de la subcarpeta images, music o songs!',
            'El archivo debe estar dentro de la carpeta assets o mods!',
            'El archivo no está dentro de la carpeta de ALE Engine!',
            'Cargar un archivo PNG u OGG...',
            'Extension no Compatible: ',
            'Cargar una carpeta...'
        ]
    ]);
    setPhrase('preloadListSubStateFileFilters', [
        [
            'Image/Audio'
        ],
        [
            'Imagen/Audio'
        ]
    ]);
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