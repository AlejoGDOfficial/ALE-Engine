import haxe.ds.StringMap;

import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import flixel.math.FlxRect;

import utils.helpers.Difficulty;

import utils.save.Highscore;
import utils.save.WeekData;

import game.states.LoadingState;
import game.states.PlayState;

import core.music.Song;

import visuals.objects.Alphabet;
import visuals.objects.AttachedSprite;

import core.backend.Mods;

import haxe.ds.StringMap;

import flixel.ui.FlxButton;

import game.editors.ChartingState;

var bg:FlxSprite;
var difficultyTextBG:FlxSprite;
var difficultyText:FlxText;

var canSelect:Bool = true;

var songs:Array<StringMap> = [];
var difficulties:Array = [];

var songsSelInt:Int = existsGlobalVar('chartEditorListSongsSelInt') ? getGlobalVar('chartEditorListSongsSelInt') : 0;
var difficultiesSelInt:Int = existsGlobalVar('chartEditorListDifficultiesSelInt') ? getGlobalVar('chartEditorListDifficultiesSelInt') : 0;

function onCreate()
{
    DiscordClient.changePresence('In the Menus...', 'Freeplay Menu');

    PlayState.isStoryMode = false;
    WeekData.reloadWeekFiles(false);

    Paths.sound('scrollMenu');

    bg = new FlxBackdrop().loadGraphic(Paths.image('editors/listNote'));
    add(bg);
    bg.scale.set(0.75, 0.75);
    bg.updateHitbox();

    var blackBG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    add(blackBG);
    blackBG.alpha = 0.85;
    
    addSong('< Add Song >', 'face', FlxColor.WHITE, -1);
		
    var foldersToCheck = [];

    if (FileSystem.exists(Paths.getSharedPath('weeks')) && FileSystem.isDirectory(Paths.getSharedPath('weeks')) && !Reflect.hasField(CoolVars.gameData, 'removeDefaultWeeks') || !CoolVars.gameData.removeDefaultWeeks) foldersToCheck.push(Paths.getSharedPath('weeks'));
    if (FileSystem.exists(Paths.mods(Mods.currentModDirectory + '/weeks')) && FileSystem.isDirectory(Paths.mods(Mods.currentModDirectory + '/weeks'))) foldersToCheck.push(Paths.mods(Mods.currentModDirectory + '/weeks'));

    var allowedWeeks = [];

    for (folder in foldersToCheck)
    {
        var files = FileSystem.readDirectory(folder).filter(function(file) return StringTools.endsWith(file, '.json'));

        for (file in files)
        {
            var replaced = false;

            for (i in 0...allowedWeeks.length)
            {
                if (allowedWeeks[1] != null && allowedWeeks[1] == file) 
                {
                    allowedWeeks[i][0] = folder;

                    replaced = true;
                }
            }

            if (!replaced) allowedWeeks.push(file.substr(0, file.length - 5));
        }
    }

    for (week in WeekData.weeksList)
    {
        if (allowedWeeks.contains(week))
        {
            var leWeek:WeekData = WeekData.weeksLoaded.get(week);
            var leSongs:Array<String> = [];
            var leChars:Array<String> = [];
    
            for (j in 0...leWeek.songs.length)
            {
                leSongs.push(leWeek.songs[j][0]);
                leChars.push(leWeek.songs[j][1]);
            }
    
            for (song in leWeek.songs)
            {
                var colors:Array<Int> = song[2];
    
                if (colors == null || colors.length) colors = [142, 113, 253];
    
                if (!leWeek.hideFreeplay)
                {
                    addSong(song[0], song[1], FlxColor.fromRGB(song[2][0], song[2][1], song[2][2]), WeekData.weeksList.indexOf(week));
                }
            }
        }
    }

    difficultyTextBG = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
    add(difficultyTextBG);
    difficultyTextBG.alpha = 0.5;
    difficultyTextBG.scrollFactor.x = difficultyTextBG.scrollFactor.y = 0;

    difficultyText = new FlxText(0, 10, 0);
    difficultyText.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, 'center');
    add(difficultyText);
    difficultyText.antialiasing = ClientPrefs.data.antialiasing;
    difficultyText.x = FlxG.width - difficultyText.width - 10;
    difficultyText.scrollFactor.x = difficultyText.scrollFactor.y = 0;

    var tipBG = new FlxSprite().makeGraphic(FlxG.width, 30, FlxColor.BLACK);
    add(tipBG);
    tipBG.alpha = 0.5;
    tipBG.y = FlxG.height - tipBG.height;

    var tipText = new FlxText(0, 10, 1240, 'Press CONTROL to Open the Gameplay Changers Menu');
    tipText.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, 'right');
    add(tipText);
    tipText.antialiasing = ClientPrefs.data.antialiasing;
    tipText.alpha = 1;
    tipText.y = tipBG.y + tipBG.height / 2 - tipText.height / 2;

    changeSongShit();
    changeDifficultyShit();
}

