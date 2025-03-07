import visuals.objects.Alphabet;

import utils.helpers.Difficulty;
import game.states.ScriptState;
import utils.save.Highscore;
import core.music.Song;

import game.states.PlayState;
import game.editors.AttachedFlxText;

import flixel.util.FlxStringUtil;
import flixel.group.FlxTypedGroup;
import flixel.sound.FlxSound;

import haxe.ds.StringMap;

var NORMAL:Int = 0;
var CHARTING:Int = 1;
var DIFFICULTY:Int = 2;

var sprites:FlxTypedGroup<FlxSprite>;

var skipText:AttachedFlxText;
var curTime:Float = Math.max(0, Conductor.songPosition);

var songText:FlxText;
var blueballedText:FlxText;
var chartingText:FlxText;

var practiceText:FlxText;
var errorText:FlxText;

var pauseMusic:FlxSound;

var options:Array<Array<String>> = [
	['Resume', 'Restart Song', 'Change Difficulty', 'Options', 'Exit to Menu'],
	['Resume', 'Skip Time', 'Restart Song', 'Leave Charting Mode', 'End Song', 'Toggle Practice Mode', 'Toggle Botplay', 'Change Difficulty', 'Options', 'Exit to Menu'],
	['Back']
];

function onCreatePost()
{
	pauseMusic = new FlxSound();

	try
	{
		var pauseSong:String = null;

		var songName:String = null;

		var formattedSongName:String = (songName != null ? Paths.formatToSongPath(songName) : '');
		var formattedPauseMusic:String = Paths.formatToSongPath(ClientPrefs.data.pauseMusic);

		if (formattedSongName == 'none' || (formattedSongName != 'none' && formattedPauseMusic == 'none')) pauseSong = null;
		else pauseSong = formattedSongName != '' ? formattedSongName : formattedPauseMusic;

		if (pauseSong != null) pauseMusic.loadEmbedded(Paths.music(pauseSong), true, true);
	} catch (error:Dynamic) {}

	pauseMusic.volume = 0;
	pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

	FlxG.sound.list.add(pauseMusic);

	for (i in 0...2)
	{
		if (Difficulty.list.length < 2) options[i].remove('Change Difficulty');

		if (PlayState.instance.startingSong && i == 1)
		{
			options[i].remove('Skip Time');
			options[i].remove('End Song');
		}

		if (FlxG.sound.music == null)
		{
			options[i].remove('Restart Song');
			options[i].remove('Change Difficulty');
			options[i].remove('Exit to Menu');
			options[i].remove('Options');
			
			if (i == 1)
			{
				options[i].remove('Skip Time');
				options[i].remove('Leave Charting Mode');
				options[i].remove('End Song');
			}
		}
	}
	
	var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 2 / FlxG.camera.zoom, FlxG.width * 2 / FlxG.camera.zoom, FlxColor.BLACK);
	add(bg);
	bg.scrollFactor.set();
	bg.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	bg.x = FlxG.width / 2 - bg.width / 2;
	bg.y = FlxG.height / 2 - bg.height / 2;
	bg.alpha = 0;

	skipText = new AttachedFlxText();
	if (FlxG.sound.music != null)
		skipText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	skipText.scrollFactor.set();
	skipText.setFormat(Paths.font('vcr.ttf'), 64, null, 'right');
	skipText.updateHitbox();
	skipText.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	if (PlayState.chartingMode ? options[CHARTING].contains('Skip Time') : options[NORMAL].contains('Skip Time')) add(skipText);
	
	sprites = new FlxTypedGroup<FlxSprite>();
	add(sprites);
	sprites.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

	FlxTween.tween(bg, {alpha: 0.5}, 0.75, {ease: FlxEase.cubeOut});

	parseMenu(PlayState.chartingMode ? CHARTING : NORMAL);

	songText = createText(PlayState.SONG.song + ' - ' + Std.string(Difficulty.getString()), null);

	blueballedText = createText('Blueballed: ' + PlayState.deathCounter, null);

	chartingText = createText('Charting Mode', PlayState.chartingMode);

	practiceText = createText('Practice Mode', PlayState.instance.practiceMode);
	
	errorText = createText('Error Text', false);
}

var curHeight:Float = 10;

