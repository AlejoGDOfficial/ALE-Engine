import haxe.ds.StringMap;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import core.config.DiscordClient;
import flixel.math.FlxRect;
import tjson.TJSON as Json;

var bg:FlxSprite;
var weeks:Array<StringMap<Dynamic>> = [];
var difficulties:Array<String> = [];
var difficultyTextBG:FlxSprite;
var difficultyText:FlxText;
var songs:Array<StringMap<Dynamic>> = [];

var songsSelInt:Int = existsGlobalVar('freeplayStateSongsSelInt') ? getGlobalVar('freeplayStateSongsSelInt') : 0;
var difficultiesSelInt:Int = existsGlobalVar('freeplayStateDifficultiesSelInt') ? getGlobalVar('freeplayStateDifficultiesSelInt') : 0;

function onCreate()
{
    DiscordClient.changePresence('In the Menus...', 'Freeplay Menu');
		
    if (FileSystem.exists(Paths.modFolders('weeks'))) parseJsons(createPath(FileSystem.readDirectory(Paths.modFolders('weeks')).filter(function(file) return StringTools.endsWith(file, '.json')), true));
    if (FileSystem.exists(Paths.getSharedPath('weeks'))) parseJsons(createPath(FileSystem.readDirectory(Paths.getSharedPath('weeks')).filter(function(file) return StringTools.endsWith(file, '.json')), false));

    showShit();
    
    changeOtherShit();
    changeSongShit();
    
    changeDifficulties(true);
    changeDifficultyShit(false);
}

function createPath(objects:Array<String>, isModFolder:Bool)
{
    var result:Array = [];
    for (i in objects) result.push(isModFolder ? Paths.modFolders('weeks/' + i) : Paths.getSharedPath('weeks/' + i));
    return result;
}

function parseJsons(items:Array<String>)
{
    for (json in items)
    {
        if (json != null) var jsonData = Json.parse(File.getContent(json));

        var jsonSongs:Array = [];
        for (i in jsonData.songs) jsonSongs.push(i[0]);

        var jsonIcons:Array = [];
        for (i in jsonData.songs)
        {
            var name:String = i[1];
            if (!Paths.fileExists('images/icons/' + name + '.png')) name = 'icon-' + i[1];
            if (!Paths.fileExists('images/icons/' + name + '.png')) name = 'icon-face';
            if (!Paths.fileExists('images/icons/' + name + '.png')) name = 'face';

            jsonIcons.push(name);
        }

        var jsonColors:Array = [];
        for (i in jsonData.songs) jsonColors.push(FlxColor.fromRGB(i[2][0], i[2][1], i[2][2]));

        var jsonDiff:Array = Reflect.hasField(jsonData, 'difficulties') && jsonData.difficulties != '' ? jsonData.difficulties.split(' ').join('').split(',') : null;

        if (!jsonData.hideFreeplay)
        {
            var testWeek:StringMap<Dynamic> = new StringMap();
            setWeekData(testWeek, json, jsonSongs, jsonIcons, jsonColors, jsonDiff == null ? ['Easy', 'Normal', 'Hard'] : jsonDiff);
            weeks.push(testWeek);
        }
    }
}

var texts:Array<FlxText> = [];
var images:Array<FlxSprite> = [];

var texts:Array<FlxText> = [];
var images:Array<FlxSprite> = [];

var globalSongID:Int = 0; 

