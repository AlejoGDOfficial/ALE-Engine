package backend;

import haxe.ds.StringMap;

import flixel.input.keyboard.FlxKey;

class CoolVars
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
	
	public static var globalVars:StringMap<Dynamic> = new StringMap<Dynamic>();

	public static var fpsTextWasAdded:Bool = false;
}