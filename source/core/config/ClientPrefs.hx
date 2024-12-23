package core.config;

import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepadInputID;
import haxe.Json;
import sys.io.File;

// Add a variable here and it will get automatically saved
@:structInit class SaveVariables {
	public var arrowRGB:Array<Array<FlxColor>> = [
		[0xFFC24B99, 0xFFFFFFFF, 0xFF3C1F56],
		[0xFF00FFFF, 0xFFFFFFFF, 0xFF1542B7],
		[0xFF12FA05, 0xFFFFFFFF, 0xFF0A4447],
		[0xFFF9393F, 0xFFFFFFFF, 0xFF651038]
	];
	public var arrowRGBPixel:Array<Array<FlxColor>> = [
		[0xFFE276FF, 0xFFFFF9FF, 0xFF60008D],
		[0xFF3DCAFF, 0xFFF4FFFF, 0xFF003060],
		[0xFF71E300, 0xFFF6FFE6, 0xFF003100],
		[0xFFFF884E, 0xFFFFFAF5, 0xFF6C0000]
	];

	public var comboOffset:Array<Int> = [0, 0, 0, 0];
	public var noteOffset:Int = 0;
	
	public var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative',
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false
	];

	public var currentModFolder:String = '';
}

class ClientPrefs {
	public static var jsonDefaultData:Dynamic = {};
	public static var jsonCustomData:Dynamic = {};

	public static var data:SaveVariables = {};
	public static var defaultData:SaveVariables = {};

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		'note_up'		=> [W, UP],
		'note_left'		=> [A, LEFT],
		'note_down'		=> [S, DOWN],
		'note_right'	=> [D, RIGHT],
		
		'ui_up'			=> [W, UP],
		'ui_left'		=> [A, LEFT],
		'ui_down'		=> [S, DOWN],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [SPACE, ENTER],
		'back'			=> [BACKSPACE, ESCAPE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [R],
		
		'volume_mute'	=> [ZERO],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],
		
