package utils.helpers;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;

import haxe.Json;

import core.config.MainState;

class CoolUtil
{
	inline public static function quantize(f:Float, snap:Float){
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		//trace(snap);
		return (m / snap);
	}

	inline public static function capitalize(text:String)
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	inline public static function coolTextFile(path:String):Array<String>
	{
		var daList:String = null;
		#if (sys && MODS_ALLOWED)
		var formatted:Array<String> = path.split(':'); //prevent "shared:", "preload:" and other library names on file path
		path = formatted[formatted.length-1];
		if(FileSystem.exists(path)) daList = File.getContent(path);
		#else
		if(Assets.exists(path)) daList = Assets.getText(path);
		#end
		return daList != null ? listFromString(daList) : [];
	}

	inline public static function colorFromString(color:String):FlxColor
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if(color.startsWith('0x')) color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if(colorNum == null) colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	inline public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
			daList[i] = daList[i].trim();

		return daList;
	}

	public static function floorDecimal(value:Float, decimals:Int):Float
	{
		if(decimals < 1)
			return Math.floor(value);

		var tempMult:Float = 1;
		for (i in 0...decimals)
			tempMult *= 10;

		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	inline public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth) {
			for(row in 0...sprite.frameHeight) {
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if(colorOfThisPixel != 0) {
					if(countByColor.exists(colorOfThisPixel))
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687))
						countByColor[colorOfThisPixel] = 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0; //after the loop this will store the max color
		countByColor[FlxColor.BLACK] = 0;
		for(key in countByColor.keys()) {
			if(countByColor[key] >= maxCount) {
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		countByColor = [];
		return maxKey;
	}

	inline public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max) dumbArray.push(i);

		return dumbArray;
	}

	inline public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	inline public static function openFolder(folder:String, absolute:Bool = false) {
		#if sys
			if(!absolute) folder =  Sys.getCwd() + '$folder';

			folder = folder.replace('/', '\\');
			if(folder.endsWith('/')) folder.substr(0, folder.length - 1);

			#if linux
			var command:String = '/usr/bin/xdg-open';
			#else
			var command:String = 'explorer.exe';
			#end
			Sys.command(command, [folder]);
			trace('$command $folder');
		#else
			FlxG.error("Platform is not supported for CoolUtil.openFolder");
		#end
	}

	/**
		Helper Function to Fix Save Files for Flixel 5

		-- EDIT: [November 29, 2023] --

		this function is used to get the save path, period.
		since newer flixel versions are being enforced anyways.
		@crowplexus
	**/
	@:access(flixel.util.FlxSave.validate)
	inline public static function getSavePath():String {
		final company:String = FlxG.stage.application.meta.get('company');
		// #if (flixel < "5.0.0") return company; #else
		return '${company}/${flixel.util.FlxSave.validate(FlxG.stage.application.meta.get('file'))}';
		// #end
	}

	public static function setTextBorderFromString(text:FlxText, border:String)
	{
		switch(border.toLowerCase().trim())
		{
			case 'shadow':
				text.borderStyle = SHADOW;
			case 'outline':
				text.borderStyle = OUTLINE;
			case 'outline_fast', 'outlinefast':
				text.borderStyle = OUTLINE_FAST;
			default:
				text.borderStyle = NONE;
		}
	}

    public static function getJsonValue(filePath:String, key:String):String 
	{
		try {
			var jsonString = Paths.getTextFromFile(filePath + '.json');
			var jsonData = Json.parse(jsonString);
			if (Reflect.hasField(jsonData, key)) {
				return Reflect.field(jsonData, key);
			} else {
				return 'Key not found';
			}
		} catch (e:Dynamic) {
			return 'Error reading file or processing JSON';
		}
    }

	public static function getCurrentState():Array<Dynamic>
	{
		var curState:String = Type.getClassName(Type.getClass(FlxG.state));

		if (FlxG.state is utils.scripting.ScriptState)
		{
			return [true, ScriptState.targetFileName];
		}

		return [false, curState];
	}

	public static function getCurrentSubState():Array<Dynamic>
	{
		var curSubState:String = Type.getClassName(Type.getClass(FlxG.state.subState));
		
		if (FlxG.state.subState is utils.scripting.ScriptSubstate)
		{
			return [true, ScriptSubstate.targetFileName];
		}
			
		return [false, curSubState];
	}

	public static function fpsLerp(v1:Float, v2:Float, ratio:Float)
	{
		return FlxMath.lerp(v1, v2, getFPSRatio(ratio));
	}

	public static function getFPSRatio(ratio:Float)
	{
		return FlxMath.bound(ratio * FlxG.elapsed * 60, 0, 1);
	}

    public static function getNestedValue(array:Dynamic, path:String):Dynamic 
	{
        var indices = path.split(' ').filter(function(s) return s != "");
        var result:Dynamic = array;
        for (index in indices) 
		{
            if (Std.isOfType(result, Array)) 
			{
                result = (result:Array<Dynamic>)[Std.parseInt(index)];
            } else {
                return null;
            }
        }
        return result;
    }

	public static function setNestedValue(array:Dynamic, path:String, value:Dynamic):Bool 
	{
		var indices = path.split(' ').filter(function(s) return s != "");
		var target:Dynamic = array;
		var lastIndex = indices.length - 1;
	
		for (i in 0...lastIndex) 
		{
			var index = Std.parseInt(indices[i]);
			if (Std.isOfType(target, Array) && index != null) 
			{
				target = (target:Array<Dynamic>)[index];
			} else {
				return false;
			}
		}

		var finalIndex = Std.parseInt(indices[lastIndex]);
		if (Std.isOfType(target, Array) && finalIndex != null) 
		{
			(target:Array<Dynamic>)[finalIndex] = value;
			return true;
		}
	
		return false;
	}
	
	public static function removeNestedValue(array:Dynamic, path:String):Bool 
	{
		var indices = path.split(' ').filter(function(s) return s != "");
		var target:Dynamic = array;
		var lastIndex = indices.length - 1;
	
		for (i in 0...lastIndex) {
			var index = Std.parseInt(indices[i]);
			if (Std.isOfType(target, Array) && index != null) {
				target = (target:Array<Dynamic>)[index];
			} else {
				return false;
			}
		}
		
		var finalIndex = Std.parseInt(indices[lastIndex]);
		if (Std.isOfType(target, Array) && finalIndex != null && finalIndex >= 0 && finalIndex < target.length) {
			(target:Array<Dynamic>).splice(finalIndex, 1);
			return true;
		}
	
		return false;
	}	

	public static function resetEngine()
	{
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		if (FlxG.state.subState != null) FlxG.state.subState.close();

		utils.scripting.ScriptCrashState.finishCallback = null;
		utils.scripting.ScriptCrashState.destroy();

		FlxG.game.removeChild(MainState.fpsVar);
		MainState.fpsVar = null;

		for (key in CoolVars.globalVars.keys()) CoolVars.globalVars.remove(key);

        #if windows cpp.WindowsCPP.setWindowBorderColor(255, 255, 255); #end
		
		FlxTween.globalManager.clear();

		FlxG.resetGame();
	}

	public static function askToGemini(key:String, input:String):String
	{
		var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + key;

		var jsonData = '{ "contents": [ { "parts": [ { "text": "' + input + '" } ] } ] }';
	
		var command = [
			"curl",
			"-X", "POST",
			"-H", "Content-Type: application/json",
			"-d", jsonData,
			url
		];
	
		var process = new Process(command[0], command.slice(1));
		var output = process.stdout.readAll().toString();
		process.close();

		try
		{
			var response = Json.parse(output);
	
			return response.candidates[0].content.parts[0].text;
		} catch(e:Dynamic) {
			return 'Error: ' + e;
		}
	}

	public static function showPopUp(title:String, message:String)
	{
		FlxG.stage.window.alert(message, title);
	}
}