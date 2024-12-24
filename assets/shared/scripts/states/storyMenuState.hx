import haxe.ds.StringMap;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import core.config.DiscordClient;
import flixel.group.FlxTypedGroup;
import visuals.objects.MenuCharacter;
import tjson.TJSON as Json;

var weeks:Array<StringMap<Dynamic>> = [];
var difficulties:Array<String> = [];
var globalWeekID:Int;

var weekSelInt:Int = existsGlobalVar('storyMenuStateSongsSelInt') ? getGlobalVar('storyMenuStateSongsSelInt') : 0;
var difficultiesSelInt:Int = existsGlobalVar('storyMenuStateDifficultiesSelInt') ? getGlobalVar('storyMenuStateDifficultiesSelInt') : 0;

function onCreate()
{
    DiscordClient.changePresence('In the Menus...', 'Story Menu');

    if (FileSystem.exists(Paths.modFolders('weeks'))) parseJsons(createPath(FileSystem.readDirectory(Paths.modFolders('weeks')).filter(function(file) return StringTools.endsWith(file, '.json')), true));
    if (FileSystem.exists(Paths.getSharedPath('weeks'))) parseJsons(createPath(FileSystem.readDirectory(Paths.getSharedPath('weeks')).filter(function(file) return StringTools.endsWith(file, '.json')), false));

    showShit();
}

function createPath(objects:Array<String>, isModFolder:Bool)
{
    var result:Array = [[], []];
    for (i in objects)
    {
        result[0].push(isModFolder ? Paths.modFolders('weeks/' + i) : Paths.getSharedPath('weeks/' + i));
        result[1].push(i);
    }
    return result;
}

function parseJsons(items:Array)
{
    var jsonSongs:Array = [];
    var jsonDiff:Array = [];

    for (json in items[0])
    {
        if (json != null) var jsonData = Json.parse(File.getContent(json));
        
        jsonSongs = [];

        for (i in jsonData.songs) jsonSongs.push(i[0]);

        jsonDiff = Reflect.hasField(jsonData, 'difficulties') && jsonData.difficulties != '' ? jsonData.difficulties.split(' ').join('').split(',') : null;

        if (!jsonData.hideStoryMode)
        {
            var week:StringMap<Dynamic> = new StringMap();
            setWeekData(week, items[1][items[0].indexOf(json)].substr(0, items[1][items[0].indexOf(json)].length - 5), jsonSongs, jsonDiff == null ? ['Easy', 'Normal', 'Hard'] : jsonDiff, jsonData.weekBackground, jsonData.storyName, jsonData.weekCharacters);
            weeks.push(week);
        }
    }
}

var weekTexts:Array<FlxSprite> = [];

var characters:FlxTypedGroup<MenuCharacter>;

var bg:FlxSprite;
var difficultyImage:FlxSprite;
var uiLeft:FlxSprite;
var uiRight:FlxSprite;
var songsText:FlxText;
var weekPhrase:FlxText;

function showShit()
{
    uiLeft = new FlxSprite(0, 480);
    uiLeft.frames = Paths.getSparrowAtlas('storyMenuState/ui');
    uiLeft.animation.addByPrefix('push', "arrow push left", 24, false);
    uiLeft.animation.addByPrefix('left', "arrow left", 24, false);
    uiLeft.animation.play('left');
    add(uiLeft);
    uiLeft.antialiasing = ClientPrefs.data.antialiasing;
    uiLeft.scrollFactor.set(0, 0);

    uiRight = new FlxSprite(0, 480);
    uiRight.frames = Paths.getSparrowAtlas('storyMenuState/ui');
    uiRight.animation.addByPrefix('push', "arrow push right", 24, false);
    uiRight.animation.addByPrefix('right', "arrow right", 24, false);
    uiRight.animation.play('right');
    add(uiRight);
    uiRight.antialiasing = ClientPrefs.data.antialiasing;
    uiRight.x = FlxG.width - uiRight.width - 5;
    uiRight.scrollFactor.set(0, 0);

    difficultyImage = new FlxSprite();
    add(difficultyImage);
    difficultyImage.antialiasing = ClientPrefs.data.antialiasing;
    difficultyImage.scrollFactor.set(0, 0);

    songsText = new FlxText(0, 480, 0, 'TRACKS');
    songsText.setFormat(Paths.font('fullPhantomMuff.ttf'), 45, FlxColor.PINK, 'center');
    add(songsText);
    songsText.scrollFactor.set(0, 0);
    songsText.x = FlxG.width / 5 - songsText.width / 2 - 50;

    for (week in weeks)
    {
        var weekData = week.get("weekData");
        var weekName:String = weekData.get("name");
        var weekSongs:Array<String> = weekData.get("songs");

        var weekText:FlxSprite = new FlxSprite(0, 480 + (week - weekSelInt) * 105).loadGraphic(Paths.image('storyMenuState/weeks/' + weekName));
        weekText.x = FlxG.width / 20 * 9.25 - weekText.width / 2;
        weekText.alpha = 0.5;
        weekText.scale.set(0.8, 0.8);
        weekText.antialiasing = ClientPrefs.data.antialiasing;
        add(weekText);
        weekTexts.push(weekText);
    }

    var phraseBG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 50, FlxColor.BLACK);
    add(phraseBG);
    phraseBG.scrollFactor.set(0, 0);

    weekPhrase = new FlxText(0, 10, 0, '');
    weekPhrase.setFormat(Paths.font('vcr.ttf'), 35);
    add(weekPhrase);
    weekPhrase.scrollFactor.set(0, 0);
    weekPhrase.x = FlxG.width - weekPhrase.width - 10;

    bg = new FlxSprite(0, 50);
    add(bg);
    bg.antialiasing = ClientPrefs.data.antialiasing;
    bg.scrollFactor.set(0, 0);

    characters = new FlxTypedGroup<MenuCharacter>();
    add(characters);

    for (i in 1...4)
    {
        var character:MenuCharacter = new MenuCharacter(FlxG.width * 0.25 * i - 150, '');
        characters.add(character);
        character.antialiasing = ClientPrefs.data.antialiasing;
        character.scrollFactor.set(0, 0);
        character.y += 65;
    }
    
    changeDifficulties(true);
    changeDifficultyShit(false);

    changeWeekShit();
}

