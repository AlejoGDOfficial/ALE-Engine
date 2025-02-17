import haxe.ds.StringMap;

import visuals.objects.AttachedSprite;
import visuals.objects.Alphabet;

import flixel.group.FlxTypedGroup;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;

import utils.mods.Mods;

import tjson.TJSON as Json;

var bg:FlxSprite;

var spritesGroup:FlxTypedGroup<FlxSprite>;

var groups:Array<StringMap> = [];

var infoBar:FlxSprite;
var infoText:FlxText;
var descriptionText:FlxText;

var selInt:Dynamic = {
    developers: 0,
    groups: existsGlobalVar('creditsStateGroupsSelInt') ? getGlobalVar('creditsStateGroupsSelInt') : 0
};

function onCreate()
{
    DiscordClient.changePresence('In the Menus...', 'Credits Menu');

    bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    bg.scale.set(1.25, 1.25);
    bg.screenCenter('x');
    add(bg);
    bg.antialiasing = ClientPrefs.data.antialiasing;

    var fileToLoad = Paths.mods(Mods.currentModDirectory + '/credits.json');

    if (!FileSystem.exists(fileToLoad)) fileToLoad = Paths.getSharedPath('credits.json');

    spritesGroup = new FlxTypedGroup<FlxSprite>();
    add(spritesGroup);

    var jsonData = Json.parse(File.getContent(fileToLoad));

    for (group in jsonData.groups)
    {
        var groupData:StringMap = new StringMap();
    
        groupData.set('name', group.name);
        groupData.set('color', group.color);
        groupData.set('members', group.members);

        groups.push(groupData);
    }

    if (selInt.groups > groups.length - 1) selInt.groups = 0;

    Type.resolveEnum('flixel.text.FlxTextBorderStyle').OUTLINE;

    infoBar = new FlxSprite().makeGraphic(FlxG.width, 1, FlxColor.BLACK);
    infoBar.alpha = 0.5;
    infoBar.y = FlxG.height - infoBar.height;
    add(infoBar);

    infoText = new FlxText(0, 0, FlxG.width, 'Credits State | Info Text');
    infoText.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, 'center');
    infoText.font = Paths.font('vcr.ttf');
    infoText.borderStyle = FlxTextBorderStyle.OUTLINE;
    infoText.borderSize = 2;
    infoText.borderColor = FlxColor.BLACK;
    infoText.antialiasing = ClientPrefs.data.antialiasing;
    infoText.y = FlxG.height - infoText.height - 5;
    add(infoText);

    descriptionText = new FlxText(0, 0, FlxG.width, 'Credits State | Description Text');
    descriptionText.setFormat(Paths.font('vcr.ttf'), 48, FlxColor.WHITE, 'center');
    descriptionText.font = Paths.font('vcr.ttf');
    descriptionText.borderStyle = FlxTextBorderStyle.OUTLINE;
    descriptionText.borderSize = 2;
    descriptionText.borderColor = FlxColor.BLACK;
    descriptionText.antialiasing = ClientPrefs.data.antialiasing;
    descriptionText.y = infoText.y - descriptionText.height - 10;
    add(descriptionText);

    parseGroup();
}

var developers:Array<StringMap> = [];

function onUpdate()
{
    if (groups.length > 0)
    {
        if (controls.UI_LEFT_P || controls.UI_RIGHT_P || (FlxG.mouse.wheel != 0 && FlxG.keys.pressed.SHIFT))
        {
            if (controls.UI_LEFT_P || FlxG.mouse.wheel > 0)
            {
                if (selInt.groups > 0) selInt.groups--;
                else if (selInt.groups == 0) selInt.groups = groups.length - 1;
            } else if (controls.UI_RIGHT_P || FlxG.mouse.wheel < 0) {
                if (selInt.groups < groups.length - 1) selInt.groups++;
                else if (selInt.groups == groups.length - 1) selInt.groups = 0;
            }

            parseGroup();
        }

        if (controls.UI_UP_P || controls.UI_DOWN_P || (FlxG.mouse.wheel != 0 && !FlxG.keys.pressed.SHIFT))
        {
            if (controls.UI_UP_P || FlxG.mouse.wheel > 0)
            {
                if (selInt.developers > 0) selInt.developers--;
                else if (selInt.developers == 0) selInt.developers = developers.length - 1;
            } else if (controls.UI_DOWN_P || FlxG.mouse.wheel < 0) {
                if (selInt.developers < developers.length - 1) selInt.developers++;
                else if (selInt.developers == developers.length - 1) selInt.developers = 0;
            }

            changeShit();
        }

        if (controls.ACCEPT) CoolUtil.browserLoad(developers[selInt.developers].get('url'));
    }
    
    if (controls.BACK)
    {
        MusicBeatState.switchState(new ScriptState('mainMenuState'));

        FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);

        setGlobalVar('creditsStateDevelopersSelInt', selInt.developers);
        setGlobalVar('creditsStateGroupsSelInt', selInt.groups);
    }
}

