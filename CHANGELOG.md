# Changelog

## 0.3.5

- Changelog history added  
- ScriptSubStates are now exclusive to HScript  
- FPS text has been recreated and improved  
- Now you can listen to instrumentals from FreeplayState  
- Added support for `scripts/global`, which will execute scripts there in both Songs and ScriptStates  
- Fixed the Crash Handler  
- Fixed video playback issues  
- Prevented crashes when the game had no music  
- Fixed Discord RPC and added customization support  
- Improved `data.json` and related variables  
- The game now starts a bit later to avoid startup errors  
- Ability to change the camera module in beats (via events)  
- The death screen is now fully customizable (SubState)  
- Improved ScriptSubStates  
- Transitions no longer freeze menus  
- Replaced `FlxTransitionableState.skipNextTransIn` and `FlxTransitionableState.skipNextTransOut` with `CoolVars.skipTransIn` and `CoolVars.skipTransOut`  
- Psych Engine 1.x charts are now compatible  
- Credits menu has been redone  
- Enabled week locking and hiding options  
- Transition code has been rewritten (now much more readable)  
- `pauseSubState` code has been rewritten (now much more readable)  
- Increased health drain when missing a note  
- Source code has been reorganized, again  
- Memory usage has been significantly reduced  
- Added the ability to create `FlxBackdrop` with Lua  
- The song playback speed can now be changed while playing using `Ctrl + Shift + F5` and `Ctrl + Shift + F6` in Developer Mode  
- A LOT of Bug Fixes

## 0.3.1

- Fixed a bug that changes the Selected Mod, which can be very annoying
- Improved Freeplay and Story Menu
- Songs load correctly
- Songs score is saved and loaded correctly

## 0.3.0

- ScriptSubStates were added
- Both the Options Menu and Options Support have been improved
- AI Generated Code was Removed
- Added a Screen to be displayed when the Game Crashes (Customizable) | Ft. VALEN.fla (Music) AdrianoSH & THE VOID (Art)
- Adjustments have been made to Make Compiling to Android Possible (Android Port is being worked on)
- Added Support for Pause Menu Customization (Now it is a ScriptSubState)
- Added Support for Customizable Transitions between Menus (Now a ScriptSubState)
- Improved/changed HUD a little bit
- Added CamHUD and CamOther to ScriptStates
- Errors are printed in CamOther, so you no longer need to Delete objects to see them
- Once the game crashes, you have the option to Restart or Close it, instead of being forced to close it
- Both data.json and options.json have been improved
- There have been slight optimizations in some Menus
- In both the Freeplay Menu and the Story Mode Menu the Song/Week Score is now displayed
- Some functions have been improved
- Changed HxCodec to HxVLC
- A small guide has been added to ```/mods```, it may be useful for users who do not know much about the Engine, although it is somewhat incomplete

## 0.2.1

- **Freeplay, Story Menu and Credits Menu** have been **greatly Optimized** and **Improved**
- The **Remaining Credits** of **Psych Engine** were **added**
- The **Way** to **Enter** the **Chart Editor** from the **Master Editor Menu** has **Been Improved**
- **Options** are now **Saved Correctly**
- The **"Beep" Sound** that **Played** when **Changing the Volume** was **Removed**

## 0.2.0

- **Custom Settings Support** via **JSON**
- **Fixed** a **crash** in the **Character Editor**

## 0.1.0

- The *engine* **detects** when *itself* is **outdated**, and **informs** it via **FPS text**

## Beta 4

- Changed some things in mod support
- The window title and icon can now be changed using an image in PNG format and data.json

## Beta 3

- Botplay text now displays in DownScroll
- Mods do not mix with each other
- Minor Bug Fixes

## Beta 2

- Credits and Weeks can be Changed via JSON
- Story Mode and Freeplay Menus Work as They Should
- Global Variables Are Removed When Changing Mods
- The Week Editor is Available and it Works

## Beta 1

- Small but necessary fixes in mod support


## Beta 0

- Mod Menu Fixes
- Fixed crashes
- Fixes in ScriptStates
- Optimizations
- Using Psych 0.7.3 as base, but HScript support works better (As in Psych 1.0 Pre-Release)

## Alpha 6

- Mod Menu Fixes
- Editors' Fixes
- Fixed crashes
- Language Support removed
- Fixes in ScriptStates
- Optimizations

## Alpha 5

- Better Mod support
- Optimizations
- Languages Editor
- Improvements in CoolUtil
- Fixes in ScriptStates
- Greater comfort in Gameplay and Mod Creation
- ALE Engine's Discord Rich Presence

## Alpha 4

- 1.0 Pre-Release was used again as a base
- Added a couple of features
- The engine can be used comfortably now!
- Performance was considerably improved
- Various arrangements were made

## Alpha 3

- The combos and intro were translated | Ft. Khorix the Inking (Artist) | Ft. AdrianoSH (Artist) | Ft. Aleja (Voice Actress)
- Ported to Psych 0.7.3 (For now)
- Various fixes in Lua functions of Script States

## Alpha 2

- New Script Functions
- Improved Script States | Ft. Khorix the Inking
- Improved Icons
- Performance improvements
- Support for multiple languages ​​(W.I.P)
- A lot of bug fixes
- FPS counter improvements
- Hide Console (Master Editor Menu)
- Editors run correctly
- HUD customization improvements
- New organization in the "mods/scripts" folder
- Some more things...

## Alpha 1

- New Script Functions *(C++)* | Ft. Slushi
- Some Script States
- Improved Icons
- A smooth transition to the dark mode of the window

## Alpha 0

- New Script Functions
- Some Script States