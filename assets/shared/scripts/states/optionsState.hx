import visuals.objects.AttachedSprite;
import visuals.objects.AttachedText;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import flixel.group.FlxTypedGroup;

import utils.mods.Mods;

import haxe.ds.StringMap;
import tjson.TJSON as Json;

import gameplay.states.game.PlayState;
import gameplay.states.game.LoadingState;
import core.gameplay.stages.StageData;

import flixel.util.FlxSave;

var canSelect:Bool = true;

var canSelectMenus:Bool = true;
var canSelectOptions:Bool = false;

var menusSelInt:Int = 0;
var optionsSelInt:Int = 0;

var menus:FlxTypedGroup<Alphabet>;
var fullMenus = [];

var options:FlxTypedGroup<Alphabet>;
var attaOptions:FlxTypedGroup<Alphabet>;
var checkBoxes:FlxTypedGroup<AttachedSprite>;
var fullOptions:Array<StringMap<Dynamic>> = new Array();

var jsonData = {menus: []};

var bg:FlxSprite;

var descriptions:FlxText;
var descriptionsBG:FlxSprite;

var configValues:Dynamic = {};
var configSources:StringMap<String> = new StringMap<String>();

function onCreate()
{
    addHaxeLibrary('JsonPrinter', 'haxe.format');

    if (existsGlobalVar('optionsStateSelInt')) menusSelInt = getGlobalVar('optionsStateSelInt');

    var bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    add(bg);
    bg.antialiasing = ClientPrefs.data.antialiasing;
    bg.alpha = 0.5;
    bg.color = FlxColor.fromRGB(100, 125, 150);

    menus = new FlxTypedGroup<Alphabet>();
    add(menus);

    options = new FlxTypedGroup<Alphabet>();
    add(options);
    attaOptions = new FlxTypedGroup<Alphabet>();
    add(attaOptions);
    checkBoxes = new FlxTypedGroup<AttachedSprite>();
    add(checkBoxes);

    descriptions = new FlxText(0, 0, FlxG.width - 100, '');
    descriptions.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, 'center');
    descriptions.x = FlxG.width / 2 - descriptions.width / 2;
    descriptions.y = FlxG.height - descriptions.height - 50;

    descriptionsBG = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
    descriptionsBG.alpha = 0.5;
    descriptionsBG.scale.x = descriptions.width + 20;
    descriptionsBG.scale.y = descriptions.height + 20;
    descriptionsBG.updateHitbox();
    descriptionsBG.x = descriptions.x - 10;
    descriptionsBG.y = descriptions.y - 10;

    add(descriptionsBG);
    add(descriptions);

    var jsonFiles = [
        {source: Paths.getSharedPath('defaultOptions.json'), isMod: false},
        {source: Paths.mods(Mods.currentModDirectory + '/customOptions.json'), isMod: true}
    ];

    for (jsonFile in jsonFiles)
    {
        if (FileSystem.exists(jsonFile.source))
        {
            var fileData = Json.parse(File.getContent(jsonFile.source));

            for (menu in fileData.menus)
            {
                if (Reflect.hasField(menu, 'options'))
                {
                    for (option in menu.options)
                    {
                        configSources.set(option.variable, jsonFile.isMod);

                        var save:FlxSave = new FlxSave();
                        save.bind('data', CoolUtil.getSavePath() + '/preferences' + (jsonFile.isMod ? '/' + Mods.currentModDirectory : ''));

                        var daJsonData = save != null ? save.data.settings : {};
    
                        setConfigValue(option.variable, Reflect.hasField(daJsonData, option.variable) && Reflect.field(daJsonData, option.variable) != null ? Reflect.field(daJsonData, option.variable) : option.default);
                    }
                }
            }

            jsonData.menus = jsonData.menus.concat(fileData.menus);
        }
    }

    parseMenus();
}

