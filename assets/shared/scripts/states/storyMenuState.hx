import haxe.ds.StringMap;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.group.FlxTypedGroup;
import visuals.objects.MenuCharacter;
import tjson.TJSON as Json;
import utils.mods.Mods;
import visuals.objects.AttachedSprite;

import utils.helpers.Difficulty;
import utils.helpers.Highscore;
import gameplay.states.game.LoadingState;
import gameplay.states.game.PlayState;
import core.gameplay.stages.WeekData;
import core.backend.Song;

var weeksSelInt:Int = existsGlobalVar('storyMenuStateweeksSelInt') ? getGlobalVar('storyMenuStateweeksSelInt') : 0;
var difficultiesSelInt:Int = existsGlobalVar('storyMenuStateDifficultiesSelInt') ? getGlobalVar('storyMenuStateDifficultiesSelInt') : 0;

var characters:FlxTypedGroup<MenuCharacter>;
var bg:FlxSprite;
var difficultyImage:FlxSprite;
var uiLeft:FlxSprite;
var uiRight:FlxSprite;
var songsText:FlxText;
var weekPhrase:FlxText;
var weekScore:FlxText;

function onCreate()
{
    DiscordClient.changePresence('In the Menus...', 'Story Menu');

    WeekData.reloadWeekFiles(true);

    PlayState.isStoryMode = true;
		
    var foldersToCheck = [];

    if (FileSystem.exists(Paths.getSharedPath('weeks')) && FileSystem.isDirectory(Paths.getSharedPath('weeks')) && !Reflect.hasField(CoolVars.gameData, 'removeDefaultWeeks') || !CoolVars.gameData.removeDefaultWeeks) foldersToCheck.push(Paths.getSharedPath('weeks'));
    if (FileSystem.exists(Paths.mods(Mods.currentModDirectory + '/weeks')) && FileSystem.isDirectory(Paths.mods(Mods.currentModDirectory + '/weeks'))) foldersToCheck.push(Paths.mods(Mods.currentModDirectory + '/weeks'));

    var allowedWeeks = [];
    var replaceWeeks = [];

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
            var weekFile:WeekData = WeekData.weeksLoaded.get(week);
    
            var songs:Array = [];
    
            for (song in weekFile.songs) songs.push(song[0]);
    
            if (!weekFile.hideStoryMode && weekFile.hiddenUntilUnlocked ? weekUnlocked(weekFile) : true) addWeek(week, songs, weekFile.weekCharacters, weekFile.weekBackground, weekFile.storyName, WeekData.weeksList.indexOf(week), weekUnlocked(weekFile));
        }
    }
    
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
    songsText.antialiasing = ClientPrefs.data.antialiasing;
    songsText.x = FlxG.width / 5 - songsText.width / 2 - 50;
    
    var phraseBG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 50, FlxColor.BLACK);
    add(phraseBG);
    phraseBG.scrollFactor.set(0, 0);

    weekPhrase = new FlxText(0, 10, 0, '');
    weekPhrase.setFormat(Paths.font('vcr.ttf'), 35);
    add(weekPhrase);
    weekPhrase.scrollFactor.set(0, 0);
    weekPhrase.antialiasing = ClientPrefs.data.antialiasing;
    weekPhrase.x = FlxG.width - weekPhrase.width - 10;

    weekScore = new FlxText(10, 10, 0, '');
    weekScore.setFormat(Paths.font('vcr.ttf'), 35);
    add(weekScore);
    weekScore.scrollFactor.set(0, 0);
    weekScore.antialiasing = ClientPrefs.data.antialiasing;

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
    
    var tipBG = new FlxSprite().makeGraphic(FlxG.width, 30, FlxColor.BLACK);
    add(tipBG);
    tipBG.alpha = 0.5;
    tipBG.y = FlxG.height - tipBG.height;

    var tipText = new FlxText(0, 10, 1240, 'Press CONTROL to Open the Gameplay Changers Menu');
    tipText.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, 'right');
    add(tipText);
    tipText.antialiasing = ClientPrefs.data.antialiasing;
    tipText.y = tipBG.y + tipBG.height / 2 - tipText.height / 2;
    
    changeDifficultyShit();
    changeWeeksShit();
}

function weekUnlocked(week:Dynamic):Bool
{
    if (week.startUnlocked) return true;

    if (Highscore.weekCompleted.exists(week.weekBefore) && Highscore.weekCompleted.get(week.weekBefore)) return true;
}

var weeks:Array<StringMap<Dynamic>> = [];
var difficulties:Array<String> = [];