function addSong(name:String, icon:String, color:FlxColor, week:Int)
{
    var songData:StringMap = new StringMap();

    var text:Alphabet = new Alphabet(100 + 30 * (songs.length - songsSelInt), 318 + 120 * (songs.length - songsSelInt), name, true);
    text.snapToPosition();
    add(text);
    if (week == -1) text.color = 0xFF00FF00;
    text.alpha = 0.5;
    text.scaleX = text.scaleY = 1.1;
    text.antialiasing = ClientPrefs.data.antialiasing;

    var iconPath = 'icons/' + icon;
    if (!Paths.fileExists('images/' + iconPath + '.png', 'IMAGE')) iconPath = 'icons/icon-' + icon;
    if (!Paths.fileExists('images/' + iconPath + '.png', 'IMAGE')) iconPath = 'icons/icon-face';
    if (!Paths.fileExists('images/' + iconPath + '.png', 'IMAGE')) iconPath = 'icons/face';

    var iconSprite:AttachedSprite = new AttachedSprite(iconPath, null, null, false);
    add(iconSprite);
    iconSprite.sprTracker = text;
    iconSprite.xAdd = text.width + 25;
    iconSprite.yAdd = text.height / 2 - iconSprite.height / 2;
    iconSprite.clipRect = new FlxRect(0, 0, iconSprite.width / 2, iconSprite.height);
    iconSprite.antialiasing = ClientPrefs.data.antialiasing;

    songData.set('text', text);
    songData.set('icon', iconSprite);
    songData.set('name', name);
    songData.set('color', color);
    songData.set('week', week);

    songs.push(songData);
}

var mouseData = {prevX: FlxG.mouse.screenX, prevY: FlxG.mouse.screenY}

var changed = {songs: true, difficulties: true}

var changedSong:Bool = false;

function onBeatHit()
{
    if (curBeat % 2 == 0 && canSelect)
    {
        FlxTween.cancelTweensOf(bg);
        bg.angle = -90;
        FlxTween.tween(bg, {x: bg.x + bg.width / 2, y: bg.y + bg.height / 2}, 120 / Conductor.bpm, {ease: FlxEase.cubeOut});
    }
}

