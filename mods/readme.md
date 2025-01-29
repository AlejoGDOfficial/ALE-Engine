# ALE Engine

## A Quick Guide for New Users

ALE Engine is not just Psych and that's it, it has some features that make it special, but if you don't know how to use them you won't be able to get the most out of the Engine, so here is a guide to prevent that from happening.
> AlejoGDOfficial

---

## Order of folders

When creating your mod it should be ```mods/Your-Mod/...```, not ```mods/...```, I consider that due to the capabilities of this Engine, it is not necessary, nor would it be a good idea to combine Mods with each other.

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

- **bpm**: In this variable you can adjust the bpm of the menus, I did this because they have a small zoom every four beats.

- **crashStateBpm**: It is the same as the ```bpm``` variable, but with the difference that it will only be applied to the State that is loaded when the game crashes.

---

## credits.json

Just like with Psych Engine, credits can be customized without any code, but I've changed the structure of this support so I'll show you how to set up your credits properly.

**JSON example**:

```
{
    "groups": [
        {
            "name": "ALE Engine Team",
            "members": [
                {
                    "name": "AlejoGDOfficial",
                    "icon": "alejoGDOfficial",
                    "description": "Main Programmer and Head",
                    "color": "03B1FC"
                },
                {
                    "name": "Aleja",
                    "icon": "aleja",
                    "description": "Artist, Voice Actress",
                    "color": "404040"
                }
            ]
        },
        {
            "name": "Funkin' Crew",
            "members": [
                {
                    "name": "ninjamuffin99",
                    "icon": "ninjamuffin99",
                    "description": "Programmer of Friday Night Funkin'",
                    "color": "CF2D2D"
                },
                {
                    "name": "PhantomArcade",
                    "icon": "phantomarcade",
                    "description": "Animator of Friday Night Funkin'",
                    "color": "FADC45"
                }
            ]
        }
    ]
}
```

At first glance it seems a bit complicated, so I'll explain how everything works.

- **groups**: This variable simply contains the information of all the Developer Groups, each group must go within this set.

    - **name**: This variable contains the name of the Work Group or Team.

    - **members**: This variable contains information about each of the Group's developers.

        - **name**: This variable contains the name of the Developer.

        - **icon**: This variable contains the name of the image that will be displayed next to the username (icon), these images, by default, are located in ```images/credits```.

        - **description**: This variable contains the Developer description, you can put the Role he had in the mod, a funny phrase, etc.

        - **color**: This variable contains the color (in Hexadecimal) that the credits menu background will change to once you choose that developer.

---

## options.json

In this Engine you have the ability to customize the options without the need for code, only with the help of a JSON.

**JSON example**:

```
{
    "menus": [
        {
            "name": "Options Example",
            "options": [
                {
                    "name": "Bool Example",
                    "description": "Uses Bools.",
                    "variable": "boolExample",
                    "type": "bool",
                    "default": true
                },
                {
                    "name": "Integer Example",
                    "description": "Uses Integers.",
                    "variable": "integerExample",
                    "type": "integer",
                    "min": 0,
                    "max": 10,
                    "change": 1,
                    "default": 0
                },
                {
                    "name": "Float Example",
                    "description": "Uses Floats.",
                    "variable": "floatExample",
                    "type": "float",
                    "min": 0,
                    "max": 10,
                    "change": 0.1,
                    "decimals": 2,
                    "default": 0
                },
                {
                    "name": "String Example",
                    "description": "Uses Strings.",
                    "variable": "stringExample",
                    "type": "string",
                    "strings": [
                        "String 1",
                        "String 2",
                        "String 3"
                    ],
                    "default": "String 1"
                },
                {
                    "name": "Locked Example",
                    "description": "Cannot be Changed.",
                    "variable": "stringExample",
                    "type": "string",
                    "strings": [
                        "Example 1",
                        "Example 2",
                        "Example 3"
                    ],
                    "default": "String 1",
                    "blocked": true
                }
            ]
        },
        {
            "name": "State Example",
            "stateData": {
                "state": "gameplay.states.editors.ChartingState"
            }
        },
        {
            "name": "Script State Example",
            "stateData": {
                "state": "introState",
                "script": true
            }
        },
        {
            "name": "SubState Example",
            "stateData": {
                "subState": "gameplay.states.substates.ModsMenuSubState"
            }
        },
        {
            "name": "Script SubState Example",
            "stateData": {
                "subState": "pauseSubstate",
                "script": true
            }
        }
    ]
}
```

It seems a bit complicated, but I will also explain each of the variables here.

- **menus**: This variable contains information about all options (In this example they are not shown, but the Engine options are also included, if you would like to leave one to your liking and not be able to change it, please do not delete it, use the variable ```blocked```)

    - **name**: This variable contains the name of the Menu/Category.

    - **options**: This variable contains information about each of the options in this Menu/Category.
    
        - **name**: This variable contains the Name of the Option.

        - **description**: This variable contains the description of the option.

        - **variable**: This variable contains the name of the variable that will be used to obtain the value of that option, if it is a default option ```ClientPrefs.data.variable``` is used, if it is a custom option ```ClientPrefs.modData.variable``` is used.

        - **type**: This variable contains the type of the option, here you must put one of the following options: ```"bool"```, ```"integer"```, ```"float"``` or ```"string"```.

        - **default**: It is the default value assigned to the option, the type of value depends on what you chose in ```type```, if you chose ```"bool"``` you must put ```true``` or ```false```, if you chose ```"int"``` you must put integers, if you chose ```"float"``` you can put both integers and decimal numbers, if you chose ```"string"``` you must put a text, for example: ```"Option 1"```.

        > In case you have chosen ```"float"``` or ```"int"```

        - **min**: This variable holds the smallest number that option can display, if you chose ```"float"``` you can use decimal numbers, otherwise please don't.

        - **max**: This variable holds the largest number that option can display, if you chose ```"float"``` you can use decimal numbers, otherwise please don't.

        - **change**: This variable contains the amount of numbers that are added or subtracted when moving this type of options, if you click on the right and this variable contains a ```2```, then two units will be added to the option, if you chose ```float``` you can use decimal numbers.

        > In case you have chosen ```"float"```

        - **decimals**: This variable contains the number of decimal places that the option can have, for example, if this variable is equal to ```4```, ```3.1415``` will be displayed, otherwise, if it is equal to ```2```, ```2.14``` will be displayed.
        
        > In case you have chosen ```"string"```

        - **strings**: This variable is an array containing the texts as options, for example: ```["Option 1", "Option 2", "Option 3"]```.


    - **stateData**: This variable contains the information of the SubState/State that the game will go to or display when choosing this Menu.

        - **state**: This variable contains the name/path of the State the game will go to when this Menu is selected.

        - **subState**: This variable contains the name/path of the SubState that the game should display when selecting this Menu.

        - **script**: This variable is used to decide whether the State or SubState chosen is a Script or not.

---

## Script States/SubStates

### As files in Psych, these can be replaced.
#### For example:

The file ```assets/shared/scripts/states/introState.hx``` exists, and you decide to add the file ```mods/Your-Mod/scripts/states/introState.hx```, this will make your file now the one containing the code for that State/Menu, replacing it completely.

#### The same can be applied with Substates

The file ```assets/shared/scripts/substates/pauseSubstate.hx``` exists, and you decide to add the file ```mods/Your-Mod/scripts/substates/pauseSubstate.hx```, this will make your file now the one containing the code for that SubState/SubMenu, replacing it completely.

In order to replace the code it is necessary that both use the same programming language, if you try to replace ```introState.hx``` with ```introState.lua``` what you will do is that now both will be executed, which can cause you some problems.