function addWeek(weekName:String, songs:Array, characters:Array, stage:String, storyName:String, week:Int, unlocked:Bool)
{
    var weekData:StringMap = new StringMap();

    var image:FlxSprite = new FlxSprite(0, 480 + (weeks.length - weeksSelInt) * 105).loadGraphic(Paths.image('storyMenuState/weeks/' + weekName));
    image.scale.set(0.8, 0.8);
    image.updateHitbox();
    image.x = FlxG.width / 2 - image.width / 2 - 20;
    image.antialiasing = ClientPrefs.data.antialiasing;
    add(image);

    if (!unlocked)
    {
        var locker:AttachedSprite = new AttachedSprite();
        locker.frames = Paths.getSparrowAtlas('storyMenuState/ui');
        locker.animation.addByPrefix('lock', "lock", 1, false);
        locker.animation.play('lock');
        add(locker);
        locker.antialiasing = ClientPrefs.data.antialiasing;
        locker.sprTracker = image;
        locker.copyAlpha = false;
        locker.xAdd = image.width / 2 - locker.width / 2;
        locker.yAdd = image.height / 2 - locker.height / 2;
        locker.scrollFactor.set(0, 0);

        weekData.set('locker', locker);
    }

    weekData.set('name', weekName);
    weekData.set('image', image);
    weekData.set('songs', songs);
    weekData.set('characters', characters);
    weekData.set('stage', stage);
    weekData.set('storyName', storyName);
    weekData.set('week', week);
    weekData.set('locked', !unlocked);

    weeks.push(weekData);

    Paths.image('storyMenuState/backgrounds/' + stage);
}

function changeWeeksShit()
{
    for (week in weeks)
    {
        if (weeks.indexOf(week) == weeksSelInt)
        {
            if (week.get('image').alpha != (week.get('locked') ? 0.75 : 1)) week.get('image').alpha = week.get('locked') ? 0.75 : 1;

            songsText.text = 'TRACKS\n' + week.get('songs').join('\n');
            songsText.x = FlxG.width / 5 - songsText.width / 2 - 50;

            weekPhrase.text = week.get('storyName').toUpperCase();
            weekPhrase.x = FlxG.width - weekPhrase.width - 10;

            bg.loadGraphic(Paths.image('storyMenuState/backgrounds/' + week.get('stage')));

            for (i in 0...3) characters.members[i].changeCharacter(week.get('characters')[i]);

            if (week.exists('locker') && week.get('locker').alpha != 1) week.get('locker').alpha = 1;
        } else {
            if (week.get('image').alpha != (week.get('locked') ? 0.25 : 0.5)) week.get('image').alpha = week.get('locked') ? 0.25 : 0.5;

            if (week.exists('locker') && week.get('locker').alpha != 0.5) week.get('locker').alpha = 0.5;
        }

        FlxTween.cancelTweensOf(week.get('image'));
        FlxTween.tween(week.get('image'), {y: 490 + 105 * (weeks.indexOf(week) - weeksSelInt)}, 30 / Conductor.bpm, {ease: FlxEase.cubeOut});
    }

    FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
}

var canSelect:Bool = true;

var mouseData = {prevX: FlxG.mouse.screenX, prevY: FlxG.mouse.screenY}

var changed = {weeks: true, difficulties: true}

