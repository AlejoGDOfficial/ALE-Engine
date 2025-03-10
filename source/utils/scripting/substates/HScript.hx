package utils.scripting.substates;

import flixel.FlxBasic;
import visuals.objects.Character;
import utils.scripting.states.LuaUtils;

import core.music.Song;
import utils.save.WeekData;

import openfl.Lib;

#if (windows && cpp) import cpp.*; #end

import utils.save.Highscore;

#if HSCRIPT_ALLOWED
import tea.SScript;
typedef Tea = TeaCall;

class HScript extends SScript
{
	public var modFolder:String;

	//ALE Shit INIT

	private function windowTweenUpdateAlpha(value:Float)
	{
		#if (windows && cpp) WindowsCPP.setWindowAlpha(value); #end
	}

	//ALE Shit END

	public var origin:String;
	override public function new(?parent:Dynamic, ?file:String, ?varsToBring:Any = null)
	{
		if (file == null)
			file = '';

		this.varsToBring = varsToBring;
	
		super(file, false, false);

		if (scriptFile != null && scriptFile.length > 0)
		{
			this.origin = scriptFile;
			#if MODS_ALLOWED
			var myFolder:Array<String> = scriptFile.split('/');
			if(myFolder[0] + '/' == Paths.mods() && (Mods.currentModDirectory == myFolder[1] || Mods.getGlobalMods().contains(myFolder[1]))) //is inside mods folder
				this.modFolder = myFolder[1];
			#end
		}

		preset();
		execute();
	}

