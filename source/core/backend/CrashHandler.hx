package core.backend;

import flixel.addons.transition.FlxTransitionableState;

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

		if (Std.isOfType(CallStack.exceptionStack(true), Array))
		{
			var errMsg:String = "";
			var path:String;
			var callStack:Array<StackItem> = CallStack.exceptionStack(true);
			var dateNow:String = Date.now().toString();
	
			dateNow = dateNow.replace(" ", "_");
			dateNow = dateNow.replace(":", "'");
	
			path = "./crash/" + "PsychEngine_" + dateNow + ".txt";
	
			for (stackItem in callStack)
			{
				switch (stackItem)
				{
					case FilePos(s, file, line, column):
						errMsg += file + " (line " + line + ")\n";
					default:
						Sys.println(stackItem);
				}
			}
	
			errMsg += "\nUncaught Error: " + e.error + "\nPlease report this error to the GitHub page: https://github.com/AlejoGDOfficial/ALE-Engine\n\n> Crash Handler written by: sqirra-rng";
	
			Sys.println(errMsg);
	
			lime.app.Application.current.window.alert(errMsg, "Error!");
			
			#if DISCORD_ALLOWED
			DiscordClient.shutdown();
			#end

			Sys.exit(1);
		} else {
			MusicBeatState.switchState(new utils.scripting.ScriptCrashState(e.error, CallStack.exceptionStack(true)));
		}
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