function onUpdate(elapsed:Float)
{
    if (canSelect)
    {
        if (difficulties.length == 1) difficultyText.text = 'PERSONAL BEST: ' + Highscore.getScore(songs[songsSelInt].get('name'), difficultiesSelInt) + ' (' + FlxMath.roundDecimal(Highscore.getRating(songs[songsSelInt].get('name'), difficultiesSelInt) * 100, 2) + '%)\n' + difficulties[difficultiesSelInt];
        else difficultyText.text = 'PERSONAL BEST: ' + Highscore.getScore(songs[songsSelInt].get('name'), difficultiesSelInt) + ' (' + FlxMath.roundDecimal(Highscore.getRating(songs[songsSelInt].get('name'), difficultiesSelInt) * 100, 2) + '%)\n' + '<' + difficulties[difficultiesSelInt] + '>';
        
        difficultyText.x = FlxG.width - difficultyText.width - 10;

        difficultyTextBG.scale.x = difficultyText.width * 2 + 40;
        difficultyTextBG.scale.y = difficultyText.height * 2 + 40;
        difficultyTextBG.x = FlxG.width - difficultyTextBG.width;

        if (songs.length > 1)
        {
            if (controls.UI_UP_P || controls.UI_DOWN_P || FlxG.mouse.wheel != 0)
            {
                if (controls.UI_UP_P || FlxG.mouse.wheel > 0)
                {
                    if (songsSelInt > 0)
                    {
                        songsSelInt -= 1;
                    } else if (songsSelInt == 0) {
                        songsSelInt = songs.length - 1;
                    }
                } else if (controls.UI_DOWN_P || FlxG.mouse.wheel < 0) {
                    if (songsSelInt < songs.length - 1)
                    {
                        songsSelInt += 1;
                    } else if (songsSelInt == songs.length - 1) {
                        songsSelInt = 0;
                    }
                }
            
                changeSongShit();
                changeDifficultyShit();
            }
        }

        if (FlxG.mouse.pressed && buildTarget == 'android') {
            var deltaX = FlxG.mouse.screenX - mouseData.prevX;
            var deltaY = FlxG.mouse.screenY - mouseData.prevY;
    
            if (Math.abs(deltaY) >= 75)
            {
                if (deltaY < 0)
                {
                    if (songsSelInt < songs.length - 1) songsSelInt += 1;
                    else if (songsSelInt == songs.length - 1) songsSelInt = 0;
                } else {
                    if (songsSelInt > 0) songsSelInt -= 1;
                    else if (songsSelInt == 0) songsSelInt = songs.length - 1;
                }

                mouseData.prevY = FlxG.mouse.screenY;

                changed.songs = true;
    
                changeSongShit();
                changeDifficultyShit();
            }

            if (Math.abs(deltaX) >= 150)
            {
                if (deltaX > 0)
                {
                    if (difficultiesSelInt > 0) difficultiesSelInt -= 1;
                    else if (difficultiesSelInt == 0) difficultiesSelInt = difficulties.length - 1;
                } else {
                    if (difficultiesSelInt < difficulties.length - 1) difficultiesSelInt += 1;
                    else if (difficultiesSelInt == difficulties.length - 1) difficultiesSelInt = 0;
                }

                mouseData.prevX = FlxG.mouse.screenX;

                changed.difficulties = true;

                changeDifficultyShit();
            }
        } else {
            mouseData.prevX = FlxG.mouse.screenX;
            mouseData.prevY = FlxG.mouse.screenY;
        }

        if (difficulties.length > 1)
        {
            if (controls.UI_LEFT_P || controls.UI_RIGHT_P)
            {
                if (controls.UI_LEFT_P)
                {
                    if (difficultiesSelInt > 0)
                    {
                        difficultiesSelInt -= 1;
                    } else if (difficultiesSelInt == 0) {
                        difficultiesSelInt = difficulties.length - 1;
                    }
                } else if (controls.UI_RIGHT_P) {
                    if (difficultiesSelInt < difficulties.length - 1)
                    {
                        difficultiesSelInt += 1;
                    } else if (difficultiesSelInt == difficulties.length - 1) {
                        difficultiesSelInt = 0;
                    }
                }
            
                changeDifficultyShit();
            }
        }

        if (controls.ACCEPT || (FlxG.mouse.justReleased && buildTarget == 'android'))
        {
            if ((FlxG.mouse.justReleased && !changed.songs && !changed.difficulties) || controls.ACCEPT)
            {
                setGlobalVar('chartEditorListSongsSelInt', songsSelInt);
                setGlobalVar('chartEditorListDifficultiesSelInt', difficultiesSelInt);
    
                for (song in songs)
                {
                    if (songs.indexOf(song) == songsSelInt)
                    {
                        if (ClientPrefs.data.flashing)
                        {
                            FlxFlicker.flicker(song.get('text'), song.get('week') == -1 ? 1 : 0, 0.05);
                            FlxFlicker.flicker(song.get('icon'), song.get('week') == -1 ? 1 : 0, 0.05);
                        }

                        if (FlxG.sound.music != null) FlxG.sound.music.volume = 0;
    
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
                        
                        PlayState.storyWeek = WeekData.weeksList.indexOf(song.get('week'));

                        FlxTween.color(bg, 60 / Conductor.bpm, songs[songsSelInt].get('color'), FlxColor.WHITE);

                        new FlxTimer().start(1, function(tmr:FlxTimer)
                        {
                            if (song.get('week') == -1)
                            {
                                openScriptSubState('chartEditorSongSubstate');
    
                                canSelect = true;
                            } else {
                                var songLowercase:String = Paths.formatToSongPath(songs[songsSelInt].get('name').toLowerCase());
                                var songShit:String = Highscore.formatSong(songLowercase, difficultiesSelInt);
                                PlayState.SONG = Song.loadFromJson(songShit, songs[songsSelInt].get('name').toLowerCase());

                                MusicBeatState.switchState(new ChartingState());

                                PlayState.chartingMode = true;
                            }
                        });
                    } else if (songs[songsSelInt].get('week') != -1) {
                        FlxTween.tween(song.get('text'), {alpha: 0}, 0.5, {ease: FlxEase.cubeIn});
                        FlxTween.tween(song.get('icon'), {alpha: 0}, 0.5, {ease: FlxEase.cubeIn});
                    }
                }
    
                canSelect = false;
            }

            changed.songs = changed.difficulties = false;
        }

        if (controls.BACK)
        {
            setGlobalVar('chartEditorListSongsSelInt', songsSelInt);
            setGlobalVar('chartEditorListDifficultiesSelInt', difficultiesSelInt);

            for (song in songs) FlxTween.cancelTweensOf(song.get('text'));

            MusicBeatState.switchState(new ScriptState('masterEditorMenu'));

            if (changedSong)
            {
                FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
                ScriptState.instance.fixMusic();
                Conductor.bpm = CoolVars.gameData.bpm;
            }

            FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);
            
            canSelect = false;
        }

        if (!FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.CONTROL) openScriptSubState('gameplayOptionsSubstate');
    }
}