function showShit()
{
    bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    bg.scale.set(1.25, 1.25);
    bg.screenCenter('x');
    add(bg);

    difficultyTextBG = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
    add(difficultyTextBG);
    difficultyTextBG.alpha = 0.5;
    difficultyTextBG.scrollFactor.x = difficultyTextBG.scrollFactor.y = 0;

    difficultyText = new FlxText(0, 10, 0);
    difficultyText.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, 'center');
    add(difficultyText);
    difficultyText.x = FlxG.width - difficultyText.width - 10;
    difficultyText.scrollFactor.x = difficultyText.scrollFactor.y = 0;

    for (week in weeks)
    {
        var weekData = week.get("weekData");
        var weekName:String = weekData.get("name");
        var weekSongs:Array<String> = weekData.get("songs");
        var weekColors:Array<String> = weekData.get("colors");
        var icons:Array<String> = weekData.get("icons");

        for (i in 0...weekSongs.length)
        {
            var songData:StringMap<Dynamic> = new StringMap();
            songData.set('id', globalSongID);
            songData.set('week', weekName);
            songData.set('song', weekSongs[i]);
            songData.set('color', weekColors[i]);
            songs.push(songData);

            globalSongID++;

            var destinationX:Float = 100 - (i) * 25;
            var destinationY:Float = 318 + (i) * 105;    

            var song:String = weekSongs[i];

            var songText:Alphabet = new Alphabet(100, 318, song, true);
            songText.snapToPosition();
            add(songText);
            songText.alpha = 0.25;
            songText.scaleX = songText.scaleY = 1.1;
            songText.antialiasing = ClientPrefs.jsonDefaultData.antiAliasing;
            texts.push(songText);
        
            var songIcon:FlxSprite = new FlxSprite(songText.width + 110).loadGraphic(Paths.image('icons/' + icons[i]));
            add(songIcon);
            songIcon.y = 318 + songText.height / 2 - songIcon.height / 2;
            songIcon.clipRect = new FlxRect(0, 0, songIcon.width * 0.5, songIcon.height);
            songIcon.alpha = 0.25;
            songIcon.antialiasing = ClientPrefs.jsonDefaultData.antiAliasing;
            images.push(songIcon);
        }
    }

    bg.scrollFactor.x = bg.scrollFactor.y = 0.25 / songs.length;
}
    
var canSelect:Bool = true;

function onBeatHit()
{
    for (image in images)
    {
        if (images.indexOf(image) == songsSelInt)
        {
            image.scale.set(1.25, 1.25);
        }
    }
}

function onUpdate(elapsed:Float)
{
    for (image in images)
    {
        image.scale.set(fpsLerp(image.scale.x, 1, 0.33), fpsLerp(image.scale.y, 1, 0.33));
    }

    if (canSelect)
    {
        if (songs.length > 1)
        {
            if (controls.UI_UP_P || FlxG.mouse.wheel > 0)
            {
                if (songsSelInt > 0)
                {
                    songsSelInt -= 1;
                } else if (songsSelInt == 0) {
                    songsSelInt = texts.length - 1;
                }
        
                changeSongShit();
                changeOtherShit();
                changeDifficulties();
            } else if (controls.UI_DOWN_P || FlxG.mouse.wheel < 0) {
                if (songsSelInt < (texts.length - 1))
                {
                    songsSelInt += 1;
                } else if (songsSelInt == texts.length - 1) {
                    songsSelInt = 0;
                }
        
                changeSongShit();
                changeOtherShit();
                changeDifficulties();
            }
    
            if (controls.UI_LEFT_P)
            {
                if (difficultiesSelInt > 0)
                {
                    difficultiesSelInt -= 1;
                } else if (difficultiesSelInt == 0) {
                    difficultiesSelInt = difficulties.length - 1;
                }
        
                changeDifficultyShit(false);
            } else if (controls.UI_RIGHT_P) {
                if (difficultiesSelInt < (difficulties.length - 1))
                {
                    difficultiesSelInt += 1;
                } else if (difficultiesSelInt == difficulties.length - 1) {
                    difficultiesSelInt = 0;
                }
    
                changeDifficultyShit(false);
            }
        }

        if (controls.BACK)
        {
            setGlobalVar('freeplayStateSongsSelInt', songsSelInt);
            setGlobalVar('freeplayStateDifficultiesSelInt', difficultiesSelInt);

            MusicBeatState.switchState(new ScriptState('mainMenuState'));

            FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);

            canSelect = false;
        }

        if (controls.ACCEPT)
        {
            setGlobalVar('freeplayStateSongsSelInt', songsSelInt);
            setGlobalVar('freeplayStateDifficultiesSelInt', difficultiesSelInt);

            for (song in songs)
            {
                var id = song.get('id');
                var week = song.get('week');
                var name = song.get('song');
                var color = song.get('color');
        
                if (id == songsSelInt)
                {
                    if (ClientPrefs.jsonDefaultData.flashingLights)
                    {
                        FlxFlicker.flicker(texts[id], 0, 0.05);
                        FlxFlicker.flicker(images[id], 0, 0.05);
                    }

                    FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
                    
                    new FlxTimer().start(1, function(tmr:FlxTimer)
                    {
                        loadSong(name, difficulties[difficultiesSelInt].toLowerCase());
                    });
                } else {
                    FlxTween.tween(texts[id], {alpha: 0}, 0.5, {ease: FlxEase.cubeIn});
                    FlxTween.tween(images[id], {alpha: 0}, 0.5, {ease: FlxEase.cubeIn});
                }
            }

            canSelect = false;
        }

        if (FlxG.keys.justPressed.CONTROL)
        {
            openSubState('gameplay.states.substates.GameplayChangersSubstate', []);
        }
    }
    
    if (FlxG.sound.music != null)
        Conductor.songPosition = FlxG.sound.music.time;
}

