package utils.helpers;

import haxe.ds.StringMap;

import flixel.input.keyboard.FlxKey;

class CoolVars
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var developerMode:Bool = true;

	public static var scriptInitialState:String = '';
	public static var scriptFromPlayStateIfStoryMode:String = '';
	public static var scriptFromPlayStateIfFreeplay:String = '';
	public static var scriptFromEditors:String = '';
	public static var scriptOptionsState:String = '';
	public static var scriptPauseMenu:String = '';
	public static var scriptCrashState:String = '';

	public static var isConsoleVisible:Bool = false;

	public static var engineVersion:String = '';
	public static var onlineVersion:String = '';
	public static var outdated:Bool = false;
	
	public static var globalVars:StringMap<Dynamic> = new StringMap<Dynamic>();
	public static var globalFields:Dynamic = {};
}