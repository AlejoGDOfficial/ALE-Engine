# ALE Engine

## A Quick Guide for New Users

ALE Engine is not just Psych and that's it, it has some features that make it special, but if you don't know how to use them you won't be able to get the most out of the Engine, so here is a guide to prevent that from happening.
> AlejoGDOfficial

---

## data.json

If you decide to use ```template.zip```, which is located in the ```mods``` folder, you will notice that there is a file that appears as ```data.json```, with this file you can configure some aspects of your Mod, which can be quite useful, here I will quickly explain what each variable is for.

- **developerMode**: This is self-explanatory, it activates some options that can be useful when making your Mod, in the FPS Counter a text will appear that says ```DEVELOPER MODE```, this so that, when publishing your mod, you do not forget to deactivate it.

- **initialState**: With this variable you can indicate the name of the State Script with which the game will start, it can be useful if you basically do not like the names of the Scripts that come by default.

- **fromPlayStateIfStoryMode**: With this variable you can indicate which Script State the game will go to once you finish a Week, in this case, for example, ```storyMenuState``` is used.

- **fromPlayStateIfFreeplay**: It is the same as ```fromPlayStateIfStoryMode```, but this one indicates the name of the Script State when you play a song in Free Play, that is why ```freeplayState``` is used.

- **fromEditors**: With this variable you indicate the Script State that the game will go to when you exit an Editor if you entered it through the Master Editor Menu.

- **optionsState**: It's self explanatory, it's the Script State the game goes to when you choose the ```OPTIONS``` option in the pause menu.

- **pauseMenu**: It's self explanatory, the Script SubState that will be displayed when pausing a song while playing.

- **crashState**: It explains itself, it is the Script State (This one in particular has certain variations, for more information check the source code file ```source/utils/scripting/ScriptCrashState.hx```) to which the game will go once the game crashes.

- **transition**: This will be the SubState Script (with some variations, for more information check the source code file ```source/utils/scripting/ScriptTransition.hx```) that will be displayed when changing menus, like the typical black gradient that covers the screen and shows it again once the game has directed you to the next menu.

- **removeDefaultWeeks**: This variable will make the game not detect the songs that come by default in the game, if your mod does not have weeks yet, it can cause one or another problem, but adding a week solves it, so it is not something to worry about.

- **title**: This variable will cause the game window title to change to the text you put there once your mod is launched.

- **icon**: In this variable you can indicate the path of the image that you want to put in your mod, which will replace the app icon once your mod starts, the image must be a PNG and if possible it should have a width equal to the height.

---

## Script States/SubStates

### As files in Psych, these can be replaced.
#### For example:

The file ```assets/shared/scripts/states/introState.hx``` exists, and you decide to add the file ```mods/Your-Mod/scripts/states/introState.hx```, this will make your file now the one containing the code for that State/Menu, replacing it completely.

#### The same can be applied with Substates

The file ```assets/shared/scripts/substates/pauseSubstate.hx``` exists, and you decide to add the file ```mods/Your-Mod/scripts/substates/pauseSubstate.hx```, this will make your file now the one containing the code for that SubState/SubMenu, replacing it completely.

---

In order to replace the code it is necessary that both use the same programming language, if you try to replace ```introState.hx``` with ```introState.lua``` what you will do is that now both will be executed, which can cause you some problems.