function parseGroup()
{
    selInt.developers = 0;

    spritesGroup.clear();

    developers = [];

    for (member in groups[selInt.groups].get('members'))
    {
        addDeveloper(member.name, member.description, member.icon, member.color, member.url);
    }

    changeShit();
}

function addDeveloper(name:String, description:String, icon:String, color:String, url:String)
{
    var developerData:StringMap = new StringMap();

    var text:Alphabet = new Alphabet(0, 500 + 50 * developers.length, name, true);
    text.snapToPosition();
    spritesGroup.add(text);
    text.antialiasing = ClientPrefs.data.antialiasing;
    text.alpha = 0.5;

    var iconSprite:AttachedSprite = new AttachedSprite('credits/' + icon);
    spritesGroup.add(iconSprite);
    iconSprite.antialiasing = ClientPrefs.data.antialiasing;
    iconSprite.xAdd = text.width + 10;
    iconSprite.yAdd = text.height / 2 - iconSprite.height / 2;
    iconSprite.sprTracker = text;
    iconSprite.alpha = 0.25;

    text.x = FlxG.width / 2 - (text.width + 10 + iconSprite.width) / 2;
    
    developerData.set('text', text);
    developerData.set('icon', iconSprite);
    developerData.set('description', description);
    developerData.set('color', CoolUtil.colorFromString(color));
    developerData.set('url', url);

    developers.push(developerData);
}

function changeShit()
{
    FlxTween.cancelTweensOf(bg);
    FlxTween.tween(bg, {y: FlxG.height / 2 - bg.height / 2 - (25 * (selInt.developers)) / developers.length}, 60 / Conductor.bpm, {ease: FlxEase.cubeOut});

    for (developer in developers)
    {
        if (developers.indexOf(developer) == selInt.developers)
        {
            if (developer.get('text').alpha != 1) developer.get('text').alpha = 1;

            FlxTween.color(bg, 60 / Conductor.bpm, bg.color, developer.get('color'), {ease: FlxEase.cubeOut});
        } else {
            if (developer.get('text').alpha != 0.5) developer.get('text').alpha = 0.5;
        }

        FlxTween.cancelTweensOf(developer.get('text'));
        FlxTween.tween(developer.get('text'), {y: 300 + 110 * (developers.indexOf(developer) - selInt.developers)}, 30 / Conductor.bpm, {ease: FlxEase.cubeOut});
    }

    FlxG.sound.play(Paths.sound('scrollMenu'));

    infoText.applyMarkup('`UP - DOWN`    Developer: ' + (selInt.developers + 1) + '/' + developers.length + '    ' + 'Group: ' + (selInt.groups + 1) + '/' + groups.length + '    `LEFT - RIGHT`', [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.GRAY), '`')]);
    infoText.y = FlxG.height - infoText.height - 5;

    descriptionText.applyMarkup('`' + groups[selInt.groups].get('name') + ': ' + '`' + developers[selInt.developers].get('description'), [new FlxTextFormatMarkerPair(new FlxTextFormat(CoolUtil.colorFromString(groups[selInt.groups].get('color'))), '`')]);
    descriptionText.y = infoText.y - descriptionText.height - 5;

    infoBar.scale.y = (5 + infoText.height + 10 + descriptionText.height + 5) * 2;
    infoBar.y = FlxG.height - infoBar;
}