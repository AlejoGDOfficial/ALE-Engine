import haxe.ds.StringMap;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import flixel.math.FlxRect;

import visuals.objects.Alphabet;
import visuals.objects.AttachedSprite;

import core.gameplay.stages.WeekData;

import tjson.TJSON as Json;

import utils.mods.Mods;

import utils.helpers.Highscore;

import haxe.ds.StringMap;

var bg:FlxSprite;
var difficultyTextBG:FlxSprite;
var difficultyText:FlxText;

var canSelect:Bool = false;

var songs:Array<StringMap> = [];
var difficulties:Array = [];

var songsSelInt:Int = existsGlobalVar('freeplayStateSongsSelInt') ? getGlobalVar('freeplayStateSongsSelInt') : 0;
var difficultiesSelInt:Int = existsGlobalVar('freeplayStateDifficultiesSelInt') ? getGlobalVar('freeplayStateDifficultiesSelInt') : 0;

function onCreate()
{
    DiscordClient.changePresence('In the Menus...', 'Freeplay Menu');

    WeekData.reloadWeekFiles(false);

    Paths.sound('scrollMenu');

    bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    bg.scale.set(1.25, 1.25);
    bg.screenCenter('x');
    add(bg);
    bg.antialiasing = ClientPrefs.data.antialiasing;
    bg.alpha = 0;
		
    var foldersToCheck = [];

    if (FileSystem.exists(Paths.getSharedPath('weeks')) && FileSystem.isDirectory(Paths.getSharedPath('weeks'))) foldersToCheck.push(Paths.getSharedPath('weeks'));
    if (FileSystem.exists(Paths.mods(Mods.currentModDirectory + '/weeks')) && FileSystem.isDirectory(Paths.mods(Mods.currentModDirectory + '/weeks'))) foldersToCheck.push(Paths.mods(Mods.currentModDirectory + '/weeks'));

    var weeks = [];

    for (folder in foldersToCheck)
    {
        var files = FileSystem.readDirectory(folder).filter(function(file) return StringTools.endsWith(file, '.json'));

        for (file in files)
        {
            var replaced = false;

            for (i in 0...weeks.length)
            {
                if (weeks[i][1] != null && weeks[i][1] == file) 
                {
                    weeks[i][0] = folder;

                    replaced = true;
                }
            }

            if (!replaced) weeks.push([folder, file]);
        }
    }

    for (week in weeks)
    {
        var jsonData = Json.parse(File.getContent(week[0] + '/' + week[1]));

        var jsonDiff:Array = Reflect.hasField(jsonData, 'difficulties') && jsonData.difficulties != '' ? jsonData.difficulties.split(' ').join('').split(',') : ['Easy', 'Normal', 'Hard'];
        
        for (song in jsonData.songs)
        {
            if (!week.hideFreeplay)
            {
                var songData:StringMap = new StringMap();
            
                var text:Alphabet = new Alphabet(100 + 30 * (songs.length - songsSelInt), 318 + 120 * (songs.length - songsSelInt), song[0], true);
                text.snapToPosition();
                add(text);
                text.alpha = 0.5;
                text.scaleX = text.scaleY = 1.1;
                text.antialiasing = ClientPrefs.data.antialiasing;
            
                var iconPath = 'icons/' + song[1];
                if (!Paths.fileExists('images/' + iconPath + '.png', 'IMAGE')) iconPath = 'icons/icon-' + song[1];
                if (!Paths.fileExists('images/' + iconPath + '.png', 'IMAGE')) iconPath = 'icons/icon-face';
                if (!Paths.fileExists('images/' + iconPath + '.png', 'IMAGE')) iconPath = 'icons/face';
            
                var iconSprite:AttachedSprite = new AttachedSprite(iconPath, null, null, false);
                add(iconSprite);
                iconSprite.sprTracker = text;
                iconSprite.xAdd = text.width + 5;
                iconSprite.yAdd = text.height / 2 - iconSprite.height / 2;
                iconSprite.clipRect = new FlxRect(0, 0, iconSprite.width / 2, iconSprite.height);
                iconSprite.antialiasing = ClientPrefs.data.antialiasing;
            
                songData.set('text', text);
                songData.set('icon', iconSprite);
                songData.set('name', song[0]);
                songData.set('color', FlxColor.fromRGB(song[2][0], song[2][1], song[2][2]));
                songData.set('difficulties', jsonDiff);
            
                songs.push(songData);
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
    tipBG.alpha = 0;
    tipBG.y = FlxG.height - tipBG.height;

    var tipText = new FlxText(0, 10, 1240, 'Press CONTROL to Open the Gameplay Changers Menu');
    tipText.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, 'right');
    add(tipText);
    tipText.antialiasing = ClientPrefs.data.antialiasing;
    tipText.alpha = 0;
    tipText.y = tipBG.y + tipBG.height / 2 - tipText.height / 2;

    new FlxTimer().start(1, function(tmr:FlxTimer)
    {
        changeSongShit();
        changeDifficultyShit();

        canSelect = true;
        
        FlxTween.tween(tipBG, {alpha: 0.5}, 30 / Conductor.bpm, {ease: FlxEase.cubeOut});
        FlxTween.tween(tipText, {alpha: 1}, 30 / Conductor.bpm, {ease: FlxEase.cubeOut});
    });
}

function onBeatHit()
{
    for (song in songs)
    {
        if (songs.indexOf(song) == songsSelInt && canSelect)
        {
            song.get('icon').scale.x = 1.15;
            song.get('icon').scale.y = 1.15;
        }
    }
}

function onUpdate(elapsed:Float)
{
    for (song in songs)
    {
        if (song.get('icon').scale.x != 1 || song.get('icon').scale.y != 1 )
        {
            song.get('icon').scale.x = fpsLerp(song.get('icon').scale.x, 1, 0.33); 
            song.get('icon').scale.y = fpsLerp(song.get('icon').scale.y, 1, 0.33); 
        }
    }

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

        if (controls.ACCEPT)
        {
            setGlobalVar('freeplayStateSongsSelInt', songsSelInt);
            setGlobalVar('freeplayStateDifficultiesSelInt', difficultiesSelInt);

            for (song in songs)
            {
                if (songs.indexOf(song) == songsSelInt)
                {
                    if (ClientPrefs.data.flashing)
                    {
                        FlxFlicker.flicker(song.get('text'), 0, 0.05);
                        FlxFlicker.flicker(song.get('icon'), 0, 0.05);
                    }

                    FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
                    
                    new FlxTimer().start(1, function(tmr:FlxTimer)
                    {
                        loadSong(song.get('name'), difficultiesSelInt);
                    });
                } else {
                    FlxTween.tween(song.get('text'), {alpha: 0}, 0.5, {ease: FlxEase.cubeIn});
                    FlxTween.tween(song.get('icon'), {alpha: 0}, 0.5, {ease: FlxEase.cubeIn});
                }
            }

            canSelect = false;
        }

        if (controls.BACK)
        {
            setGlobalVar('freeplayStateSongsSelInt', songsSelInt);
            setGlobalVar('freeplayStateDifficultiesSelInt', difficultiesSelInt);

            for (song in songs) FlxTween.cancelTweensOf(song.get('text'));

            MusicBeatState.switchState(new ScriptState('mainMenuState'));

            FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);

            canSelect = false;
        }

        if (!FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.CONTROL) openSubState('gameplay.states.substates.GameplayChangersSubstate', []);
    }
}