	var varsToBring:Any = null;
	override function preset() {
		super.preset();

		// Some very commonly used classes
		set('FlxG', flixel.FlxG);
		set('FlxMath', flixel.math.FlxMath);
		set('FlxSprite', flixel.FlxSprite);
		set('FlxText', flixel.text.FlxText);
		set('FlxCamera', flixel.FlxCamera);
		set('ALECamera', visuals.ALECamera);
		set('FlxTimer', flixel.util.FlxTimer);
		set('FlxTween', flixel.tweens.FlxTween);
		set('FlxEase', flixel.tweens.FlxEase);
		set('FlxColor', CustomFlxColor);
		set('ScriptSubState', ScriptSubState);
		set('Paths', Paths);
		set('Conductor', Conductor);
		set('ClientPrefs', ClientPrefs);
		set('Character', Character);
		set('Alphabet', Alphabet);
		set('File', sys.io.File);
		set('Json', haxe.Json);
		#if (!flash && sys)
		set('FlxRuntimeShader', flixel.addons.display.FlxRuntimeShader);
		#end
		set('ShaderFilter', openfl.filters.ShaderFilter);
		set('StringTools', StringTools);
		#if flxanimate
		set('FlxAnimate', FlxAnimate);
		#end
		set('Lib', openfl.Lib);
		set('CoolVars', utils.helpers.CoolVars);
		set('CoolUtil', utils.helpers.CoolUtil);
		set('MusicBeatState', core.backend.MusicBeatState);
		set('DiscordClient', core.config.DiscordClient);
		
		set('AttachedText', visuals.objects.AttachedText);
		set('MenuCharacter', visuals.objects.MenuCharacter);
		set('DialogueCharacterEditorState', game.editors.DialogueCharacterEditorState);
		set('DialogueEditorState', game.editors.DialogueEditorState);
		set('MenuCharacterEditorState', game.editors.MenuCharacterEditorState);
		set('NoteSplashEditorState', game.editors.NoteSplashEditorState);
		set('WeekEditorState', game.editors.WeekEditorState);
		set('ControlsSubState', game.substates.ControlsSubState);
		set('NoteOffsetState', game.states.NoteOffsetState);
		set('NotesSubState', game.substates.NotesSubState);

		//ALE Shit INIT

		set('FlxFlicker', flixel.effects.FlxFlicker);
		set('FlxBackdrop', flixel.addons.display.FlxBackdrop);
		set('FlxOgmo3Loader', flixel.addons.editors.ogmo.FlxOgmo3Loader);
		set('FlxTilemap', flixel.tile.FlxTilemap);
		set('Process', sys.io.Process);
		set('FlxView3D', flx3d.FlxView3D);
		set('Flx3DView', flx3d.Flx3DView);
		set('Flx3DUtil', flx3d.Flx3DUtil);
		set('Flx3DCamera', flx3d.Flx3DCamera);
		set('FlxGradient', flixel.util.FlxGradient);
		set('FlxVideo', hxvlc.flixel.FlxVideo);

        set("switchToScriptSubState", function(name:String, ?doTransition:Bool = true)
		{
			CoolVars.skipTransIn = !doTransition;
			CoolVars.skipTransOut = !doTransition;
			MusicBeatState.switchState(new ScriptSubState(name));
		});
		set("switchState", function(fullClassPath:String, params:Array<Dynamic>, ?doTransition:Bool = true)
		{
			CoolVars.skipTransIn = !doTransition;
			CoolVars.skipTransOut = !doTransition;
			MusicBeatState.switchState(Type.createInstance(Type.resolveClass(fullClassPath), params));
		});
		set('openSubState', function(fullClassPath:String, params:Array<Dynamic>)
		{
			ScriptSubState.instance.openSubState(Type.createInstance(Type.resolveClass(fullClassPath), params));
		});
        set('openScriptSubState', function(substate:String)
        {
            FlxG.state.openSubState(new ScriptSubState(substate));
        });

		set('loadSong', function(song:String, difficulty:Int)
		{
			try
			{
				var songLowercase:String = Paths.formatToSongPath(song);
				var poop:String = Highscore.formatSong(songLowercase, difficulty);
		
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.storyDifficulty = difficulty;
			} catch(e:Dynamic) {
				throw 'ERROR!' + e;
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}
		
			LoadingState.loadAndSwitchState(new PlayState());
		});
		set('loadWeek', function (songs:Array<String>, diffInt:Int)
		{
			PlayState.storyPlaylist = songs;
		
			Difficulty.loadFromWeek();
		
			var diffic = Difficulty.getFilePath(diffInt);
			if (diffic == null) diffic = '';
		
			PlayState.storyDifficulty = diffInt;
		
			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
		});
		
		set('doWindowTweenX', function(pos:Int, time:Float, theEase:Dynamic)
		{
			FlxTween.tween(Lib.application.window, {x: pos}, time, {ease: theEase});
		});
		set('doWindowTweenY', function(pos:Int, time:Float, theEase:Dynamic)
		{
			FlxTween.tween(Lib.application.window, {y: pos}, time, {ease: theEase});
		});
		set('doWindowTweenWidth', function(pos:Int, time:Float, theEase:Dynamic)
		{
			FlxTween.tween(Lib.application.window, {width: pos}, time, {ease: theEase});
		});
		set('doWindowTweenHeight', function(pos:Int, time:Float, theEase:Dynamic)
		{
			FlxTween.tween(Lib.application.window, {height: pos}, time, {ease: theEase});
		});
		set("setWindowX", function(pos:Int)
		{
			Lib.application.window.x = pos;
		});
		set("setWindowY", function(pos:Int)
		{
			Lib.application.window.y = pos;
		});
		set("setWindowWidth", function(pos:Int)
		{
			Lib.application.window.width = pos;
		});
		set("setWindowHeight", function(pos:Int)
		{
			Lib.application.window.height = pos;
		});
		set("getWindowX", function(pos:Int)
		{
			return Lib.application.window.x;
		});
		set("getWindowY", function(pos:Int)
		{
			return Lib.application.window.y;
		});
		set("getWindowWidth", function(pos:Int)
		{
			return Lib.application.window.width;
		});
		set("getWindowHeight", function(pos:Int)
		{
			return Lib.application.window.height;
		});

		//Global Vars

		set("setGlobalVar", function(id:String, data:Dynamic)
		{
			CoolVars.globalVars.set(id, data);
		});
		set("getGlobalVar", function(id:String)
		{
			return CoolVars.globalVars.get(id);
		});
		set("existsGlobalVar", function(id:String)
		{
			return CoolVars.globalVars.exists(id);
		});
		set("removeGlobalVar", function(id:String)
		{
			CoolVars.globalVars.remove(id);
		});

		//CPP

		set('changeTitle', function(titleText:String)
		{
			#if (windows && cpp) lime.app.Application.current.window.title = titleText;
			WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title); #end
		});
		
		set('getDeviceRAM', function()
		{
			#if (windows && cpp) WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			return WindowsCPP.obtainRAM(); #end
		});
		