function parseMenus()
{
    menus.clear();

    for (menu in jsonData.menus)
    {
        var text:Alphabet = new Alphabet(0, 0, menu.name + ' >', true);
        text.snapToPosition();
        text.antialiasing = ClientPrefs.data.antialiasing;
        text.alpha = 0.25;
        menus.add(text);

        fullMenus.push(Reflect.hasField(menu, 'stateData') ? menu.stateData : {noStateData: true});
    }

    canSelectMenus = true;

    changeMenusShit(false);

    descriptions.visible = descriptionsBG.visible = false;
}

function parseOptions()
{
    fullOptions = [];
    options.clear();
    checkBoxes.clear();
    
    optionsSelInt = 0;

    for (menu in jsonData.menus)
    {
        if (menu == jsonData.menus[menusSelInt])
        {
            for (option in menu.options)
            {
                var save:FlxSave = new FlxSave();
                save.bind('data', CoolUtil.getSavePath() + '/preferences' + (configSources.get(option.variable) ? '/' + Mods.currentModDirectory : ''));

                var daJsonData = save != null ? save.data.settings : {};

                addOption(
                    option.name, 
                    Reflect.hasField(option, 'description') ? option.description : '', 
                    option.variable, 
                    option.type, 
                    Reflect.hasField(daJsonData, option.variable) && Reflect.field(daJsonData, option.variable) != null ? Reflect.field(daJsonData, option.variable) : option.default, 
                    Reflect.hasField(option, 'strings') ? option.strings : null, 
                    Reflect.hasField(option, 'min') ? option.min : null, 
                    Reflect.hasField(option, 'max') ? option.max : null, 
                    Reflect.hasField(option, 'change') ? option.change : null, 
                    Reflect.hasField(option, 'decimals') ? option.decimals : null
                );
            }
        }
    }
    
    canSelectOptions = true;

    changeOptionsShit(false);

    descriptions.visible = descriptionsBG.visible = true;
}

var holdTime:Float = 0;

