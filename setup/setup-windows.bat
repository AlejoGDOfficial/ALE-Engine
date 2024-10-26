@echo off
color 0a
cd ..
@echo on
echo Installing dependencies...
haxelib install lime 8.2.0
haxelib install openfl 9.4.0
haxelib install flixel 5.8.0
haxelib install flixel-addons 3.2.3
haxelib install flixel-ui 2.6.1
haxelib install flixel-tools 1.5.1
haxelib install hxCodec 2.5.1
haxelib install tjson 1.4.0
haxelib git flxanimate https://github.com/ShadowMario/flxanimate dev
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib install setup/sscript.zip
haxelib install setup/hxdiscord_rpc.zip
echo Finished!
pause