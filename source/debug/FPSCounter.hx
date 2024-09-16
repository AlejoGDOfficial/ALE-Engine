package debug;

import flixel.FlxG;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;

class FPSCounter extends TextField
{
	public var currentFPS(default, null):Int;

	public var memoryMegas(get, never):Float;

	var developerModeText:String;

	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		if (CoolVars._developerMode)
		{
			developerModeText = 'DEVELOPER MODE';
		} else {
			developerModeText = '';
		}

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Paths.font('vcr.ttf'), 14, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		times = [];
	}

	var deltaTimeout:Float = 0.0;

	var fpsMode:Int = 0;

	var canChangeFPSType:Bool = true;

	private override function __enterFrame(deltaTime:Float):Void
	{
		if (deltaTimeout > 1000) {
			deltaTimeout = 0.0;
			return;
		}

		if (FlxG.keys.justPressed.F3 && canChangeFPSType)
		{
			switch (fpsMode)
			{
				case 0:
					fpsMode = 1;
				case 1:
					fpsMode = 2;
				case 2:
					fpsMode = 0;
			}

			canChangeFPSType = false;
		
            new FlxTimer().start(0.2, function(tmr:FlxTimer)
            {
				canChangeFPSType = true;
            });
		}

		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;		
		updateText();
		deltaTimeout += deltaTime;
	}

	public dynamic function updateText():Void 
	{
		switch (fpsMode)
		{
			case 0:
				text = 'FPS: ${currentFPS}'
				+ '\n' + 
				'Memory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}'
				+ '\n\n' + developerModeText;
			case 1:
				text = 'FPS: ${currentFPS}'
				+ '\n' + 
				'Memory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}'
				+ '\n\n' +
				'Window Position: ' + openfl.Lib.application.window.x + ' - ' + openfl.Lib.application.window.y
				+ '\n' +
				'Window Resolution: ' + openfl.Lib.application.window.width + ' x ' + openfl.Lib.application.window.height
				+ '\n\n' + developerModeText;
			case 2:
				text = 'FPS: ${currentFPS}'
				+ '\n' + 
				'Memory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}'
				+ '\n\n' +
				'Window Position: ' + openfl.Lib.application.window.x + ' - ' + openfl.Lib.application.window.y
				+ '\n' +
				'Window Resolution: ' + openfl.Lib.application.window.width + ' x ' + openfl.Lib.application.window.height
				+ '\n\n' +
				'Screen Resolution: ' + openfl.system.Capabilities.screenResolutionX + ' x ' + openfl.system.Capabilities.screenResolutionY
				+ '\n' +
				'Operating System: ' + openfl.system.Capabilities.os
				+ '\n\n' + developerModeText;
		}


		if (currentFPS < FlxG.drawFramerate * 0.5)
		{
			textColor = FlxColor.RED;
		} else {
			textColor = FlxColor.WHITE;
		}
	}

	function get_memoryMegas():Float
	{
		return cast(System.totalMemory, UInt);
	}
}