function onUpdate(elapsed:Float)
{   
    if (controls.BACK && canSelectMenus)
    {
        setGlobalVar('optionsStateSelInt', menusSelInt);

        if (PlayState.onOptionsState)
        {
            StageData.loadDirectory(PlayState.SONG);
            LoadingState.loadAndSwitchState(new PlayState());
            FlxG.sound.music.volume = 0;
            PlayState.onOptionsState = false;
        } else {
            MusicBeatState.switchState(new ScriptState('mainMenuState'));
        }

        FlxG.sound.play(Paths.sound('cancelMenu'));

        canSelect = false;
    }

    if (canSelect)
    {
        if (canSelectMenus)
        {
            if (menus.members.length > 1)
            {
                if (controls.UI_UP_P || FlxG.mouse.wheel > 0)
                {
                    if (menusSelInt > 0)
                    {
                        menusSelInt -= 1;
                    } else if (menusSelInt == 0) {
                        menusSelInt = menus.members.length - 1;
                    }
            
                    changeMenusShit(true);
                } else if (controls.UI_DOWN_P || FlxG.mouse.wheel < 0) {
                    if (menusSelInt < (menus.members.length - 1))
                    {
                        menusSelInt += 1;
                    } else if (menusSelInt == menus.members.length - 1) {
                        menusSelInt = 0;
                    }
            
                    changeMenusShit(true);
                }
            }

            if (controls.ACCEPT)
            {
                FlxG.sound.play(Paths.sound('confirmMenu'));

                if (Reflect.hasField(fullMenus[menusSelInt], 'noStateData')) 
                {
                    for (i in 0...menus.length) FlxTween.tween(menus.members[i], {x: 0 - menus.members[i].width}, 30 / Conductor.bpm, {ease: FlxEase.cubeIn});

                    canSelectMenus = false;
                }
        
                for (i in 0...menus.length) if (menus.members[i].text.substr(0, menus.members[i].text.length - 2) == jsonData.menus[menusSelInt].name) if (ClientPrefs.data.flashing) FlxFlicker.flicker(menus.members[i], 60 / Conductor.bpm, 0.05);

                new FlxTimer().start(30 / Conductor.bpm, function(tmr:FlxTimer)
                {
                    if (Reflect.hasField(fullMenus[menusSelInt], 'noStateData'))
                    {
                        parseOptions();
                    } else {
                        var stateData = fullMenus[menusSelInt];
                        
                        if (Reflect.hasField(stateData, 'subState'))
                        {
                            openSubState(Reflect.field(stateData, 'subState'), Reflect.hasField(stateData, 'params') ? Reflect.field(stateData, 'params') : []);
                        } else if (Reflect.hasField(stateData, 'state')) {
                            if (Reflect.hasField(stateData, 'script') && Reflect.field(stateData, 'script')) switchToScriptState(Reflect.field(stateData, 'state'));
                            else switchState(Reflect.field(stateData, 'state'), Reflect.hasField(stateData, 'params') ? Reflect.field(stateData, 'params') : []);
                            
                            setGlobalVar('optionsStateSelInt', menusSelInt);
                        }
                    }
                });
            }
        } else if (canSelectOptions) {
            if (controls.ACCEPT)
            {
                if (fullOptions[optionsSelInt].exists('checkBox'))
                {
                    var checkBox = fullOptions[optionsSelInt].get('checkBox');

                    switch (checkBox.animation.name)
                    {
                        case 'start', 'true':
                            checkBox.animation.play('false');
                            fullOptions[optionsSelInt].set('value', false);
                        case 'finish', 'false':
                            checkBox.animation.play('true');
                            fullOptions[optionsSelInt].set('value', true);
                    }
                }
            }

            if (controls.UI_LEFT || controls.UI_RIGHT)
            {
                var pressed = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
    
                if (holdTime > 0.5 || pressed)
                {
                    switch (fullOptions[optionsSelInt].get('type'))
                    {
                        case 'STRING':
                            var optionData = fullOptions[optionsSelInt];
                            changeString(optionData.get('attaText'), false, optionData.get('default'), optionData.get('strings'), controls.UI_LEFT ? -1 : 1);
                        case 'INTEGER', 'FLOAT':
                            var optionData = fullOptions[optionsSelInt];
                            changeValue(optionData.get('attaText'), false, optionData.get('default'), optionData.get('min'), optionData.get('max'), (controls.UI_LEFT ? -1 : 1) * optionData.get('change'), optionData.get('decimals'));
                    }
                }

                holdTime += elapsed;
            } else if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
                holdTime = 0;
            }

            if (controls.UI_UP_P || FlxG.mouse.wheel > 0)
            {
                if (optionsSelInt > 0)
                {
                    optionsSelInt -= 1;
                } else if (optionsSelInt == 0) {
                    optionsSelInt = options.members.length - 1;
                }
        
                changeOptionsShit(true);
            } else if (controls.UI_DOWN_P || FlxG.mouse.wheel < 0) {
                if (optionsSelInt < (options.members.length - 1))
                {
                    optionsSelInt += 1;
                } else if (optionsSelInt == options.members.length - 1) {
                    optionsSelInt = 0;
                }
        
                changeOptionsShit(true);
            }

            if (controls.BACK)
            {
                for (option in fullOptions)
                {
                    setConfigValue(option.get('variable'), option.get('value'));
                    saveConfig(option.get('variable'));
                }

                for (i in 0...options.length) FlxTween.tween(options.members[i], {x: FlxG.width}, 30 / Conductor.bpm, {ease: FlxEase.cubeIn});

                new FlxTimer().start(30 / Conductor.bpm, function(tmr:FlxTimer)
                {
                    parseMenus();
                });

                canSelectOptions = false;

                FlxG.sound.play(Paths.sound('cancelMenu'));
            }
        }
    }
}