function onUpdate(elapsed:Float)
{
    if (canSelect)
    {
        if (FlxG.mouse.pressed && buildTarget == 'android')
        {
            var deltaX = FlxG.mouse.screenX - mouseData.prevX;
            var deltaY = FlxG.mouse.screenY - mouseData.prevY;
    
            if (Math.abs(deltaY) >= 75)
            {
                if (deltaY < 0)
                {
                    if (weeksSelInt < weeks.length - 1) weeksSelInt += 1;
                    else if (weeksSelInt == weeks.length - 1) weeksSelInt = 0;
                } else {
                    if (weeksSelInt > 0) weeksSelInt -= 1;
                    else if (weeksSelInt == 0) weeksSelInt = weeks.length - 1;
                }

                mouseData.prevY = FlxG.mouse.screenY;

                changed.weeks = true;
    
                changeWeeksShit();
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

        if (weeks.length > 1)
        {
            if (controls.UI_UP_P || controls.UI_DOWN_P || FlxG.mouse.wheel != 0)
            {
                if (controls.UI_UP_P || FlxG.mouse.wheel > 0)
                {
                    if (weeksSelInt > 0)
                    {
                        weeksSelInt -= 1;
                    } else if (weeksSelInt == 0) {
                        weeksSelInt = weeks.length - 1;
                    }
            
                } else if (controls.UI_DOWN_P || FlxG.mouse.wheel < 0) {
                    if (weeksSelInt < (weeks.length - 1))
                    {
                        weeksSelInt += 1;
                    } else if (weeksSelInt == weeks.length - 1) {
                        weeksSelInt = 0;
                    }
                }

                changeWeeksShit();
                changeDifficultyShit();
            }
        }

        if (difficulties.length > 1)
        {
            if (controls.UI_LEFT_P)
            {
                if (difficultiesSelInt > 0)
                {
                    difficultiesSelInt -= 1;
                } else if (difficultiesSelInt == 0) {
                    difficultiesSelInt = difficulties.length - 1;
                }

                uiLeft.animation.play('push');
                uiLeft.centerOffsets();
            } else if (controls.UI_LEFT_R) {
                uiLeft.animation.play('left');
                uiLeft.centerOffsets();
            }
    
            if (controls.UI_RIGHT_P)
            {
                if (difficultiesSelInt < (difficulties.length - 1))
                {
                    difficultiesSelInt += 1;
                } else if (difficultiesSelInt == difficulties.length - 1) {
                    difficultiesSelInt = 0;
                }
    
                uiRight.animation.play('push');
                uiRight.centerOffsets();
            } else if (controls.UI_RIGHT_R) {
                uiRight.animation.play('right');
                uiRight.centerOffsets();
            }    

            if (controls.UI_LEFT_P || controls.UI_RIGHT_P) changeDifficultyShit();
        }
        
        if (controls.BACK)
        {
            setGlobalVar('storyMenuStateweeksSelInt', weeksSelInt);
            setGlobalVar('storyMenuStateDifficultiesSelInt', difficultiesSelInt);

            MusicBeatState.switchState(new ScriptState('mainMenuState'));

            canSelect = false;
        }

        if (controls.ACCEPT || (FlxG.mouse.justReleased && buildTarget == 'android'))
        {
            if ((FlxG.mouse.justReleased && !changed.weeks && !changed.difficulties) || controls.ACCEPT)
            {
                setGlobalVar('storyMenuStateweeksSelInt', weeksSelInt);
                setGlobalVar('storyMenuStateDifficultiesSelInt', difficultiesSelInt);
                
                for (week in weeks)
                {
                    if (weeks.indexOf(week) == weeksSelInt)
                    {
                        if (week.get('locked'))
                        {
                            FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);
                        } else {
                            if (ClientPrefs.data.flashing) FlxFlicker.flicker(week.get('image'), 0, 0.05);
        
                            FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
        
                            loadWeek(week.get('songs'), difficultiesSelInt);
                            
                            for (char in characters.members)
                            {
                                if (char.character != '' && char.hasConfirmAnimation)
                                {
                                    char.animation.play('confirm');
                                }
                            }
        
                            new FlxTimer().start(1, function(tmr:FlxTimer)
                            {
                                LoadingState.loadAndSwitchState(new PlayState(), true);
                            });
                        }
                    } else if (!weeks[weeksSelInt].get('locked')) {
                        FlxTween.tween(week.get('image'), {alpha: 0}, 0.5, {ease: FlxEase.cubeIn});
                    }
                }

                if (!weeks[weeksSelInt].get('locked')) canSelect = false;
            }

            changed.weeks = changed.difficulties = false;
        }

        if (FlxG.keys.justPressed.CONTROL && !FlxG.keys.pressed.SHIFT) openScriptSubState('gameplayOptionsSubstate');
    }
}

var changed:Bool = false;

function changeDifficultyShit()
{
    PlayState.storyWeek = weeks[weeksSelInt].get('week');
    Difficulty.loadFromWeek();
    if (difficulties.length != Difficulty.list.length) difficultiesSelInt = 0;
    changed = difficulties.length == Difficulty.list.length;
    difficulties = Difficulty.list;
    if (!changed && difficulties.contains('Hard') && difficulties.contains('Easy') && difficulties.contains('Normal')) difficultiesSelInt = 1;

    weekScore.text = 'SCORE: ' + Highscore.getWeekScore(weeks[weeksSelInt].get('name'), difficultiesSelInt);

    if (difficulties.length > 1) uiLeft.alpha = uiRight.alpha = 1;
    else uiLeft.alpha = uiRight.alpha = 0;

    difficultyImage.loadGraphic(Paths.image('storyMenuState/difficulties/' + difficulties[difficultiesSelInt].toLowerCase()));
    difficultyImage.x = FlxG.width / 5 * 4 - difficultyImage.width / 2;
    difficultyImage.y = uiRight.y + uiRight.height / 2 - difficultyImage.height / 2;
    
    uiLeft.x = difficultyImage.x - uiLeft.width - 5;
    
    uiRight.x = difficultyImage.x + difficultyImage.width + 5;
}