function changeSongShit()
{
    FlxTween.cancelTweensOf(bg);
    FlxTween.tween(bg, {y: FlxG.height / 2 - bg.height / 2 - (25 * (songsSelInt)) / songs.length}, 60 / Conductor.bpm, {ease: FlxEase.cubeOut});

    for (song in songs)
    {
        if (songs.indexOf(song) == songsSelInt)
        {
            if (song.get('text').alpha != 1) song.get('text').alpha = 1;

            FlxTween.color(bg, 60 / Conductor.bpm, bg.color, song.get('color'), {ease: FlxEase.cubeOut});
        } else {
            if (song.get('text').alpha != 0.5) song.get('text').alpha = 0.5;
        }

        FlxTween.cancelTweensOf(song.get('text'));
        FlxTween.tween(song.get('text'), {x: 100 + 30 * (songs.indexOf(song) - songsSelInt), y: 318 + 120 * (songs.indexOf(song) - songsSelInt)}, 30 / Conductor.bpm, {ease: FlxEase.cubeOut});
    }

    FlxG.sound.play(Paths.sound('scrollMenu'));
}

function changeDifficultyShit()
{
    if (difficulties.length != songs[songsSelInt].get('difficulties').length) difficultiesSelInt = 0;
    difficulties = songs[songsSelInt].get('difficulties');
}