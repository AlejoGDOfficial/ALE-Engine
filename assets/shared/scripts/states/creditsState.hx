import haxe.ds.StringMap;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import core.config.DiscordClient;
import utils.helpers.CoolUtil;
import flixel.math.FlxRect;
import visuals.objects.AttachedSprite;

var bg:FlxSprite;
var categories:Array<StringMap<Dynamic>> = [];
var difficulties:Array<String> = [];
var difficultyTextBG:FlxSprite;
var difficultyText:FlxText;
var devs:Array<StringMap<Dynamic>> = [];

/*
HOW TO ADD CREDITS:
var categoryName:StringMap<Dynamic> = new StringMap();
setCategoryData(categoryName, 'Category Name', ['Dev Name 1', 'Dev Name 2', 'Dev Name 3'], ['Dev Icon 1', 'Dev Icon 2', 'Dev Icon 3'], ['Dev Description 1', 'Dev Description 2', 'Dev Description 3'], ['Dev Color 1', 'Dev Color 2', 'Dev Color 3']);
categories.push(categoryName);
*/

var devsSelInt:Int = 0;

function onCreate()
{
    DiscordClient.changePresence('In the Menus...', 'Credits Menu');

    if (existsGlobalVar('creditsStateSelInt'))
    {
        devsSelInt = getGlobalVar('creditsStateSelInt');
    }

    var mainDevs:StringMap<Dynamic> = new StringMap();
    setCategoryData(mainDevs, 'ALE Engine Team', ['AlejoGDOfficial', 'Khorix the Inking', 'Eddy Smashcraft', 'Aleja', 'AdrianoSH'], ['alejoGDOfficial', 'khorixTheInking', 'eddySmashcraft', 'aleja', 'adrianoSH'], ['Main Programmer and Head', 'Main Artist/Animator', 'Helped with the Translations into Spanish', 'Voice Actress', 'Pixelart Artist'], ['03B1FC', '494F75', '5D4FBC', '404040', '909090']);

    var otherDevs:StringMap<Dynamic> = new StringMap();
    setCategoryData(otherDevs, 'ALE Engine Contributors', ['Slushi'], ['slushi'], ['C++ Functions'], ['03F2FF']);

    var psychMainDevs:StringMap<Dynamic> = new StringMap();
    setCategoryData(psychMainDevs, 'Psych Engine Team', ['Shadow Mario', 'Riveren'], ['shadowMario', 'riveren'], ['Main Programmer and Head', 'Main Artist/Animator'], ['444444', '14967B']);

    showShit();
}

var texts:Array<Alphabet> = [];
var images:Array<FlxSprite> = [];

var globalDevID:Int = 0;

var devLvlTxt:FlxText;
var devLvlBG:FlxSprite;

var devDescTxt:FlxText;
var devDescBG:FlxSprite;

function showShit()
{
    bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    bg.scale.set(1.25, 1.25);
    bg.screenCenter('x');
    add(bg);

    for (category in categories)
    {
        var categoryData = category.get("categoryData");
        var categoryName:String = categoryData.get("name");
        var categoryDevs:Array<String> = categoryData.get("devs");
        var devsDescriptions:Array<String> = categoryData.get("descriptions");
        var categoryColors:Array<String> = categoryData.get("colors");
        var icons:Array<String> = categoryData.get("icons");

        for (i in 0...categoryDevs.length)
        {
            var devData:StringMap<Dynamic> = new StringMap();
            devData.set('id', globalDevID);
            devData.set('category', categoryName);
            devData.set('dev', categoryDevs[i]);
            devData.set('description', devsDescriptions[i]);
            devData.set('color', categoryColors[i]);
            devs.push(devData);

            globalDevID++;

            var dev:String = categoryDevs[i];

            var devText:Alphabet = new Alphabet(100, 90, dev, true);
            devText.snapToPosition();
            add(devText);
            devText.alpha = 0.25;
            texts.push(devText);
        
            var devIcon:AttachedSprite = new AttachedSprite().loadGraphic(Paths.image('credits/' + icons[i]));
            add(devIcon);
            devIcon.xAdd = devText.width + 10;
            devIcon.yAdd = devText.height / 2 - devIcon.height / 2;
            devIcon.sprTracker = devText;
            devIcon.alpha = 0.25;
            images.push(devIcon);
        }
    }

    devLvlBG = new FlxSprite().makeGraphic(FlxG.width, 1, FlxColor.BLACK);
    devLvlBG.alpha = 0.5;
    devLvlBG.scrollFactor.x = devLvlBG.scrollFactor.y = 0;
    add(devLvlBG);

    devLvlTxt = new FlxText(0, 10, FlxG.width, '');
    devLvlTxt.setFormat(Paths.font('vcr.ttf'), 80, FlxColor.WHITE, 'center');
    devLvlTxt.scrollFactor.x = devLvlTxt.scrollFactor.y = 0;
    add(devLvlTxt);

    devDescBG = new FlxSprite().makeGraphic(FlxG.width, 1, FlxColor.BLACK);
    devDescBG.alpha = 0.5;
    devDescBG.scrollFactor.x = devDescBG.scrollFactor.y = 0;
    add(devDescBG);

    devDescTxt = new FlxText(0, 10, FlxG.width, '');
    devDescTxt.setFormat(Paths.font('vcr.ttf'), 40, FlxColor.WHITE, 'center');
    devDescTxt.scrollFactor.x = devDescTxt.scrollFactor.y = 0;
    add(devDescTxt);

    FlxG.camera.scroll.y = texts[devsSelInt].y + texts[devsSelInt].height / 2 - FlxG.height / 2;

    bg.scrollFactor.x = bg.scrollFactor.y = 0.25 / devs.length;

    changeOtherShit();
    changeDevsShit();
}

