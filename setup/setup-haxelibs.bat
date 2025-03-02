@echo off
color 0a
cd ..
@echo on
echo Installing dependencies.

@if not exist ".haxelib\" mkdir .haxelib

haxelib install flixel-addons 3.2.3 --skip-dependencies
haxelib install flixel-ui 2.6.1 --skip-dependencies
haxelib install flixel-tools 1.5.1 --skip-dependencies
haxelib install tjson 1.4.0 --skip-dependencies
haxelib install away3d 5.0.9 --skip-dependencies
haxelib install hxdiscord_rpc 1.2.4 --skip-dependencies

haxelib install setup/sscript.zip --skip-dependencies

haxelib git lime https://github.com/MobilePorting/lime --skip-dependencies
haxelib git hxvlc https://github.com/MobilePorting/hxvlc --skip-dependencies
haxelib git openfl https://github.com/MobilePorting/openfl 9.3.3
haxelib git extension-androidtools https://github.com/MAJigsaw77/extension-androidtools --skip-dependencies
haxelib git flxanimate https://github.com/ShadowMario/flxanimate dev --skip-dependencies
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit 633fcc051399afed6781dd60cbf30ed8c3fe2c5a --skip-dependencies
haxelib git flixel https://github.com/MobilePorting/flixel 5.6.1 --skip-dependencies
haxelib git hxcpp https://github.com/mcagabe19-stuff/hxcpp
echo Finished!
pause