function changeMenusShit(playSound:Bool)
{
    for (menu in menus)
    {
        if (menusSelInt == menus.members.indexOf(menu)) menu.alpha = 1;
        else menu.alpha = 0.5;

        FlxTween.cancelTweensOf(menu);
        FlxTween.tween(menu, {x: 150 - 30 * (Math.abs(menus.members.indexOf(menu) - menusSelInt) * Math.abs(menus.members.indexOf(menu) - menusSelInt) / 2), y: 318 + (menus.members.indexOf(menu) - menusSelInt) * 105}, 30 / Conductor.bpm, {ease: FlxEase.cubeOut});
    }

    if (playSound && fullMenus.length > 1) FlxG.sound.play(Paths.sound('scrollMenu'));
}

var attaValue:Float = 0;

var attaIndex:Int = 0;

function changeOptionsShit(playSound:Bool)
{
    for (option in options.members)
    {
        if (options.members.indexOf(option) == optionsSelInt) option.alpha = 1;
        else option.alpha = 0.5;

        FlxTween.cancelTweensOf(option);
        FlxTween.tween(option, {x: 150 - 30 * (Math.abs(options.members.indexOf(option) - optionsSelInt) * Math.abs(options.members.indexOf(option) - optionsSelInt) / 2), y: 318 + (options.members.indexOf(option) - optionsSelInt) * 75}, 30 / Conductor.bpm, {ease: FlxEase.cubeOut});
    }

    switch (fullOptions[optionsSelInt].get('type'))
    {
        case 'INTEGER', 'FLOAT':
            attaValue = fullOptions[optionsSelInt].get('default');
        case 'STRING':
            attaIndex = fullOptions[optionsSelInt].get('strings').indexOf(fullOptions[optionsSelInt].get('default'));
    }

    if (playSound && fullOptions.length > 1) FlxG.sound.play(Paths.sound('scrollMenu'));

    descriptions.text = fullOptions[optionsSelInt].get('description');
    descriptions.x = FlxG.width / 2 - descriptions.width / 2;
    descriptions.y = FlxG.height - descriptions.height - 50;
    descriptions.visible = descriptionsBG.visible = fullOptions[optionsSelInt].get('description') != '';

    descriptionsBG.scale.x = descriptions.width + 20;
    descriptionsBG.scale.y = descriptions.height + 20;
    descriptionsBG.updateHitbox();
    descriptionsBG.x = descriptions.x - 10;
    descriptionsBG.y = descriptions.y - 10;
}