function createText(initialText:String, condition:Bool):FlxText
{
	var text:FlxText = new FlxText(FlxG.width, curHeight, FlxG.width - 20, initialText, 32);
	text.scrollFactor.set();
	text.setFormat(Paths.font('vcr.ttf'), 32, null, 'right');
	text.updateHitbox();
	text.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	add(text);

	if (condition == null)
	{
		text.x = FlxG.width - text.width - 10;
	} else if (condition) {
		text.x = FlxG.width - text.width / 2 - 5;
		text.alpha = 0;

		FlxTween.tween(text, {x: condition ? FlxG.width - text.width - 10 : FlxG.width - text.width / 2 - 5, alpha: condition ? 1 : 0}, 0.5, {ease: condition ? FlxEase.cubeOut : FlxEase.cubeIn});
	}

	curHeight += text.height + 10;

	return text;
}

var curMenu:Int = 0;

var selInt:Int = 0;

var canSelect:Bool = false;

function parseMenu(menu:Int)
{
	selInt = 0;

	curMenu = menu;

	sprites.clear();

	var theOptions:Array<String> = [];

	if (menu == DIFFICULTY) for (i in 0...Difficulty.list.length) theOptions.push(Difficulty.getString(i));

	for (option in options[menu]) theOptions.push(option);

	for (name in theOptions)
	{
		var text:Alphabet = new Alphabet(0, 0, name, true);
		text.scrollFactor.set();
		text.snapToPosition();
		text.alpha = 0;
		text.scaleX = text.scaleY = 1;
		text.antialiasing = ClientPrefs.data.antialiasing;
		sprites.add(text);

		if (name == 'Skip Time')
		{
			skipText.sprTracker = text;
			skipText.xAdd = text.width + 50;
			skipText.yAdd = text.height / 2 - skipText.height / 2;
		}
	}

	canSelect = false;

	new FlxTimer().start(0.25, function(tmr:FlxTimer)
	{
		canSelect = true;
	});

	changeShit();
}

function changeShit()
{
	for (text in sprites)
	{
		FlxTween.cancelTweensOf(text);

		text.alpha = sprites.members.indexOf(text) == selInt ? 1 : 0.5;

		FlxTween.tween(text, {x: 150 + 30 * (sprites.members.indexOf(text) - selInt), y: 275 + 130 * (sprites.members.indexOf(text) - selInt)}, 0.25, {ease: FlxEase.cubeOut});
	}

	FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
}

var errorTimer:FlxTimer;

var holdTime:Float = 0;

function onUpdate(elapsed:Float)
{
	if (pauseMusic.volume < 0.5) pauseMusic.volume += 0.02 * elapsed;

	if (sprites != null)
	{
		if (sprites.members.length > 1)
		{
			if (controls.UI_UP_P || controls.UI_DOWN_P || FlxG.mouse.wheel != 0)
			{
				if (controls.UI_UP_P || FlxG.mouse.wheel > 0)
				{
					if (selInt > 0) selInt--;
					else if (selInt == 0) selInt = sprites.members.length - 1;
				} else if (controls.UI_DOWN_P || FlxG.mouse.wheel < 0) {
					if (selInt < sprites.members.length - 1) selInt++;
					else if (selInt == sprites.members.length - 1) selInt = 0;
				}
			
				changeShit();
			}
		}
	
		if (sprites.members[selInt].text == 'Skip Time')
		{
			if (controls.UI_LEFT_P || controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
				curTime += 1000 * (controls.UI_LEFT_P ? -1 : controls.UI_RIGHT_P ? 1 : 0);
		
				holdTime = 0;
			}
		
			if (controls.UI_LEFT || controls.UI_RIGHT)
			{
				holdTime += elapsed;
		
				if (holdTime > 0.5) curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : controls.UI_RIGHT ? 1 : 0);
				
				curTime += FlxG.sound.music.length * (curTime >= FlxG.sound.music.length ? -1 : curTime < 0 ? 1 : 0);
		
				skipText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
			}
		}
	
		if (controls.ACCEPT && sprites.members[selInt].text != 'Back')
		{
			if (curMenu == DIFFICULTY && canSelect)
			{
				var difficulties:Array<String> = [];
	
				for (i in 0...Difficulty.list.length) difficulties.push(Difficulty.getString(i));
	
				try
				{
					var name:String = PlayState.SONG.song;
					var poop = Highscore.formatSong(name, selInt);
	
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = selInt;
	
					if (FlxG.sound.music != null) FlxG.sound.music.volume = 0;
	
					PlayState.changedDifficulty = true;
					PlayState.chartingMode = false;
	
					CoolVars.skipTransIn = CoolVars.skipTransOut = true;
					MusicBeatState.resetState();
	
					fixedClose();
				} catch(error:Dynamic) {
					trace('Error while Loading Chart: ' + error);
	
					var errorString:String = error.toString();
	
					if (StringTools.startsWith(errorString, '[file_contents,assets/data/')) errorString = 'Missing file: ' + errorString.substring(27, errorString.length - 1);
	
					errorText.text = 'Error while Loading Chart: ' + errorString;
					errorText.updateHitbox();
	
					FlxG.sound.play(Paths.sound('cancelMenu'));
	
					if (errorTimer == null) errorTimer = new FlxTimer();
					else errorTimer.cancel();
	
					FlxTween.cancelTweensOf(errorText);
					FlxTween.tween(errorText, {x: FlxG.width - errorText.width - 10, alpha: 1}, 0.5, {ease: FlxEase.cubeOut});
	
					errorTimer.start(5, function(tmr:FlxTimer)
					{
						FlxTween.cancelTweensOf(errorText);
						FlxTween.tween(errorText, {x: FlxG.width - errorText.width / 2 - 5, alpha: 0}, 0.5, {ease: FlxEase.cubeIn});
					});
				}
			}
		}
	}
}

