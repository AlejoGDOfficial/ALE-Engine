import haxe.ds.StringMap;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import backend.CoolUtil;
import flixel.math.FlxRect;

var bg:FlxSprite;
var weeks:Array<StringMap<Dynamic>> = [];
var difficulties:Array<String> = [];
var difficultyTextBG:FlxSprite;
var difficultyText:FlxText;
var songs:Array<StringMap<Dynamic>> = [];

function onCreate()
{
    var testWeek:StringMap<Dynamic> = new StringMap();
    setWeekData(testWeek, 'testWeek', ['Test'], ['face'], ['FF00FF'], ['Normal']);
    weeks.push(testWeek);

    showShit();
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
    add(bg);
    bg.alpha = 0;

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

            var songText:FlxText = new FlxText(destinationX, destinationY, 0, song);
            songText.setFormat(Paths.font('emptyPhantomMuff.ttf'), 100, FlxColor.WHITE, 'left');
            add(songText);
            songText.borderStyle = FlxTextBorderStyle.OUTLINE;
            songText.borderSize = 3;
            songText.borderColor = FlxColor.BLACK;
            songText.alpha = 0.25;
            texts.push(songText);
        
            var songIcon:FlxSprite = new FlxSprite().loadGraphic(Paths.image('icons/' + icons[i]));
            add(songIcon);
            songIcon.scale.x = songIcon.scale.y = 0.75;
            songIcon.clipRect = new FlxRect(0, 0, songIcon.width * 0.5, songIcon.height);
            songIcon.x = destinationX + texts[i].width;
            songIcon.y = destinationY + songText.height / 2 - songIcon.height / 2;
            images.push(songIcon);
        }
    }

    bg.scrollFactor.y = 0.25 / songs.length;
}

var canSelect:Bool = true;

function onUpdate(elapsed:Float)
{
    if (canSelect)
    {
        if (controls.BACK)
        {
            switchToScriptState('mainMenuState', true);

            FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);

            canSelect = false;
        }
    }
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