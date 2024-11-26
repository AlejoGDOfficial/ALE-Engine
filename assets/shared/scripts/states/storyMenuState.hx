import haxe.ds.StringMap;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import backend.DiscordClient;
import backend.CoolUtil;

var weeks:Array<StringMap<Dynamic>> = [];
var difficulties:Array<String> = [];
var globalWeekID:Int;

/*
HOW TO ADD WEEKS:
var weekName:StringMap<Dynamic> = new StringMap();
setWeekData(weekName, 'weekName', ['Song1', 'Song2', 'Song3'], ['Easy', 'Normal', 'Hard']);
weeks.push(weekName);
*/

function onCreate()
{
    DiscordClient.changePresence('In the Menus...', 'Story Menu');

    var testWeek:StringMap<Dynamic> = new StringMap();
    setWeekData(testWeek, 'Test', ['Test'], ['Normal']);
    weeks.push(testWeek);

    showShit();
}

var weekTexts:Array<FlxText> = [];

var weekSelInt:Int = 0;
var difficultiesSelInt:Int = 0;

var bg:FlxSprite;
var difficultyImage:FlxSprite;
var uiLeft:FlxSprite;
var uiRight:FlxSprite;
var songsText:FlxText;

function showShit()
{
    uiLeft = new FlxSprite(0, 480);
    uiLeft.frames = Paths.getSparrowAtlas('storyMenuState/ui');
    uiLeft.animation.addByPrefix('push', "arrow push left", 24, false);
    uiLeft.animation.addByPrefix('left', "arrow left", 24, false);
    uiLeft.animation.play('left');
    add(uiLeft);
    uiLeft.scrollFactor.set(0, 0);

    uiRight = new FlxSprite(0, 480);
    uiRight.frames = Paths.getSparrowAtlas('storyMenuState/ui');
    uiRight.animation.addByPrefix('push', "arrow push right", 24, false);
    uiRight.animation.addByPrefix('right', "arrow right", 24, false);
    uiRight.animation.play('right');
    add(uiRight);
    uiRight.x = FlxG.width - uiRight.width - 5;
    uiRight.scrollFactor.set(0, 0);

    difficultyImage = new FlxSprite();
    add(difficultyImage);
    difficultyImage.scrollFactor.set(0, 0);

    songsText = new FlxText(0, 480, 0, getPhrase('storyMenuState', 'Tracks'));
    songsText.setFormat(Paths.font('fullPhantomMuff.ttf'), 50, FlxColor.PINK, 'center');
    add(songsText);
    songsText.scrollFactor.set(0, 0);
    songsText.x = FlxG.width / 5 - songsText.width / 2 - 50;

    for (week in weeks)
    {
        var weekData = week.get("weekData");
        var weekName:String = weekData.get("name");
        var weekSongs:Array<String> = weekData.get("songs");

        var destinationY:Float = 480 + (week - weekSelInt) * 105;   

        var weekText:FlxText = new FlxText(0, destinationY, 0, weekName);
        weekText.setFormat(Paths.font('emptyPhantomMuff.ttf'), 75, FlxColor.WHITE, 'center');
        add(weekText);
        weekText.x = FlxG.width / 20 * 9 - weekText.width / 2;
        weekText.alpha = 0.5;
        weekTexts.push(weekText);
    }

    bg = new FlxSprite(0, 50).loadGraphic(Paths.image('storyMenuState/backgrounds/stage'));
    add(bg);
    bg.scrollFactor.set(0, 0);

    changeDifficulties();
    changeDifficultyShit(false);
    changeWeekShit();
}

var canSelect:Bool = true;

