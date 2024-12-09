package utils.helpers;

import haxe.ds.StringMap;

import flixel.input.keyboard.FlxKey;

class CoolVars
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var developerMode:Bool = true;

	public static var scriptFromInitialState:String = '';
	public static var scriptFromPlayStateIfStoryMode:String = '';
	public static var scriptFromPlayStateIfFreeplay:String = '';
	public static var scriptFromEditors:String = '';
	public static var scriptFromOptions:String = '';
	
	public static var globalVars:StringMap<Dynamic> = new StringMap<Dynamic>();
}