var canSelect:Bool = true;

function onUpdate(elapsed:Float)
{
    if (canSelect)
    {
        if (weeks.length > 1)
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
        }
        
        if (controls.BACK)
        {
            setGlobalVar('storyMenuStateSongsSelInt', weekSelInt);
            setGlobalVar('storyMenuStateDifficultiesSelInt', difficultiesSelInt);

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
            setGlobalVar('storyMenuStateSongsSelInt', weekSelInt);
            setGlobalVar('storyMenuStateDifficultiesSelInt', difficultiesSelInt);
            
            for (week in weeks)
            {
                var weekData = week.get("weekData");
                var weekID:Int = weekData.get("id");
                var weekSongs:Array<String> = weekData.get("songs");
        
                if (weekID == weekSelInt)
                {
                    if (ClientPrefs.data.flashing) FlxFlicker.flicker(weekTexts[weekID], 0, 0.05);

                    FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
                    
                    new FlxTimer().start(1, function(tmr:FlxTimer)
                    {
                        loadWeek(weekSongs, difficulties, difficultiesSelInt, true);
                    });
                } else {
                    FlxTween.tween(weekTexts[weekID], {alpha: 0}, 0.5, {ease: FlxEase.cubeIn});
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
        var weekBackground:String = weekData.get("background");
        var weekText:String = weekData.get("phrase");
        var weekCharArray:Array = weekData.get("charArray");

        if (weekID == weekSelInt)
        {
            songsText.text = 'TRACKS\n' + weekSongs.join('\n');
            songsText.x = FlxG.width / 5 - songsText.width / 2 - 50;

            weekPhrase.text = weekText.toUpperCase();
            weekPhrase.x = FlxG.width - weekPhrase.width - 10;

            bg.loadGraphic(Paths.image('storyMenuState/backgrounds/' + weekBackground));

            for (i in 0...3) characters.members[i].changeCharacter(weekCharArray[i]);
        }
    }

    if (weekTexts.length != 1)
    {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
    }
}

function changeDifficultyShit(restart:Bool, ?init:Bool = false)
{
    if (restart)
    {
        difficultiesSelInt = init && existsGlobalVar('storyMenuStateDifficultiesSelInt') ? getGlobalVar('storyMenuStateDifficultiesSelInt') : 0;
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

function changeDifficulties(?init:Bool = false)
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
                changeDifficultyShit(true, init);
            }
        }
    }
}

function setWeekData(object:StringMap, name:String, songs:Array<String>, difficulties:Array<String>, weekBackground:String, phrase:String, charArray:Array)
{
    var weekData:StringMap<Dynamic> = new StringMap();
    weekData.set('id', globalWeekID);
    weekData.set('name', name);
    weekData.set('songs', songs);
    weekData.set('difficulties', difficulties);
    weekData.set('background', weekBackground);
    weekData.set('phrase', phrase);
    weekData.set('charArray', charArray);
    object.set('weekData', weekData);

    globalWeekID++;
}