function onUpdate(elapsed:Float)
{
    if (canSelect)
    {
        if (controls.UI_LEFT_P)
        {
            if (difficultiesSelInt > 0)
            {
                difficultiesSelInt -= 1;
            } else if (difficultiesSelInt == 0) {
                difficultiesSelInt = difficulties.length - 1;
            }

            changeDifficultyShit(false);

            uiLeft.animation.play('push');
            uiLeft.centerOffsets();
        } else if (controls.UI_LEFT_R) {
            uiLeft.animation.play('left');
            uiLeft.centerOffsets();
        }

        if (controls.UI_RIGHT_P) {
            if (difficultiesSelInt < (difficulties.length - 1))
            {
                difficultiesSelInt += 1;
            } else if (difficultiesSelInt == difficulties.length - 1) {
                difficultiesSelInt = 0;
            }

            changeDifficultyShit(false);

            uiRight.animation.play('push');
            uiRight.centerOffsets();
        } else if (controls.UI_RIGHT_R) {
            uiRight.animation.play('right');
            uiRight.centerOffsets();

        }

        if (controls.BACK)
        {
            MusicBeatState.switchState(new ScriptState('mainMenuState'));

            canSelect = false;
        }

        if (controls.UI_UP_P || FlxG.mouse.wheel > 0)
        {
            if (weekSelInt > 0)
            {
                weekSelInt -= 1;
            } else if (weekSelInt == 0) {
                weekSelInt = weekTexts.length - 1;
            }
    
            changeDifficulties();
            changeDifficultyShit(false);
            changeWeekShit();
        } else if (controls.UI_DOWN_P || FlxG.mouse.wheel < 0) {
            if (weekSelInt < (weekTexts.length - 1))
            {
                weekSelInt += 1;
            } else if (weekSelInt == weekTexts.length - 1) {
                weekSelInt = 0;
            }
    
            changeDifficulties();
            changeDifficultyShit(false);
            changeWeekShit();
        }

        if (controls.ACCEPT)
        {
            for (week in weeks)
            {
                var weekData = week.get("weekData");
                var weekID:Int = weekData.get("id");
                var weekSongs:Array<String> = weekData.get("songs");
        
                if (weekID == weekSelInt)
                {
                    FlxFlicker.flicker(weekTexts[weekID], 0, 0.05);

                    FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
                    
                    new FlxTimer().start(1, function(tmr:FlxTimer)
                    {
                        loadWeek(weekSongs, difficulties, difficultiesSelInt, true);
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

    FlxG.camera.scroll.y = fpsLerp(weekSelInt * 105, FlxG.camera.scroll.y, Math.exp(-elapsed * 6));
}
    
function changeWeekShit()
{
    for (i in 0...weekTexts.length)
    {
        var destinationY:Float = 480 + i * 105;

        weekTexts[i].y = destinationY;

        if (i == weekSelInt)
        {
            weekTexts[i].alpha = 1;
        } else {
            weekTexts[i].alpha = 0.5;
        }
    }

    for (week in weeks)
    {
        var weekData = week.get("weekData");
        var weekID:Int = weekData.get("id");
        var weekSongs:Array<String> = weekData.get("songs");

        if (weekID == weekSelInt)
        {
            songsText.text = getPhrase('storyMenuState', 'Tracks') + '\n' + weekSongs.join('\n');
        }
    }

    if (weekTexts.length != 1)
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

    if (difficulties.length == 1)
    {
        uiLeft.alpha = 0;
        uiRight.alpha = 0;
    } else {
        uiLeft.alpha = 1;
        uiRight.alpha = 1;
    }

    var difficultyName:String = difficulties[difficultiesSelInt].toLowerCase();

    difficultyImage.loadGraphic(Paths.image('storyMenuState/difficulties/' + difficultyName));
    difficultyImage.x = FlxG.width / 5 * 4 - difficultyImage.width / 2;
    difficultyImage.y = uiRight.y + uiRight.height / 2 - difficultyImage.height / 2;
    
    uiLeft.x = difficultyImage.x - uiLeft.width - 5;
    
    uiRight.x = difficultyImage.x + difficultyImage.width + 5;
}

function changeDifficulties()
{
    for (week in weeks)
    {
        var weekData = week.get("weekData");
        var weekID:Int = weekData.get("id");
        var weekDifficulties:Array<String> = weekData.get("difficulties");

        if (weekID == weekSelInt)
        {
            if (difficulties != weekDifficulties)
            {
                difficulties = weekDifficulties;
                changeDifficultyShit(true);
            }
        }
    }
}

function setWeekData(object:StringMap, name:String, songs:Array<String>, difficulties:Array<String>)
{
    var weekData:StringMap<Dynamic> = new StringMap();
    weekData.set('id', globalWeekID);
    weekData.set('name', name);
    weekData.set('songs', songs);
    weekData.set("difficulties", difficulties);
    object.set("weekData", weekData);

    globalWeekID++;
}