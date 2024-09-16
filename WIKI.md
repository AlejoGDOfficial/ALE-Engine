# ALE Engine Functions

<details><summary><h2>States Functions</h2></summary>

> Can be used in all types of script!

#### Used to switch to a Script State.

* `switchToScriptState(scriptName, doTransition)`
    - Example: `switchToScriptState(mainMenuState, true)`


> Can only be used in Script States!

#### Used to switch to Specific States.

* `switchToSomeStates(stateName)`
    - Examples: <br/>
        `switchToSomeStates('OptionsState')` <br/>
        `switchToSomeStates('ChartingState')` <br/>
        `switchToSomeStates('CharacterEditorState')` <br/>
        `switchToSomeStates('StageEditorState')` <br/>
        `switchToSomeStates('WeekEditorState')` <br/>
        `switchToSomeStates('MenuCharacterEditorState')` <br/>
        `switchToSomeStates('DialogueEditorState')` <br/>
        `switchToSomeStates('DialogueCharacterEditorState')` <br/>
        `switchToSomeStates('NoteSplashEditorState')`


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

</details>