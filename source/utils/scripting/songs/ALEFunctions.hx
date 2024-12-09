package utils.scripting.songs;

import core.backend.Song;

import openfl.Lib;

import cpp.*;

class ALEFunctions
{
	//ALE Shit INIT

	static function windowTweenUpdateX(value:Float)
	{
		Lib.application.window.x = Math.floor(value);
	}
	
	static function windowTweenUpdateY(value:Float)
	{
		Lib.application.window.y = Math.floor(value);
	}
	
	static function windowTweenUpdateWidth(value:Float)
	{
		Lib.application.window.width = Math.floor(value);
	}
	
	static function windowTweenUpdateHeight(value:Float)
	{
		Lib.application.window.height = Math.floor(value);
	}
	
	static function windowTweenUpdateAlpha(value:Float)
	{
		WindowsCPP.setWindowAlpha(value);
	}

	//ALE Shit END

	public static function implement(funk:FunkinLua)
    {
		var lua:State = funk.lua;
        
		Lua_helper.add_callback(lua, "switchToScriptState", function(name:String, ?doTransition:Bool = false)
		{
			ScriptState.instance.switchToScriptState(name, doTransition);
		});
		Lua_helper.add_callback(lua, "doWindowTweenX", function(pos:Int, time:Float, theEase:Dynamic)
		{
			FlxTween.num(Lib.application.window.x, pos, time, {ease: LuaUtils.getTweenEaseByString(theEase)}, windowTweenUpdateX);
		});
		Lua_helper.add_callback(lua, "doWindowTweenY", function(pos:Int, time:Float, theEase:Dynamic)
		{
			FlxTween.num(Lib.application.window.y, pos, time, {ease: LuaUtils.getTweenEaseByString(theEase)}, windowTweenUpdateY);
		});
		Lua_helper.add_callback(lua, "doWindowTweenWidth", function(pos:Int, time:Float, theEase:Dynamic)
		{
			FlxTween.num(Lib.application.window.width, pos, time, {ease: LuaUtils.getTweenEaseByString(theEase)}, windowTweenUpdateWidth);
		});
		Lua_helper.add_callback(lua, "doWindowTweenHeight", function(pos:Int, time:Float, theEase:Dynamic)
		{
			FlxTween.num(Lib.application.window.height, pos, time, {ease: LuaUtils.getTweenEaseByString(theEase)}, windowTweenUpdateHeight);
		});
		Lua_helper.add_callback(lua, "setWindowX", function(pos:Int)
		{
			Lib.application.window.x = pos;
		});
		Lua_helper.add_callback(lua, "setWindowY", function(pos:Int)
		{
			Lib.application.window.y = pos;
		});
		Lua_helper.add_callback(lua, "setWindowWidth", function(pos:Int)
		{
			Lib.application.window.width = pos;
		});
		Lua_helper.add_callback(lua, "setWindowHeight", function(pos:Int)
		{
			Lib.application.window.height = pos;
		});
		Lua_helper.add_callback(lua, "getWindowX", function(pos:Int)
		{
			return Lib.application.window.x;
		});
		Lua_helper.add_callback(lua, "getWindowY", function(pos:Int)
		{
			return Lib.application.window.y;
		});
		Lua_helper.add_callback(lua, "getWindowWidth", function(pos:Int)
		{
			return Lib.application.window.width;
		});
		Lua_helper.add_callback(lua, "getWindowHeight", function(pos:Int)
		{
			return Lib.application.window.height;
		});

		//Global Vars

		Lua_helper.add_callback(lua, "setGlobalVar", function(id:String, data:Dynamic)
		{
			CoolVars.globalVars.set(id, data);
		});
		Lua_helper.add_callback(lua, "getGlobalVar", function(id:String)
		{
			return CoolVars.globalVars.get(id);
		});
		Lua_helper.add_callback(lua, "existsGlobalVar", function(id:String)
		{
			return CoolVars.globalVars.exists(id);
		});
		Lua_helper.add_callback(lua, "removeGlobalVar", function(id:String)
		{
			CoolVars.globalVars.remove(id);
		});

		//CPP

		Lua_helper.add_callback(lua, 'changeTitle', function(titleText:String)
		{
			lime.app.Application.current.window.title = titleText;
			WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
		});
		
		Lua_helper.add_callback(lua, 'getDeviceRAM', function()
		{
			WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			return WindowsCPP.obtainRAM();
		});
		
		Lua_helper.add_callback(lua, 'screenCapture', function(path:String)
		{
			WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			WindowsCPP.windowsScreenShot(path);
		});
	
		Lua_helper.add_callback(lua, 'showMessageBox', function(message:String, caption:String, icon:cpp.WindowsAPI.MessageBoxIcon = MSG_WARNING)
		{
			WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			WindowsCPP.showMessageBox(caption, message, icon);
		});
		
		Lua_helper.add_callback(lua, 'setWindowAlpha', function(a:Float)
		{
			WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			WindowsCPP.setWindowAlpha(a);
		});
		Lua_helper.add_callback(lua, 'getWindowAlpha', function()
		{
			WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			return WindowsCPP.getWindowAlpha();
		});
		Lua_helper.add_callback(lua, 'doWindowTweenAlpha', function(alpha:Int, time:Float, theEase:Dynamic)
		{
			FlxTween.num(WindowsCPP.getWindowAlpha(), alpha, time, {ease: LuaUtils.getTweenEaseByString(theEase)}, windowTweenUpdateAlpha);
		});
	
		Lua_helper.add_callback(lua, 'setBorderColor', function(r:Int, g:Int, b:Int)
		{
			WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			WindowsCPP.setWindowBorderColor(r, g, b);
		});
		
		Lua_helper.add_callback(lua, 'hideTaskbar', function(hide:Bool)
		{
			WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			WindowsCPP.hideTaskbar(hide);
		});
	
		Lua_helper.add_callback(lua, 'getCursorX', function()
		{
			return WindowsCPP.getCursorPositionX();
		});
	
		Lua_helper.add_callback(lua, 'getCursorY', function()
		{
			return WindowsCPP.getCursorPositionY();
		});
	
		Lua_helper.add_callback(lua, 'clearTerminal', function()
		{
			WindowsTerminalCPP.clearTerminal();
		});
	
		Lua_helper.add_callback(lua, 'showConsole', function()
		{
			WindowsTerminalCPP.allocConsole();
		});
	
		Lua_helper.add_callback(lua, 'setConsoleTitle', function(title:String)
		{
			WindowsTerminalCPP.setConsoleTitle(title);
		});
	
		Lua_helper.add_callback(lua, 'disableCloseConsole', function()
		{
			WindowsTerminalCPP.disableCloseConsoleWindow();
		});
	
		Lua_helper.add_callback(lua, 'hideConsole', function()
		{
			WindowsTerminalCPP.hideConsoleWindow();
		});
	
		Lua_helper.add_callback(lua, 'sendNotification', function(title:String, desc:String)
		{
			var powershellCommand = "powershell -Command \"& {$ErrorActionPreference = 'Stop';"
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
				new Process(powershellCommand);
		});

		//Utils
	
		Lua_helper.add_callback(lua, 'fpsLerp', function(v1:Float, v2:Float, ratio:Float)
		{
			return CoolUtil.fpsLerp(v1, v2, ratio);
		});
	
		Lua_helper.add_callback(lua, 'getFPSRatio', function(ratio:Float)
		{
			return CoolUtil.getFPSRatio(ratio);
		});
    }
}