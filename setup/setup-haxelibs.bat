@echo off
color 0a
cd ..
@echo on
echo Installing dependencies.
haxelib install openfl 9.3.3
haxelib install flixel-addons 3.2.3
haxelib install flixel-ui 2.6.1
haxelib install flixel-tools 1.5.1
haxelib install tjson 1.4.0
haxelib install setup/sscript.zip
haxelib install setup/hxdiscord_rpc.zip
haxelib install hxvlc 1.9.2
haxelib install away3d 5.0.9
haxelib git extension-androidtools https://github.com/MAJigsaw77/extension-androidtools --skip-dependencies
haxelib git flxanimate https://github.com/ShadowMario/flxanimate dev
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit 633fcc051399afed6781dd60cbf30ed8c3fe2c5a
haxelib git flixel https://github.com/MobilePorting/flixel 5.6.1
haxelib git hxcpp https://github.com/mcagabe19-stuff/hxcpp
haxelib git lime https://github.com/mcagabe19-stuff/lime-develop
echo Finished!
pause