function changeOtherShit()
{
    FlxTween.cancelTweensOf(bg);
    FlxTween.tween(bg, {y: FlxG.height / 2 - bg.height / 2 - (25 * (songsSelInt)) / texts.length}, 60 / Conductor.bpm, {ease: FlxEase.cubeOut});

    for (song in songs)
    {
        var id = song.get('id');
        var week = song.get('week');
        var name = song.get('song');
        var color = song.get('color');

        if (id == songsSelInt)
        {
            FlxTween.color(bg, 1, bg.color, color);
        }
    }
}
    
function changeSongShit()
{
    for (i in 0...texts.length)
    {
        if (i == songsSelInt) {
            texts[i].alpha = 1;
        } else {
            texts[i].alpha = 0.5;
        }

        FlxTween.cancelTweensOf(texts[i]);
        FlxTween.cancelTweensOf(images[i]);

        FlxTween.tween(texts[i], {x: 100 + (i - songsSelInt) * 25, y: 318 + (i - songsSelInt) * 120}, 45 / Conductor.bpm, {ease: FlxEase.cubeOut});
        FlxTween.tween(images[i], {x: texts[i].width + 10 + 100 + (i - songsSelInt) * 25, y: 318 + (i - songsSelInt) * 120 + texts[i].height / 2 - images[i].height / 2}, 45 / Conductor.bpm, {ease: FlxEase.cubeOut});

        if (i == songsSelInt && images[i].alpha != 1) {
            images[i].alpha = 1;
        } else {
            images[i].alpha = 0.5;
        }
    }

    if (texts.length != 1)
    {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
    }
}

function changeDifficultyShit(restart:Bool, ?init:Bool = false)
{
    if (restart)
    {
        difficultiesSelInt = init && existsGlobalVar('freeplayStateDifficultiesSelInt') ? getGlobalVar('freeplayStateDifficultiesSelInt') : 0;
    }

    var difficultyName:String = difficulties[difficultiesSelInt].charAt(0).toUpperCase() + difficulties[difficultiesSelInt].substr(1);

    if (difficulties.length == 1)
    {
        difficultyText.text = 'DIFFICULTY\n' + difficultyName;
    } else {
        difficultyText.text = 'DIFFICULTIES\n' + '<' + difficultyName + '>';
    }

    difficultyText.x = FlxG.width - difficultyText.width - 10;

    difficultyTextBG.scale.x = difficultyText.width * 2 + 40;
    difficultyTextBG.scale.y = difficultyText.height * 2 + 40;
    difficultyTextBG.x = FlxG.width - difficultyTextBG.width;
}

function changeDifficulties(?init:Bool = false)
{
    for (week in weeks)
    {
        var weekData = week.get("weekData");
        var weekName:String = weekData.get("name");
        var weekDifficulties:Array<String> = weekData.get("difficulties");

        if (weekName == getCurWeek())
        {
            if (difficulties != weekDifficulties)
            {
                difficulties = weekDifficulties;
                changeDifficultyShit(true, init);
            }
        }
    }
}

function getCurWeek()
{
    var curWeek:String;

    for (song in songs) 
    {
        var id = song.get('id');
        var week = song.get('week');
        var name = song.get('song');

        if (id == songsSelInt)
        {
            curWeek = week;
        }
    }

    return curWeek;
}

function setWeekData(object:StringMap, name:String, songs:Array<String>, icons:Array<String>, colors:Array<FlxColor>, difficulties:Array<String>)
{
    var weekData:StringMap<Dynamic> = new StringMap();
    weekData.set('name', name);
    weekData.set('songs', songs);
    weekData.set('icons', icons);
    weekData.set('colors', colors);
    weekData.set("difficulties", difficulties);
    object.set("weekData", weekData);
}