		set('screenCapture', function(path:String)
		{
			#if (windows && cpp) WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			WindowsCPP.windowsScreenShot(path); #end
		});
	
		set('showMessageBox', function(message:String, caption:String, icon:#if (windows && cpp) WindowsAPI.MessageBoxIcon #else Dynamic #end)
		{
			#if (windows && cpp) WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			WindowsCPP.showMessageBox(caption, message, icon); #end
		});
		
		set('setWindowAlpha', function(a:Float)
		{
			#if (windows && cpp) WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			WindowsCPP.setWindowAlpha(a); #end
		});
		set('getWindowAlpha', function()
		{
			#if (windows && cpp) WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			return WindowsCPP.getWindowAlpha(); #end
		});
		set('doWindowTweenAlpha', function(alpha:Float, time:Float, theEase:Dynamic)
		{
			#if (windows && cpp) FlxTween.num(WindowsCPP.getWindowAlpha(), alpha, time, {ease: theEase}, windowTweenUpdateAlpha); #end
		});
	
		set('setBorderColor', function(r:Int, g:Int, b:Int)
		{
			#if (windows && cpp) WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			WindowsCPP.setWindowBorderColor(r, g, b); #end
		});
		
		set('hideTaskbar', function(hide:Bool)
		{
			#if (windows && cpp) WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			WindowsCPP.hideTaskbar(hide); #end
		});
	
		set('getCursorX', function()
		{
			#if (windows && cpp) return WindowsCPP.getCursorPositionX(); #end
		});
	
		set('getCursorY', function()
		{
			#if (windows && cpp) return WindowsCPP.getCursorPositionY(); #end
		});
	
		set('clearTerminal', function()
		{
			#if (windows && cpp) WindowsTerminalCPP.clearTerminal(); #end
		});
	
		set('showConsole', function()
		{
			#if (windows && cpp) WindowsTerminalCPP.allocConsole(); #end
		});
	
		set('setConsoleTitle', function(title:String)
		{
			#if (windows && cpp) WindowsTerminalCPP.setConsoleTitle(title); #end
		});
	
		set('disableCloseConsole', function()
		{
			#if (windows && cpp) WindowsTerminalCPP.disableCloseConsoleWindow(); #end
		});
	
		set('hideConsole', function()
		{
			#if (windows && cpp) WindowsTerminalCPP.hideConsoleWindow(); #end
		});
	
		set('sendNotification', function(title:String, desc:String)
		{
			#if (windows && cpp) var powershellCommand = "powershell -Command \"& {$ErrorActionPreference = 'Stop';"
				+ "$title = '"
				+ desc
				+ "';"
				+ "[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null;"
				+ "$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01);"
				+ "$toastXml = [xml] $template.GetXml();"
				+ "$toastXml.GetElementsByTagName('text').AppendChild($toastXml.CreateTextNode($title)) > $null;"
				+ "$xml = New-Object Windows.Data.Xml.Dom.XmlDocument;"
				+ "$xml.LoadXml($toastXml.OuterXml);"
				+ "$toast = [Windows.UI.Notifications.ToastNotification]::new($xml);"
				+ "$toast.Tag = 'Test1';"
				+ "$toast.Group = 'Test2';"
				+ "$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('"
				+ title
				+ "');"
				+ "$notifier.Show($toast);}\"";
	
			if (title != null && title != "" && desc != null && desc != "")
				new Process(powershellCommand); #end
		});

		//Utils
	
		set('fpsLerp', function(v1:Float, v2:Float, ratio:Float)
		{
			return CoolUtil.fpsLerp(v1, v2, ratio);
		});
	
		set('getFPSRatio', function(ratio:Float)
		{
			return CoolUtil.getFPSRatio(ratio);
		});
	
		set('askToGemini', function(key:String, input:String)
		{
			return CoolUtil.askToGemini(key, input);
		});
		
		//ALE Shit END

		// Functions & Variables
		set('setVar', function(name:String, value:Dynamic) {
			ScriptSubState.instance.variables.set(name, value);
			return value;
		});
		set('getVar', function(name:String) {
			var result:Dynamic = null;
			if(ScriptSubState.instance.variables.exists(name)) result = ScriptSubState.instance.variables.get(name);
			return result;
		});
		set('removeVar', function(name:String)
		{
			if(ScriptSubState.instance.variables.exists(name))
			{
				ScriptSubState.instance.variables.remove(name);
				return true;
			}
			return false;
		});
		set('debugPrint', function(text:String, ?color:FlxColor = null) {
			if(color == null) color = FlxColor.WHITE;
			ScriptSubState.instance.addTextToDebug(text, color);
		});
		set('getModSetting', function(saveTag:String, ?modName:String = null) {
			if(modName == null)
			{
				if(this.modFolder == null)
				{
					ScriptSubState.instance.addTextToDebug('getModSetting: Argument #2 is null and script is not inside a packed Mod folder!', FlxColor.RED);
					return null;
				}
				modName = this.modFolder;
			}
			return LuaUtils.getModSetting(saveTag, modName);
		});

		// Keyboard & Gamepads
		set('keyboardJustPressed', function(name:String) return Reflect.getProperty(FlxG.keys.justPressed, name));
		set('keyboardPressed', function(name:String) return Reflect.getProperty(FlxG.keys.pressed, name));
		set('keyboardReleased', function(name:String) return Reflect.getProperty(FlxG.keys.justReleased, name));

		set('anyGamepadJustPressed', function(name:String) return FlxG.gamepads.anyJustPressed(name));
		set('anyGamepadPressed', function(name:String) FlxG.gamepads.anyPressed(name));
		set('anyGamepadReleased', function(name:String) return FlxG.gamepads.anyJustReleased(name));

		set('gamepadAnalogX', function(id:Int, ?leftStick:Bool = true)
		{
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return 0.0;

			return controller.getXAxis(leftStick ? LEFT_ANALOG_STICK : RIGHT_ANALOG_STICK);
		});
		set('gamepadAnalogY', function(id:Int, ?leftStick:Bool = true)
		{
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return 0.0;

			return controller.getYAxis(leftStick ? LEFT_ANALOG_STICK : RIGHT_ANALOG_STICK);
		});
		set('gamepadJustPressed', function(id:Int, name:String)
		{
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return false;

			return Reflect.getProperty(controller.justPressed, name) == true;
		});
		set('gamepadPressed', function(id:Int, name:String)
		{
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return false;

			return Reflect.getProperty(controller.pressed, name) == true;
		});
		set('gamepadReleased', function(id:Int, name:String)
		{
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return false;

			return Reflect.getProperty(controller.justReleased, name) == true;
		});

		set('keyJustPressed', function(name:String = '') {
			name = name.toLowerCase();
			switch(name) {
				case 'left': return Controls.instance.NOTE_LEFT_P;
				case 'down': return Controls.instance.NOTE_DOWN_P;
				case 'up': return Controls.instance.NOTE_UP_P;
				case 'right': return Controls.instance.NOTE_RIGHT_P;
				default: return Controls.instance.justPressed(name);
			}
			return false;
		});
		set('keyPressed', function(name:String = '') {
			name = name.toLowerCase();
			switch(name) {
				case 'left': return Controls.instance.NOTE_LEFT;
				case 'down': return Controls.instance.NOTE_DOWN;
				case 'up': return Controls.instance.NOTE_UP;
				case 'right': return Controls.instance.NOTE_RIGHT;
				default: return Controls.instance.pressed(name);
			}
			return false;
		});
		set('keyReleased', function(name:String = '') {
			name = name.toLowerCase();
			switch(name) {
				case 'left': return Controls.instance.NOTE_LEFT_R;
				case 'down': return Controls.instance.NOTE_DOWN_R;
				case 'up': return Controls.instance.NOTE_UP_R;
				case 'right': return Controls.instance.NOTE_RIGHT_R;
				default: return Controls.instance.justReleased(name);
			}
			return false;
		});

		set('addHaxeLibrary', function(libName:String, ?libPackage:String = '') {
			try {
				var str:String = '';
				if(libPackage.length > 0)
					str = libPackage + '.';

				set(libName, Type.resolveClass(str + libName));
			}
			catch (e:Dynamic) {
				var msg:String = e.message.substr(0, e.message.indexOf('\n'));
				if(ScriptSubState.instance != null) ScriptSubState.instance.addTextToDebug('$origin - $msg', FlxColor.RED);
				else trace('$origin - $msg');
			}
		});
		set('parentLua', null);
		set('this', this);
		set('game', ScriptSubState.instance);

		set('buildTarget', LuaUtils.getBuildTarget());

		set('Function_Stop', LuaUtils.Function_Stop);
		set('Function_Continue', LuaUtils.Function_Continue);
		set('Function_StopLua', LuaUtils.Function_StopLua); //doesnt do much cuz HScript has a lower priority than Lua
		set('Function_StopHScript', LuaUtils.Function_StopHScript);
		set('Function_StopAll', LuaUtils.Function_StopAll);
		
		set('add', ScriptSubState.instance.add);
		set('insert', ScriptSubState.instance.insert);
		set('remove', ScriptSubState.instance.remove);
		set('close', ScriptSubState.instance.close);

		if (ScriptSubState.instance == ScriptSubState.instance)
		{
			setSpecialObject(ScriptSubState.instance, false, ScriptSubState.instance.instancesExclude);
		}

		if(varsToBring != null) {
			for (key in Reflect.fields(varsToBring)) {
				key = key.trim();
				var value = Reflect.field(varsToBring, key);
				//trace('Key $key: $value');
				set(key, Reflect.field(varsToBring, key));
			}
			varsToBring = null;
		}
	}

