package core.backend;

import haxe.CallStack;
import openfl.events.UncaughtErrorEvent;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;
using flixel.util.FlxArrayUtil;

class CrashHandler
{
	public static function init():Void
	{
		openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
		#if cpp
		untyped __global__.__hxcpp_set_critical_error_handler(onError);
		#elseif hl
		hl.Api.setErrorHandler(onError);
		#end
	}

	private static function onUncaughtError(e:UncaughtErrorEvent):Void
	{
		e.preventDefault();

		if (FlxG.sound.music != null) FlxG.sound.music.pause();
		
		if (PlayState.instance != null)
		{
			if (PlayState.instance.vocals != null) PlayState.instance.vocals.pause();
			if (PlayState.instance.opponentVocals != null) PlayState.instance.opponentVocals.pause();
		}

		CoolVars.skipTransIn = CoolVars.skipTransOut = true;
		MusicBeatState.switchState(new utils.scripting.ScriptCrashState(e.error, CallStack.exceptionStack(true)));
	}

	#if (cpp || hl)
	private static function onError(message:Dynamic):Void
	{
		final log:Array<String> = [];

		if (message != null && message.length > 0)
			log.push(message);

		log.push(haxe.CallStack.toString(haxe.CallStack.exceptionStack(true)));

		CoolUtil.showPopUp(log.join('\n'), "Critical Error!");

		#if DISCORD_ALLOWED DiscordClient.shutdown(); #end

		lime.system.System.exit(1);
	}
	#end
}