function addOption(name:String, description:String, variable:String, type:String, defaultVar:Dynamic, ?strings:Array = [], ?min:Dynamic = 0, ?max:Dynamic = 0, ?change:Float = 0, ?decimals:String = 0)
{
    var optionData:StringMap<Dynamic> = new StringMap<Dynamic>();
    var checkBox:AttachedSprite = null;

    var text:Alphabet = new Alphabet(FlxG.width, 0, name + (Std.string(type).toUpperCase() == 'BOOL' ? '' : ':'), true);
    text.snapToPosition();
    text.antialiasing = ClientPrefs.data.antialiasing;
    text.alpha = 0.25;
    text.scaleX = text.scaleY = 0.75;
    options.add(text);

    optionData.set('text', text);
    optionData.set('name', name);
    optionData.set('description', description);
    optionData.set('variable', variable);
    optionData.set('type', type.toUpperCase());
    optionData.set('default', defaultVar);
    optionData.set('value', defaultVar);

    if (Std.string(type).toUpperCase() == 'INTEGER' || Std.string(type).toUpperCase() == 'FLOAT')
    {
        optionData.set('min', min);
        optionData.set('max', max);
        optionData.set('change', change);
        if (Std.string(type).toUpperCase() == 'FLOAT') optionData.set('decimals', decimals);
    }

    if (Std.string(type).toUpperCase() == 'STRING') optionData.set('strings', strings);

    switch (Std.string(type).toUpperCase())
    {
        case 'BOOL':
            checkBox = new AttachedSprite();
            checkBox.frames = Paths.getSparrowAtlas('checkboxanim');
            checkBox.animation.addByPrefix('start', 'start', 24, false);
            checkBox.animation.addByPrefix('finish', 'finish', 24, false);
            checkBox.animation.addByPrefix('true', 'true', 24, false);
            checkBox.animation.addByPrefix('false', 'false', 24, false);
            checkBox.animation.play(defaultVar ? 'start' : 'finish');
            checkBox.antialiasing = ClientPrefs.data.antialiasing;
            checkBox.animation.callback = (name:String) -> {
                switch (name)
                {
                    case 'start':
                        checkBox.offset.set(6, 6);
                    case 'true':
                        checkBox.offset.set(25, 13);
                    case 'false':
                        checkBox.offset.set(19, 15);
                    case 'finish':
                        checkBox.offset.set(5, 1);
                }
            }
            checkBox.animation.finishCallback = (name:String) -> {
                switch (name)
                {
                    case 'true':
                        checkBox.animation.play('start');
                    case 'false':
                        checkBox.animation.play('finish');
                }
            }
            checkBox.centerOffsets();
            checkBox.sprTracker = text;
            checkBox.xAdd = text.width + 5;
            checkBox.yAdd = text.height / 2 - checkBox.height / 2;
            checkBox.scale.set(0.5, 0.5);
            checkBoxes.add(checkBox);

            optionData.set('checkBox', checkBox);
        case 'INTEGER', 'FLOAT', 'STRING':
            var attaText:AttachedText = new AttachedText(defaultVar, text.width + 20, -40, false, 0.8);
            attaText.snapToPosition();
            attaText.antialiasing = ClientPrefs.data.antialiasing;
            attaText.alpha = 0.25;
            attaText.sprTracker = text;
            attaText.copyAlpha = true;
            attaOptions.add(attaText);

            optionData.set('attaText', attaText);
    }

    fullOptions.push(optionData);
}

function changeValue(attaText:AttachedText, reset:Bool, defaultVar:Float, min:Float, max:Float, change:Float, ?decimals:Int = 0)
{
    if (reset) attaValue = defaultVar;
    attaValue = FlxMath.roundDecimal(FlxMath.bound(attaValue + change, min, max), decimals);
    attaText.text = attaValue;

    fullOptions[optionsSelInt].set('value', attaValue);
}

function changeString(attaText:AttachedText, reset:Bool, defaultVar:String, strings:Array, mult:Int)
{
    if (reset) attaIndex = strings.indexOf(defaultVar);

    if (mult == -1)
    {
        if (attaIndex > 0)
        {
            attaIndex += 1 * mult;
        } else if (attaIndex == 0) {
            attaIndex = strings.length - 1;
        }
    } else if (mult == 1) {
        if (attaIndex < (strings.length - 1))
        {
            attaIndex += 1 * mult;
        } else if (attaIndex == strings.length - 1) {
            attaIndex = 0;
        }
    }

    attaText.text = strings[attaIndex];

    fullOptions[optionsSelInt].set('value', strings[attaIndex]);
}

function setConfigValue(variable:String, value:Dynamic)
{
    Reflect.setField(configValues, variable, value);
}

function saveConfig(variable:String)
{
    var saveFile:Bool = configSources.get(variable);

    if (saveFile == null) return;

    var fileConfig:Dynamic = {};
    
    for (key in configSources.keys())
    {
        if (configSources.get(key) == saveFile)
        {
            Reflect.setField(fileConfig, key, Reflect.field(configValues, key));
        }
    }

    var save:FlxSave;
    save = new FlxSave();
    save.bind('data', CoolUtil.getSavePath() + '/preferences' + (saveFile ? '/' + Mods.currentModDirectory : ''));
    save.data.settings = fileConfig;
    save.flush();

    ClientPrefs.loadJsonPrefs();
    ClientPrefs.loadPrefs();
}