		'debug_1'		=> [SEVEN],
		'debug_2'		=> [EIGHT]
	];
	public static var gamepadBinds:Map<String, Array<FlxGamepadInputID>> = [
		'note_up'		=> [DPAD_UP, Y],
		'note_left'		=> [DPAD_LEFT, X],
		'note_down'		=> [DPAD_DOWN, A],
		'note_right'	=> [DPAD_RIGHT, B],
		
		'ui_up'			=> [DPAD_UP, LEFT_STICK_DIGITAL_UP],
		'ui_left'		=> [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
		'ui_down'		=> [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
		'ui_right'		=> [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],
		
		'accept'		=> [A, START],
		'back'			=> [B],
		'pause'			=> [START],
		'reset'			=> [BACK]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;
	public static var defaultButtons:Map<String, Array<FlxGamepadInputID>> = null;

	public static function resetKeys(controller:Null<Bool> = null) //Null = both, False = Keyboard, True = Controller
	{
		if(controller != true)
			for (key in keyBinds.keys())
				if(defaultKeys.exists(key))
					keyBinds.set(key, defaultKeys.get(key).copy());

		if(controller != false)
			for (button in gamepadBinds.keys())
				if(defaultButtons.exists(button))
					gamepadBinds.set(button, defaultButtons.get(button).copy());
	}

	public static function clearInvalidKeys(key:String)
	{
		var keyBind:Array<FlxKey> = keyBinds.get(key);
		var gamepadBind:Array<FlxGamepadInputID> = gamepadBinds.get(key);
		while(keyBind != null && keyBind.contains(NONE)) keyBind.remove(NONE);
		while(gamepadBind != null && gamepadBind.contains(NONE)) gamepadBind.remove(NONE);
	}

	public static function loadDefaultKeys()
	{
		defaultKeys = keyBinds.copy();
		defaultButtons = gamepadBinds.copy();
	}

	public static function saveSettings() {
		for (key in Reflect.fields(data))
			Reflect.setField(FlxG.save.data, key, Reflect.field(data, key));

		FlxG.save.flush();

		//Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		var save:FlxSave = new FlxSave();
		save.bind('controls_v3', CoolUtil.getSavePath());
		save.data.keyboard = keyBinds;
		save.data.gamepad = gamepadBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {

		for (key in Reflect.fields(data))
			if (key != 'gameplaySettings' && Reflect.hasField(FlxG.save.data, key))
				Reflect.setField(data, key, Reflect.field(FlxG.save.data, key));
		
		if(MainState.fpsVar != null)
			MainState.fpsVar.visible = getJsonPref('fpsCounter');

		#if (!html5 && !switch)
		if(getJsonPref('framerate') == null)
		{
			final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
		}
		#end

		if(getJsonPref('framerate') > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = getJsonPref('framerate');
			FlxG.drawFramerate = getJsonPref('framerate');
		}
		else
		{
			FlxG.drawFramerate = getJsonPref('framerate');
			FlxG.updateFramerate = getJsonPref('framerate');
		}

		if(FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
				data.gameplaySettings.set(name, value);
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;
		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		#if DISCORD_ALLOWED
		DiscordClient.check();
		#end

		// controls on a separate save file
		var save:FlxSave = new FlxSave();
		save.bind('controls_v3', CoolUtil.getSavePath());
		if(save != null)
		{
			if(save.data.keyboard != null)
			{
				var loadedControls:Map<String, Array<FlxKey>> = save.data.keyboard;
				for (control => keys in loadedControls)
					if(keyBinds.exists(control)) keyBinds.set(control, keys);
			}
			if(save.data.gamepad != null)
			{
				var loadedControls:Map<String, Array<FlxGamepadInputID>> = save.data.gamepad;
				for (control => keys in loadedControls)
					if(gamepadBinds.exists(control)) gamepadBinds.set(control, keys);
			}
			reloadVolumeKeys();
		}

		if (data.currentModFolder == '')
		{
			data.currentModFolder = '<No Mods>';
			
			saveSettings();
		} else if (FileSystem.exists(Paths.mods(data.currentModFolder)) && FileSystem.isDirectory(Paths.mods(data.currentModFolder))) {
			Mods.currentModDirectory = data.currentModFolder;
		} else {
			data.currentModFolder = '<No Mods>';
			
			saveSettings();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic = null, ?customDefaultValue:Bool = false):Dynamic
	{
		if(!customDefaultValue) defaultValue = defaultData.gameplaySettings.get(name);
		return /*PlayState.isStoryMode ? defaultValue : */ (data.gameplaySettings.exists(name) ? data.gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadVolumeKeys()
	{
		CoolVars.muteKeys = keyBinds.get('volume_mute').copy();
		CoolVars.volumeDownKeys = keyBinds.get('volume_down').copy();
		CoolVars.volumeUpKeys = keyBinds.get('volume_up').copy();
		toggleVolumeKeys(true);
	}
	public static function toggleVolumeKeys(?turnOn:Bool = true)
	{
		FlxG.sound.muteKeys = turnOn ? CoolVars.muteKeys : [];
		FlxG.sound.volumeDownKeys = turnOn ? CoolVars.volumeDownKeys : [];
		FlxG.sound.volumeUpKeys = turnOn ? CoolVars.volumeUpKeys : [];
	}

	public static function loadJsonPrefs()
	{
		if (FileSystem.exists(Paths.getSharedPath('preferences/defaultData.json')))
		{
			jsonDefaultData = Json.parse(File.getContent(Paths.getSharedPath('preferences/defaultData.json')));
		} else if (FileSystem.exists(Paths.getSharedPath('defaultOptions.json'))) {
			var jsonData = Json.parse(File.getContent(Paths.getSharedPath('defaultOptions.json')));
			for (menu in (jsonData.menus : Array<Dynamic>)) 
			{
				for (option in (menu.options : Array<Dynamic>)) 
				{
					Reflect.setField(jsonDefaultData, Reflect.field(option, "variable"), Reflect.field(option, "default"));
				}
			}
		}

		if (FileSystem.exists(Paths.mods(Mods.currentModDirectory + '/preferences/customData.json')))
		{
			jsonCustomData = Json.parse(File.getContent(Paths.mods(Mods.currentModDirectory + '/preferences/customData.json')));
		} else if (FileSystem.exists(Paths.mods(Mods.currentModDirectory + 'customOptions.json'))) {
			var jsonData = Json.parse(File.getContent(Paths.mods(Mods.currentModDirectory + 'customOptions.json')));
			for (menu in (jsonData.menus : Array<Dynamic>)) 
			{
				for (option in (menu.options : Array<Dynamic>)) 
				{
					Reflect.setField(jsonCustomData, Reflect.field(option, "variable"), Reflect.field(option, "default"));
				}
			}
		}
	}

	public static function getJsonPref(variable:String):Dynamic
	{
		if (Reflect.hasField(jsonDefaultData, variable)) return Reflect.field(jsonDefaultData, variable);
		else if (Reflect.hasField(jsonCustomData, variable)) return Reflect.field(jsonCustomData, variable);

		return null;
	}
}