var theTimer:FlxTimer;

function changeSongShit()
{
    for (song in songs)
    {
        if (songs.indexOf(song) == songsSelInt)
        {
            if (song.get('text').alpha != 1) song.get('text').alpha = 1;
        } else {
            if (song.get('text').alpha != 0.5) song.get('text').alpha = 0.5;
        }

        FlxTween.cancelTweensOf(song.get('text'));
        FlxTween.tween(song.get('text'), {x: 100 + 30 * (songs.indexOf(song) - songsSelInt), y: 318 + 120 * (songs.indexOf(song) - songsSelInt)}, 0.3, {ease: FlxEase.cubeOut});
    }

    FlxG.sound.play(Paths.sound('scrollMenu'));

    if (theTimer != null) theTimer.cancel();

    theTimer = new FlxTimer().start(1, function(tmr:FlxTimer)
    {
        if (canSelect && songs[songsSelInt].get('week') != -1)
        {
            changedSong = true;

            PlayState.storyWeek = WeekData.weeksList.indexOf(songs[songsSelInt].get('week'));

            var songLowercase:String = Paths.formatToSongPath(songs[songsSelInt].get('name').toLowerCase());
            var songShit:String = Highscore.formatSong(songLowercase, difficultiesSelInt);
            PlayState.SONG = Song.loadFromJson(songShit, songs[songsSelInt].get('name').toLowerCase());

            FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song));

            Conductor.bpm = PlayState.SONG.bpm;

            MusicBeatState.instance.resetMusicVars();
            ScriptState.instance.fixMusic();
        }
    });
}

function changeDifficultyShit()
{
    if (songs[songsSelInt].get('week') == -1)
    {
        difficultiesSelInt = 0;
        difficulties = ['Press ACCEPT'];
    } else {
        PlayState.storyWeek = songs[songsSelInt].get('week');
        Difficulty.loadFromWeek();
        if (difficulties.length != Difficulty.list.length) difficultiesSelInt = 0;
        difficulties = Difficulty.list;
    }
}