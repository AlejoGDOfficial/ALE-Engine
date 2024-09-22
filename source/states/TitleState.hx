package states;

import backend.WeekData;

import flixel.input.keyboard.FlxKey;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import haxe.Json;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import shaders.ColorSwap;

import states.OutdatedState;

import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.Lib;

import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

import cpp.*;

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var mustUpdate:Bool = false;

	public static var updateVersion:String = '';

	override public function create():Void
	{
		Paths.clearStoredMemory();
		ClientPrefs.loadPrefs();
		Language.reloadPhrases();

		super.create();

		/*
		if(ClientPrefs.data.checkForUpdates && !closedState) {
			trace('checking for update');
			var http = new haxe.Http("https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt");

			http.onData = function (data:String)
			{
				updateVersion = data.split('\n')[0].trim();
				var curVersion:String = MainMenuState.psychEngineVersion.trim();
				trace('version online: ' + updateVersion + ', your version: ' + curVersion);
				if(updateVersion != curVersion) {
					trace('versions arent matching!');
					mustUpdate = true;
				}
			}

			http.onError = function (error) {
				trace('error: $error');
			}

			http.request();
		}
		*/

		if(!initialized)
		{
			persistentUpdate = true;
			persistentDraw = true;
		}

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else {
			if (initialized)
				startEngineIntro();
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startEngineIntro();
				});
			}
		}
		#end
	}

	var canStartEngineIntro: Bool = false;

	var _sprite:Sprite;
	var _gfx:Graphics;

	var dtf:TextFormat;
	var _text:TextField;

	function startEngineIntro()
	{
		canStartEngineIntro = true;

		Conductor.bpm = 101;

		FlxG.sound.playMusic(Paths.sound('flixel'), 0);
		
		Paths.clearUnusedMemory();

		_sprite = new Sprite();
		FlxG.stage.addChild(_sprite);
		_gfx = _sprite.graphics;

		_sprite.scaleX = 2;
		_sprite.scaleY = 2;
		_sprite.x = (Lib.current.stage.stageWidth / 2);
		_sprite.y = (Lib.current.stage.stageHeight / 2) - 100 * FlxG.game.scaleY;

		_text = new TextField();
		_text.selectable = false;
		_text.embedFonts = true;
		dtf = new TextFormat(Paths.font('odinRounded.ttf'), 32, 0xFFFFFF);
		dtf.align = TextFormatAlign.CENTER;
		_text.defaultTextFormat = dtf;
		_text.text = "";
		FlxG.stage.addChild(_text);

		_text.width = FlxG.width;
		_text.x = 0;
		_text.y = _sprite.y + 200 * FlxG.game.scaleY;
	}

    private function drawTopFace()
    {
        _gfx.beginFill(0xFFFFFFFF);
        _gfx.moveTo(0, -25);
        _gfx.lineTo(50, 0);
        _gfx.lineTo(0, 25);
        _gfx.lineTo(-50, 0);
        _gfx.lineTo(0, -25);
        _gfx.endFill();
    }

    private function drawLeftFace()
    {
        _gfx.beginFill(0xFFDDDDDD);
        _gfx.moveTo(-50, 0);
        _gfx.lineTo(0, 25);
        _gfx.lineTo(0, 87.5);
        _gfx.lineTo(-50, 62.5);
        _gfx.lineTo(-50, 0);
        _gfx.endFill();
    }

    private function drawRightFace()
    {
        _gfx.beginFill(0xFFCCCCCC);
        _gfx.moveTo(50, 0);
        _gfx.lineTo(0, 25);
        _gfx.lineTo(0, 87.5);
        _gfx.lineTo(50, 62.5);
        _gfx.lineTo(50, 0);
        _gfx.endFill();
    }

	override function update(elapsed:Float)
	{
		if (Lib.current.stage.window.fullscreen)
		{
			Lib.current.stage.window.fullscreen = false;
		}

		if (FlxG.sound.music != null)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}

		super.update(elapsed);
	}

	public static var closedState:Bool = false;

	private var sickSteps:Int = -1;
	override public function stepHit()
	{
		if (canStartEngineIntro)
		{
			sickSteps++;
			switch (sickSteps)
			{
				case 0:
					WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
					FlxTween.num(255, 32, 30 / Conductor.bpm, {ease: FlxEase.cubeOut}, windowColorTween);

					FlxG.sound.play(Paths.sound('flixel'), 1);
					drawTopFace();
				case 1:
					drawLeftFace();
				case 2:
					drawRightFace();
				case 3:
					_text.text = "ALE Engine";
				case 4:
					_text.text = "ALE Engine\nEXPERIMENTAL\n(Pre-Release 1.0 Fork)";

					FlxTween.tween(_sprite, {alpha: 0}, 240 / Conductor.bpm);
					FlxTween.tween(_text, {alpha: 0}, 240 / Conductor.bpm);
		
					new FlxTimer().start(240 / Conductor.bpm, function(tmr:FlxTimer)
					{
						FlxG.stage.removeChild(_sprite);

						FlxG.stage.removeChild(_text);
					
						Lib.current.stage.window.resizable = true;

						if (mustUpdate)
						{
							FlxG.switchState(new OutdatedState());
						} else {
							FlxG.sound.music = null;

							new FlxTimer().start(0.2, function(tmr:FlxTimer)
							{
								WindowsCPP.setWindowLayered();
								FlxG.switchState(new ScriptState(CoolUtil.getJsonValue("scriptStates/config", "initialState")));
							});
						}
					});

					canStartEngineIntro = false;
			}
		}

		super.stepHit();
	}

	private function windowColorTween(value:Float)
	{
		WindowsCPP.setWindowBorderColor(Math.floor(value), Math.floor(value), Math.floor(value));
	}

}