function onUpdatePost()
{
	if (controls.ACCEPT)
	{
		switch (sprites.members[selInt].text)
		{
			case 'Resume':
				fixedClose();
			case 'Skip Time':
				if (curTime < Conductor.songPosition)
				{
					PlayState.startOnTime = curTime;
					
					PlayState.restartSong(true);
				} else {
					if (curTime != Conductor.songPosition)
					{
						PlayState.instance.clearNotesBefore(curTime);
						PlayState.instance.setSongTime(curTime);
					}
				}

				fixedClose();
			case 'Restart Song':
				PlayState.restartSong(true);
				
				fixedClose();
			case "Leave Charting Mode":
				PlayState.restartSong(true);
				PlayState.chartingMode = false;
				
				fixedClose();
			case 'Toggle Practice Mode':
				PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
				PlayState.changedDifficulty = true;

				FlxTween.cancelTweensOf(practiceText);
				FlxTween.tween(practiceText, {x: PlayState.instance.practiceMode ? FlxG.width - practiceText.width - 10 : FlxG.width - practiceText.width / 2 - 5, alpha: PlayState.instance.practiceMode ? 1 : 0}, 0.5, {ease: PlayState.instance.practiceMode ? FlxEase.cubeOut : FlxEase.cubeIn});
			case 'Toggle Botplay':
				PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;

				PlayState.changedDifficulty = true;

				PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
				PlayState.instance.botplayTxt.alpha = 1;

				PlayState.instance.botplaySine = 0;
			case 'End Song':
				PlayState.instance.notes.clear();
				PlayState.instance.unspawnNotes = [];
				PlayState.instance.finishSong(true);
				
				fixedClose();
			case 'Change Difficulty':
				parseMenu(DIFFICULTY);
			case 'Options':
				PlayState.instance.paused = true;
				PlayState.instance.vocals.volume = 0;
				PlayState.onOptionsState = true;

				FlxG.state.allowUpdating = false;
				
				MusicBeatState.switchState(new ScriptState(CoolVars.scriptOptionsState));

				if (ClientPrefs.data.pauseMusic != 'None')
				{
					FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), pauseMusic.volume);

					FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);

					FlxG.sound.music.time = pauseMusic.time;
				}
				
				fixedClose();
			case 'Exit to Menu':
				PlayState.deathCounter = 0;
				PlayState.seenCutscene = false;
				PlayState.changedDifficulty = false;
				PlayState.chartingMode = false;

				FlxG.state.allowUpdating = false;

				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				
				FlxG.camera.followLerp = 0;

				MusicBeatState.switchState(new ScriptState(PlayState.isStoryMode ? CoolVars.scriptFromPlayStateIfStoryMode : CoolVars.scriptFromPlayStateIfFreeplay));
				
				fixedClose();
			case 'Back':
				if (curMenu == DIFFICULTY) parseMenu(PlayState.chartingMode ? CHARTING : NORMAL);
		}
	}
}

function fixedClose()
{
	FlxTween.cancelTweensOf(practiceText);
	FlxTween.cancelTweensOf(chartingText);
	FlxTween.cancelTweensOf(errorText);

	if (errorTimer != null) errorTimer.cancel();

	close();
}

function onDestroy() pauseMusic.destroy();