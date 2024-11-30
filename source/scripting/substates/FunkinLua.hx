#if LUA_ALLOWED
package scripting.substates;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import openfl.Lib;
import openfl.utils.Assets;
import openfl.display.BitmapData;
import flixel.FlxBasic;
import flixel.FlxObject;

import flixel.FlxState;

#if (!flash && sys)
import flixel.addons.display.FlxRuntimeShader;
#end

import cutscenes.DialogueBoxPsych;

import objects.StrumNote;
import objects.Note;
import objects.NoteSplash;
import objects.Character;

import substates.PauseSubState;
import substates.GameOverSubstate;

import scripting.substates.HScript;

import scripting.substates.DebugLuaText;
import scripting.substates.ModchartSprite;

import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepadInputID;

import haxe.Json;

import sys.io.Process;

import cpp.*;

class FunkinLua {

	#if HSCRIPT_ALLOWED
	public var hscript:HScript = null;
	#end

	public function stop() {
		#if HSCRIPT_ALLOWED
		if(hscript != null)
		{
			hscript.destroy();
			hscript = null;
		}
		#end
	}

	public static function luaTrace(text:String, ignoreCheck:Bool = false, deprecated:Bool = false, color:FlxColor = FlxColor.WHITE) {
		if(ignoreCheck || getBool('luaDebugMode')) {
			if(deprecated && !getBool('luaDeprecatedWarnings')) {
				return;
			}
			ScriptSubstate.instance.addTextToDebug(text, color);
		}
	}
}
#end