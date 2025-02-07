package utils.helpers;

import haxe.ds.StringMap;

import flixel.input.keyboard.FlxKey;

class CoolVars
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

    public static var gameData(get, never):Dynamic;
	static function get_gameData():Dynamic
	{
		var jsonToLoad:String = Paths.modFolders('data.json');
		if(!FileSystem.exists(jsonToLoad)) jsonToLoad = Paths.getSharedPath('data.json');
	
		return haxe.Json.parse(sys.io.File.getContent(jsonToLoad));
	}

	public static var developerMode(get, never):Bool;
	static function get_developerMode() return Reflect.hasField(CoolVars.gameData, 'developerMode') ? CoolVars.gameData.developerMode : true;

	public static var scriptInitialState(get, never):String;
	static function get_scriptInitialState() return Reflect.hasField(CoolVars.gameData, 'initialState') ? CoolVars.gameData.initialState : 'introState';

	public static var scriptFromPlayStateIfStoryMode(get, never):String;
	static function get_scriptFromPlayStateIfStoryMode() return Reflect.hasField(CoolVars.gameData, 'fromPlayStateIfStoryMode') ? CoolVars.gameData.fromPlayStateIfStoryMode : 'storyMenuState';

	public static var scriptFromPlayStateIfFreeplay(get, never):String;
	static function get_scriptFromPlayStateIfFreeplay() return Reflect.hasField(CoolVars.gameData, 'fromPlayStateIfFreeplay') ? CoolVars.gameData.fromPlayStateIfFreeplay : 'freeplayState';

	public static var scriptFromEditors(get, never):String;
	static function get_scriptFromEditors() return Reflect.hasField(CoolVars.gameData, 'fromEditors') ? CoolVars.gameData.fromEditors : 'masterEditorMenu';

	public static var scriptOptionsState(get, never):String;
	static function get_scriptOptionsState() return Reflect.hasField(CoolVars.gameData, 'optionsState') ? CoolVars.gameData.optionsState : 'optionsState';

	public static var scriptPauseMenu(get, never):String;
	static function get_scriptPauseMenu() return Reflect.hasField(CoolVars.gameData, 'pauseMenu') ? CoolVars.gameData.pauseMenu : 'pauseSubstate';
	
	public static var scriptCrashState(get, never):String;
	static function get_scriptCrashState() return Reflect.hasField(CoolVars.gameData, 'crashState') ? CoolVars.gameData.crashState : 'crashState';

	public static var scriptTransition(get, never):String;
	static function get_scriptTransition() return Reflect.hasField(CoolVars.gameData, 'transition') ? CoolVars.gameData.transition : 'fadeTransition';

	public static var isConsoleVisible:Bool = false;

	public static var engineVersion:String = '';
	public static var onlineVersion:String = '';
	public static var outdated:Bool = false;
	
	public static var globalVars:StringMap<Dynamic> = new StringMap<Dynamic>();
	public static var globalFields:Dynamic = {};
}