	public function executeCode(?funcToRun:String = null, ?funcArgs:Array<Dynamic> = null):Tea {
		if (funcToRun == null) return null;

		if(!exists(funcToRun)) {
			ScriptSubState.instance.addTextToDebug(origin + ' - No HScript function named: $funcToRun', FlxColor.RED);
			return null;
		}

		final callValue = call(funcToRun, funcArgs);
		if (!callValue.succeeded)
		{
			final e = callValue.exceptions[0];
			if (e != null) {
				var msg:String = e.details();
				ScriptSubState.instance.addTextToDebug('$origin - $msg', FlxColor.RED);
			}
			return null;
		}
		return callValue;
	}

	public function executeFunction(funcToRun:String = null, funcArgs:Array<Dynamic>):Tea {
		if (funcToRun == null) return null;
		return call(funcToRun, funcArgs);
	}

	override public function destroy()
	{
		origin = null;

		super.destroy();
	}
}

class CustomFlxColor {
	public static var TRANSPARENT(default, null):Int = FlxColor.TRANSPARENT;
	public static var BLACK(default, null):Int = FlxColor.BLACK;
	public static var WHITE(default, null):Int = FlxColor.WHITE;
	public static var GRAY(default, null):Int = FlxColor.GRAY;

	public static var GREEN(default, null):Int = FlxColor.GREEN;
	public static var LIME(default, null):Int = FlxColor.LIME;
	public static var YELLOW(default, null):Int = FlxColor.YELLOW;
	public static var ORANGE(default, null):Int = FlxColor.ORANGE;
	public static var RED(default, null):Int = FlxColor.RED;
	public static var PURPLE(default, null):Int = FlxColor.PURPLE;
	public static var BLUE(default, null):Int = FlxColor.BLUE;
	public static var BROWN(default, null):Int = FlxColor.BROWN;
	public static var PINK(default, null):Int = FlxColor.PINK;
	public static var MAGENTA(default, null):Int = FlxColor.MAGENTA;
	public static var CYAN(default, null):Int = FlxColor.CYAN;

	public static function fromInt(Value:Int):Int 
	{
		return cast FlxColor.fromInt(Value);
	}

	public static function fromRGB(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):Int
	{
		return cast FlxColor.fromRGB(Red, Green, Blue, Alpha);
	}
	public static function fromRGBFloat(Red:Float, Green:Float, Blue:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromRGBFloat(Red, Green, Blue, Alpha);
	}

	public static inline function fromCMYK(Cyan:Float, Magenta:Float, Yellow:Float, Black:Float, Alpha:Float = 1):Int
	{
		return cast FlxColor.fromCMYK(Cyan, Magenta, Yellow, Black, Alpha);
	}

	public static function fromHSB(Hue:Float, Sat:Float, Brt:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromHSB(Hue, Sat, Brt, Alpha);
	}
	public static function fromHSL(Hue:Float, Sat:Float, Light:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromHSL(Hue, Sat, Light, Alpha);
	}
	public static function fromString(str:String):Int
	{
		return cast FlxColor.fromString(str);
	}
}
#end