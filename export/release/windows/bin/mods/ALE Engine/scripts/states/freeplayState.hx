import haxe.ds.StringMap;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import backend.CoolUtil;
import flixel.math.FlxRect;
import objects.HealthIcon;

var bg:FlxSprite;
var weeks:Array<StringMap<Dynamic>> = [];
var difficulties:Array<String> = [];
var difficultyTextBG:FlxSprite;
var difficultyText:FlxText;
var songs:Array<StringMap<Dynamic>> = [];

/*
HOW TO ADD WEEKS:
var weekName:StringMap<Dynamic> = new StringMap();
setWeekData(weekName, weekName, ['songName0', 'songName1', 'songName2'], ['songIcon1', 'songIcon2', 'songIcon3'], ['songColor1', 'songColor2', 'songColor3'], ["difficulty1", "difficulty2", "difficulty3"]);
weeks.push(weekName);
*/

function onCreate()
{
    var testWeek:StringMap<Dynamic> = new StringMap();
    setWeekData(testWeek, 'testWeek', ['Test'], ['bf-pixel'], ['5060FF'], ['Normal']);
    weeks.push(testWeek);

    showShit();
    
    changeOtherShit();
    changeSongShit();
    
    changeDifficulties();
    changeDifficultyShit(false);
}

var texts:Array<FlxText> = [];
var images:Array<FlxSprite> = [];

var songsSelInt:Int = 0;

var texts:Array<FlxText> = [];
var images:Array<FlxSprite> = [];

var songsSelInt:Int = 0;
var difficultiesSelInt:Int = 0;

var globalSongID:Int = 0; 

function showShit()
{
    bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    bg.scale.set(1.25, 1.25);
    bg.screenCenter('x');
    //add(bg);

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

            var destinationX:Float = 100 - (i - songsSelInt) * 25;
            var destinationY:Float = 318 + (i - songsSelInt) * 105;    

            var song:String = weekSongs[i];
/*
            var songText:FlxText = new FlxText(destinationX, destinationY, 0, song);
            songText.setFormat(Paths.font('emptyPhantomMuff.ttf'), 100, FlxColor.WHITE, 'left');
            add(songText);
            songText.borderStyle = FlxTextBorderStyle.OUTLINE;
            songText.borderSize = 3;
            songText.borderColor = FlxColor.BLACK;
            songText.alpha = 0.25;
*/
            var songText:Alphabet = new Alphabet(destinationX, destinationY, song, true);
            songText.snapToPosition();
            add(songText);

            texts.push(songText);
        
            var songIcon:FlxSprite = new FlxSprite().loadGraphic(Paths.image('icons/' + icons[i]));
            add(songIcon);
            songIcon.clipRect = new FlxRect(0, 0, songIcon.width * 0.5, songIcon.height);
            songIcon.x = destinationX + texts[i].width;
            songIcon.y = destinationY + songText.height / 2 - songIcon.height / 2;
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

function checkVisibility(object:Dynamic)
{
    var isVisible:Bool = object.x + object.width > FlxG.camera.scroll.x &&
    object.x < FlxG.camera.scroll.x + FlxG.camera.width &&
    object.y + object.height > FlxG.camera.scroll.y &&
    object.y < FlxG.camera.scroll.y + FlxG.camera.height;

    return isVisible;
}

function onUpdate(elapsed:Float)
{
    for (image in images)
    {
        image.scale.set(fpsLerp(image.scale.x, 1, 0.33), fpsLerp(image.scale.y, 1, 0.33));

        if (checkVisibility(image))
        {
            image.alpha = 1;
        } else {
            image.alpha = 0;
        }
    }

    for (text in texts)
    {
        if (checkVisibility(text))
        {
            text.alpha = 1;
        } else {
            text.alpha = 0;
        }
    }

    if (canSelect)
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

        if (controls.BACK)
        {
            switchToScriptState('mainMenuState', true);

            FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);

            canSelect = false;
        }

        if (controls.ACCEPT)
        {
            for (song in songs)
            {
                var id = song.get('id');
                var week = song.get('week');
                var name = song.get('song');
                var color = song.get('color');
        
                if (id == songsSelInt)
                {
                    FlxFlicker.flicker(texts[id], 0, 0.05);
                    FlxFlicker.flicker(images[id], 0, 0.05);

                    FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
                    
                    new FlxTimer().start(1, function(tmr:FlxTimer)
                    {
                        loadSong(name, difficulties[difficultiesSelInt].toLowerCase());
                    });
                }
            }

            canSelect = false;
        }

        if (FlxG.keys.justPressed.CONTROL)
        {
            openSomeSubStates('substates.GameplayChangersSubstate');
        }
    }
    
    if (FlxG.sound.music != null)
        Conductor.songPosition = FlxG.sound.music.time;

    FlxG.camera.scroll.x = fpsLerp(FlxG.camera.scroll.x, songsSelInt * 25, 0.1);
    FlxG.camera.scroll.y = fpsLerp(FlxG.camera.scroll.y, songsSelInt * 105, 0.1);
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
            FlxTween.color(bg, 1, bg.color, CoolUtil.colorFromString(color));
        }
    }
}
    
function changeSongShit()
{
    for (i in 0...texts.length)
    {
        var destinationX:Float = 100 + i * 25;
        var destinationY:Float = 318 + i * 105;
    
        if (i == songsSelInt) {
            texts[i].alpha = 1;
        } else {
            texts[i].alpha = 0.5;
        }
        
        texts[i].x = destinationX;
        texts[i].y = destinationY;

        if (i == songsSelInt) {
            images[i].alpha = 1;
        } else {
            images[i].alpha = 0.5;
        }

        images[i].x = destinationX + texts[i].width;
        images[i].y = destinationY + texts[i].height / 2 - images[i].height / 2;
    }

    if (texts.length != 1)
    {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
    }
}

function changeDifficultyShit(restart:Bool)
{
    if (restart)
    {
        difficultiesSelInt = 0;
    }

    var difficultyName:String = difficulties[difficultiesSelInt].charAt(0).toUpperCase() + difficulties[difficultiesSelInt].substr(1);

    if (difficulties.length == 1)
    {
        difficultyText.text = getPhrase('freeplayState', 'Difficulty') + '\n' + getPhrase('difficulties', difficultyName);
    } else {
        difficultyText.text = getPhrase('freeplayState', 'Difficulty') + '\n<' + getPhrase('difficulties', difficultyName) + '>';
    }

    difficultyText.x = FlxG.width - difficultyText.width - 10;

    difficultyTextBG.scale.x = difficultyText.width * 2 + 40;
    difficultyTextBG.scale.y = difficultyText.height * 2 + 40;
    difficultyTextBG.x = FlxG.width - difficultyTextBG.width;
}

function changeDifficulties()
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
                changeDifficultyShit(true);
            }
        }
    }
}

function getCurWeek()
{
    var curWeek:String;

    for (song in songs) {
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

function setWeekData(object:StringMap, name:String, songs:Array<String>, icons:Array<String>, colors:Array<String>, difficulties:Array<String>)
{
    var weekData:StringMap<Dynamic> = new StringMap();
    weekData.set('name', name);
    weekData.set('songs', songs);
    weekData.set('icons', icons);
    weekData.set('colors', colors);
    weekData.set("difficulties", difficulties);
    object.set("weekData", weekData);
}