var canSelect:Bool = true;

function onUpdate(elapsed:Float)
{
    if (canSelect)
    {
        if (controls.UI_UP_P || FlxG.mouse.wheel > 0)
        {
            if (devsSelInt > 0)
            {
                devsSelInt -= 1;
            } else if (devsSelInt == 0) {
                devsSelInt = texts.length - 1;
            }
    
            changeDevsShit();
            changeOtherShit();
        } else if (controls.UI_DOWN_P || FlxG.mouse.wheel < 0) {
            if (devsSelInt < (texts.length - 1))
            {
                devsSelInt += 1;
            } else if (devsSelInt == texts.length - 1) {
                devsSelInt = 0;
            }
    
            changeDevsShit();
            changeOtherShit();
        }
        
        if (controls.BACK)
        {
            MusicBeatState.switchState(new ScriptState('mainMenuState'));

            FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);

            canSelect = false;

            setGlobalVar('creditsStateSelInt', devsSelInt);
        }
    }

    if (FlxG.sound.music != null)
        Conductor.devPosition = FlxG.sound.music.time;

    FlxG.camera.scroll.x = fpsLerp(FlxG.camera.scroll.x, devsSelInt * 25, 0.1);
    FlxG.camera.scroll.y = fpsLerp(FlxG.camera.scroll.y, devsSelInt * 105, 0.1);

    for (image in images)
    {
        image.scale.set(fpsLerp(image.scale.x, 1, 0.33), fpsLerp(image.scale.y, 1, 0.33));
    }
}

function changeOtherShit()
{
    FlxTween.cancelTweensOf(bg);
    FlxTween.tween(bg, {y: FlxG.height / 2 - bg.height / 2 - (25 * (devsSelInt)) / texts.length}, 60 / Conductor.bpm, {ease: FlxEase.cubeOut});

    for (dev in devs)
    {
        var id = dev.get('id');
        var category = dev.get('category');
        var name = dev.get('dev');
        var description = dev.get('description');
        var color = dev.get('color');

        if (id == devsSelInt)
        {
            FlxTween.color(bg, 1, bg.color, CoolUtil.colorFromString(color));

            devLvlTxt.text = category;
            devLvlBG.scale.y = (devLvlTxt.height + 20) * 2;

            devDescTxt.text = description;
            devDescTxt.y = FlxG.height - devDescTxt.height - 10;
            devDescBG.scale.y = (devDescTxt.height + 20) * 2;
            devDescBG.y = FlxG.height - devDescBG.height;
        }
    }
}
    
function changeDevsShit()
{
    for (i in 0...devs.length)
    {
        var destinationX:Float = 100 + i * 25;
        var destinationY:Float = 318 + i * 105;

        if (i == devsSelInt) 
        {
            texts[i].alpha = 1;
            images[i].alpha = 1;
        } else {
            texts[i].alpha = 0.5;
            images[i].alpha = 0.5;
        }
        
        texts[i].x = destinationX;
        texts[i].y = destinationY;

        if (i == devsSelInt) 
        {
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

function setCategoryData(object:StringMap, name:String, devs:Array<String>, icons:Array<String>, descriptions:Array<String>, colors:Array<String>)
{
    var categoryData:StringMap<Dynamic> = new StringMap();
    categoryData.set('name', name);
    categoryData.set('devs', devs);
    categoryData.set('icons', icons);
    categoryData.set('colors', colors);
    categoryData.set('descriptions', descriptions);
    object.set("categoryData", categoryData);
    categories.push(object);
}

function onBeatHit()
{
    for (image in images)
    {
        if (images.indexOf(image) == devsSelInt)
        {
            image.scale.set(1.25, 1.25);
        }
    }
}