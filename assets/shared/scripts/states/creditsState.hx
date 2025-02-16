import haxe.ds.StringMap;

import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;

import visuals.objects.AttachedSprite;

import tjson.TJSON as Json;

import utils.mods.Mods;

var bg:FlxSprite;

var devLvlTxt:FlxText;
var devLvlBG:FlxSprite;

var devDescTxt:FlxText;
var devDescBG:FlxSprite;

var canSelect = true;

function onCreate()
{
    DiscordClient.changePresence('In the Menus...', 'Credits Menu');

    var filesToLoad = [];

    bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    bg.scale.set(1.25, 1.25);
    bg.screenCenter('x');
    add(bg);
    bg.antialiasing = ClientPrefs.data.antialiasing;
    bg.alpha = 0;

    if (FileSystem.exists(Paths.mods(Mods.currentModDirectory + '/credits.json'))) filesToLoad.push(Paths.mods(Mods.currentModDirectory + '/credits.json'));
    if (FileSystem.exists(Paths.getSharedPath('credits.json'))) filesToLoad.push(Paths.getSharedPath('credits.json'));

    for (file in filesToLoad)
    {
        var jsonData = Json.parse(File.getContent(file));

        for (group in jsonData.groups)
        {
            for (member in group.members)
            {
                addDeveloper(group.name, member.name, member.description, member.icon, member.color);
            }
        }
    }

    devLvlBG = new FlxSprite().makeGraphic(FlxG.width, 1, FlxColor.BLACK);
    devLvlBG.alpha = 0.5;
    devLvlBG.scrollFactor.x = devLvlBG.scrollFactor.y = 0;
    add(devLvlBG);

    devLvlTxt = new FlxText(0, 10, FlxG.width);
    devLvlTxt.setFormat(Paths.font('vcr.ttf'), 80, FlxColor.WHITE, 'center');
    devLvlTxt.antialiasing = ClientPrefs.data.antialiasing;
    devLvlTxt.scrollFactor.x = devLvlTxt.scrollFactor.y = 0;
    add(devLvlTxt);

    devDescBG = new FlxSprite().makeGraphic(FlxG.width, 1, FlxColor.BLACK);
    devDescBG.alpha = 0.5;
    devDescBG.scrollFactor.x = devDescBG.scrollFactor.y = 0;
    add(devDescBG);

    devDescTxt = new FlxText(0, 10, FlxG.width);
    devDescTxt.setFormat(Paths.font('vcr.ttf'), 40, FlxColor.WHITE, 'center');
    devDescTxt.antialiasing = ClientPrefs.data.antialiasing;
    devDescTxt.scrollFactor.x = devDescTxt.scrollFactor.y = 0;
    add(devDescTxt);

    changeShit();
}

var developers:Array<StringMap> = [];

var selInt:Int = existsGlobalVar('creditsStateSelInt') ? getGlobalVar('creditsStateSelInt') : 0;

function onUpdate()
{
    for (developer in developers)
    {
        if (developer.get('icon').scale.x != 1 || developer.get('icon').scale.y != 1 )
        {
            developer.get('icon').scale.x = fpsLerp(developer.get('icon').scale.x, 1, 0.33); 
            developer.get('icon').scale.y = fpsLerp(developer.get('icon').scale.y, 1, 0.33); 
            developer.get('icon').updateHitbox(); 
        }
    }

    if (canSelect)
    {
        if (developers.length > 1)
        {
            if (controls.UI_UP_P || controls.UI_DOWN_P || FlxG.mouse.wheel != 0)
            {
                if (controls.UI_UP_P || FlxG.mouse.wheel > 0)
                {
                    if (selInt > 0) selInt -= 1;
                    else if (selInt == 0) selInt = developers.length - 1;
                } else if (controls.UI_DOWN_P || FlxG.mouse.wheel < 0) {
                    if (selInt < developers.length - 1) selInt += 1;
                    else if (selInt == developers.length - 1) selInt = 0;
                }

                changeShit();
            }
        }
        
        if (controls.BACK)
        {
            MusicBeatState.switchState(new ScriptState('mainMenuState'));

            FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);

            canSelect = false;

            setGlobalVar('creditsStateSelInt', selInt);
        }
    }
}

function onBeatHit()
{
    for (developer in developers)
    {
        if (developers.indexOf(developer) == selInt && canSelect)
        {
            developer.get('icon').scale.x = 1.2;
            developer.get('icon').scale.y = 1.2;
            developer.get('icon').updateHitbox(); 
        }
    }
}

function changeShit()
{
    FlxTween.cancelTweensOf(bg);
    FlxTween.tween(bg, {y: FlxG.height / 2 - bg.height / 2 - (25 * (selInt)) / developers.length}, 60 / Conductor.bpm, {ease: FlxEase.cubeOut});

    for (developer in developers)
    {
        if (developers.indexOf(developer) == selInt)
        {
            if (developer.get('text').alpha != 1) developer.get('text').alpha = 1;

            FlxTween.color(bg, 60 / Conductor.bpm, bg.color, developer.get('color'), {ease: FlxEase.cubeOut});

            devLvlTxt.text = developer.get('category');
            devLvlBG.scale.y = (devLvlTxt.height + 20) * 2;

            devDescTxt.text = developer.get('description');
            devDescTxt.y = FlxG.height - devDescTxt.height - 10;
            devDescBG.scale.y = (devDescTxt.height + 20) * 2;
            devDescBG.y = FlxG.height - devDescBG.height;
        } else {
            if (developer.get('text').alpha != 0.5) developer.get('text').alpha = 0.5;
        }

        FlxTween.cancelTweensOf(developer.get('text'));
        FlxTween.tween(developer.get('text'), {x: 200 - 28 * Math.abs(developers.indexOf(developer) - selInt), y: 350 + 110 * (developers.indexOf(developer) - selInt)}, 30 / Conductor.bpm, {ease: FlxEase.cubeOut});
    }

    FlxG.sound.play(Paths.sound('scrollMenu'));
}

function addDeveloper(category:String, name:String, description:String, icon:String, color:Array)
{
    var developerData:StringMap = new StringMap();

    var text:Alphabet = new Alphabet(200 - 28 * Math.abs(developers.length - selInt), 350 + 110 * (developers.length - selInt), name, true);
    text.snapToPosition();
    add(text);
    text.antialiasing = ClientPrefs.data.antialiasing;
    text.alpha = 0.5;

    var iconSprite:AttachedSprite = new AttachedSprite('credits/' + icon);
    add(iconSprite);
    iconSprite.antialiasing = ClientPrefs.data.antialiasing;
    iconSprite.xAdd = text.width + 10;
    iconSprite.yAdd = text.height / 2 - iconSprite.height / 2;
    iconSprite.sprTracker = text;
    iconSprite.alpha = 0.25;
    
    developerData.set('category', category);
    developerData.set('text', text);
    developerData.set('icon', iconSprite);
    developerData.set('description', description);
    developerData.set('color', CoolUtil.colorFromString(color));

    developers.push(developerData);
}