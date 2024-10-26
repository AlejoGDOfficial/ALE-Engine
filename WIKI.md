# ALE Engine Functions

<details><summary><h2>(Sub) States Functions</h2></summary>

> Can be used in all types of script!

#### Used to switch to a Script State.

* `switchToScriptState(scriptName, doTransition)`
    - Example: `switchToScriptState(mainMenuState, true)`


> Can only be used in Script States!

#### Used to switch to Specific States.

* `switchToSomeStates(stateName)`
    - Examples: <br/>
        `switchToSomeStates('options.OptionsState')` <br/>
        `switchToSomeStates('states.editors.ChartingState')` <br/>
        `switchToSomeStates('states.editors.CharacterEditorState')` <br/>
        `switchToSomeStates('states.editors.MenuCharacterEditorState')` <br/>
        `switchToSomeStates('states.editors.DialogueEditorState')` <br/>
        `switchToSomeStates('states.editors.DialogueCharacterEditorState')` <br/>
        `switchToSomeStates('states.editors.NoteSplashDebugState')`

#### Used to open Specific SubStates.

* `openSomeSubStates(subStateName)`
    - Examples: <br/>
        `openSomeSubStates('substates.GameplayChangersSubstate')`

#### Used to reload/reset the state being edited.

* `resetScriptState(doTransition)`
    - Example: `resetScriptState(true)`

</details>


<details><summary><h2>Songs Functions</h2></summary>

> Can only be used in Script States!
#### Used to load a song.

* `loadSong(song, difficulty, isStoryMode)`
    - Example: `loadSong('test', 'normal', false)`


#### Used to load a playlist/week.

* `loadWeek(songs, difficulties, difficultyNum, isStoryMode)`
    - Example: `loadWeek(['Test', 'Test'], ['Normal', 'Hard'], 0, true)`

</details>


<details><summary><h2>Window Functions</h2></summary>

> Can be used in all types of script!

#### Used to change the position of the window at a certain time.

* `doWindowTweenX(position, duration, ease)`
    - HScript Example: `doWindowTweenX(100, 1, FlxEase.cubeOut)`
    - Lua Example: `doWindowTweenX(100, 1, 'cubeOut')`

* `doWindowTweenY(position, duration, ease)`
    - HScript Example: `doWindowTweenY(50, 1, FlxEase.cubeIn)`
    - Lua Example: `doWindowTweenY(50, 1, 'cubeIn')`


#### Used to change the size of the window at a certain time.

* `doWindowTweenWidth(width, duration, ease)`
    - HScript Example: `doWindowTweenWidth(1000, 1, FlxEase.cubeOut)`
    - Lua Example: `doWindowTweenWidth(1000, 1, 'cubeOut')`

* `doWindowTweenHeight(height, duration, ease)`
    - HScript Example: `doWindowTweenHeight(500, 1, FlxEase.cubeIn)`
    - Lua Example: `doWindowTweenHeight(500, 1, 'cubeIn')`


#### Used to change the position of the window immediately.

* `setWindowX(position)`
    - Example: `setWindowX(100)`

* `setWindowY(position)`
    - Example: `setWindowY(100)`


#### Used to change the size of the window immediately.

* `setWindowWidth(width)`
    - Example: `setWindowWidth(100)`

* `setWindowY(height)`
    - Example: `setWindowWidth(100)`

#### Used to obtain the current position of the window.

* `getWindowX()`
* `getWindowY()`

#### Used to obtain the current size of the window.

* `getWindowWidth()`
* `getWindowHeight()`

#### Used to obtain the current size of the screen.

* `getScreenWidth()`
* `getScreenHeight()`

</details>

<details><summary><h2>C++ Functions</h2></summary>

> Can be used in all types of script!

#### Used to change the window title.

* `changeTitle(text)`
    - Example: `changeTitle('ALE Engine')`

#### Used to obtain the device RAM.

* `getDeviceRAM()`

#### Used to show a message box.

* `showMessageBox(message, caption, icon)`
    - Examples: </br>
        `showMessageBox('message', 'title', 0x00000010)` <br>
        `showMessageBox('message', 'title', 0x00000020)` <br>
        `showMessageBox('message', 'title', 0x00000030)` <br>
        `showMessageBox('message', 'title', 0x00000040)` <br>

#### Used to change the opacity of the window.

* `setWindowAlpha(alpha)`
    - Example: `setWindowAlpha(0.5)`

#### Used to obtain the current opacity of the window.

* `getWindowAlpha()`

#### Used to change the opacity of the window at a certain time.

* `doWindowTweenAlpha(alpha, duration, ease)`
    - HScript Example: `doWindowTweenAlpha(0.5, 2, FlxEase.cubeOut)`
    - Lua Example: `doWindowTweenAlpha(0.5, 2, 'cubeOut')`

#### Used to change the window border color.

* `setBorderColor(red, green, blue)`
    - Example: `setBorderColor(20, 230, 255)`

#### Used to show the console window.

* `showConsole()`

#### Used to hide the console window.

* `hideConsole()`

#### Used to hide Window's taskbar.

* `hideTaskbar(hide)`
    - Example: `hideTaskbar(true)`

#### Used to obtain the position of the mouse on the computer screen.

* `getCursorX()`
* `getCursorY()`

#### Used to clear the console window content.

* `clearTerminal()`

#### Used to change the console window title.

* `setConsoleTitle()`

#### Used to disable the possibility of closing the console window.

* `disableCloseConsole()`

#### Used to send a Windows notification.

* `sendNotification(title, description)`
    - Example: `sendNotification('For HER', 'I love you :3')`

</details>

<details><summary><h2>Language Functions</h2></summary>

> Can be used in all types of script!

#### Used to get any phrase in the current language.

* `getPhrase(id)`
    - Example: `getPhrase('pauseSubStatePracticeMode')`

#### Used to get the suffix for the current language.

* `getSuffix()`

> Can only be used in Script States! (script/states/config/config.hx)

#### Used to set the Languages that will be able in the game.

* `setLanguages(names, abbreviations)`
    - Example: `setLanguages(['English', 'Spanish'], ['eng', 'span'])`

#### Used to set any phrase in the able languages.

* `setPhrase(id, phrases)`
    - Example: `setPhrase('introStateWater', ['Water', 'Agua'])`

</details>

<details><summary><h2>Global Vars Functions</h2></summary>

> Can be used in all types of script!

#### Used to create/change a Global Var.

* `setGlobalVar(id, data)`
    - Example: `setGlobalVar('theEngineVersion', 'Alpha 2')`

#### Used to obtain data from a Global Var.

* `getGlobalVar(id)`
    - Example: `getGlobalVar('theEngineVersion')`

#### Used to verify if a Global Var exists.

* `existsGlobalVar(id)`
    - Example: `existsGlobalVar('theEngineVersion')`

#### Used to verify if a Global Var exists.

* `existsGlobalVar(id)`
    - Example: `existsGlobalVar('theEngineVersion')`

#### Used to remove a Global Var.

* `removeGlobalVar(id)`
    - Example: `removeGlobalVar('theEngineVersion')`

</details>