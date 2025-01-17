import flixel.FlxState;
import flixel.group.FlxTypedGroup;

import utils.mods.Mods;

import visuals.objects.AttachedSprite;
import visuals.objects.AttachedText;

import gameplay.states.game.PlayState;
import gameplay.states.game.LoadingState;
import core.gameplay.stages.StageData;

import haxe.ds.StringMap;
import tjson.TJSON as Json;

import flixel.util.FlxSave;

var jsonData:Dynamic;

var menus:Array<StringMap> = [];
var options:Array<StringMap> = [];

var menusSprites:FlxTypedGroup<Dynamic>;
var optionsSprites:FlxTypedGroup<Dynamic>;

var descriptions:FlxText;
var descriptionsBG:FlxSprite;

var saveData:StringMap<Dynamic> = new StringMap<Dynamic>();

function onCreate()
{
    var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    add(bg);
    bg.scrollFactor.set();
    bg.antialiasing = ClientPrefs.data.antialiasing;
    bg.alpha = 0.75;
    bg.color = FlxColor.fromRGB(100, 100, 125);

    menusSprites = new FlxTypedGroup<Dynamic>();
    add(menusSprites);

    optionsSprites = new FlxTypedGroup<Dynamic>();
    add(optionsSprites);

    descriptions = new FlxText(0, 0, FlxG.width - 100, '');
    descriptions.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, 'center');
    descriptions.scrollFactor.set();
    descriptions.antialiasing = ClientPrefs.data.antialiasing;
    descriptions.x = FlxG.width / 2 - descriptions.width / 2;
    descriptions.y = FlxG.height - descriptions.height - 50;
    descriptions.visible = false;

    descriptionsBG = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
    descriptionsBG.scrollFactor.set();
    descriptionsBG.alpha = 0.5;
    descriptionsBG.scale.x = descriptions.width + 20;
    descriptionsBG.scale.y = descriptions.height + 20;
    descriptionsBG.updateHitbox();
    descriptionsBG.x = descriptions.x - 10;
    descriptionsBG.y = descriptions.y - 10;
    descriptionsBG.visible = false;

    add(descriptionsBG);
    add(descriptions);

    var jsonPath = Paths.mods(Mods.currentModDirectory + '/options.json');
    if (!FileSystem.exists(jsonPath)) jsonPath = Paths.getSharedPath('options.json');

    jsonData = Json.parse(File.getContent(jsonPath));

    for (menu in jsonData.menus)
    {
        if (Reflect.hasField(menu, 'options'))
        {
            for (option in menu.options) saveData.set(option.variable, option.default);
        }
    }

    parseMenus();
}

var canSelect = {menus: false, options: false};

var selInt = {menus: existsGlobalVar('optionsStateSelInt') ? getGlobalVar('optionsStateSelInt') : 0, options: 0};

var holdTime:Float = 0;

function onUpdate(elapsed:Float)
{
    var controlsUp = controls.UI_UP_P || FlxG.mouse.wheel > 0;
    var controlsDown = controls.UI_DOWN_P || FlxG.mouse.wheel < 0;
    var controlsAccept = controls.ACCEPT;

    if (canSelect.menus)
    {
        if (controlsUp || controlsDown)
        {
            selInt.menus = controlsUp ? (selInt.menus == 0 ? menus.length - 1 : selInt.menus - 1) : controlsDown ? (selInt.menus == menus.length - 1 ? 0 : selInt.menus + 1) : selInt;

            changeMenusShit();
        }

        if (controlsAccept)
        {
            FlxG.sound.play(Paths.sound('confirmMenu'));

            if (ClientPrefs.data.flashing) FlxFlicker.flicker(menus[selInt.menus].get('text'), 60 / Conductor.bpm, 0.05);
            
            if (menus[selInt.menus].get('stateData') == null) canSelect.menus = false;

            new FlxTimer().start(30 / Conductor.bpm, function(tmr:FlxTimer)
            {
                if (menus[selInt.menus].get('stateData') == null)
                {
                    parseOptions();
                } else {
                    var stateData = menus[selInt.menus].get('stateData');
                        
                    if (Reflect.hasField(stateData, 'subState'))
                    {
                        if (Reflect.hasField(stateData, 'script') && Reflect.field(stateData, 'script')) openScriptSubState(Reflect.field(stateData, 'subState'));
                        else openSubState(Reflect.field(stateData, 'subState'), Reflect.hasField(stateData, 'params') ? Reflect.field(stateData, 'params') : []);
                    } else if (Reflect.hasField(stateData, 'state')) {
                        if (Reflect.hasField(stateData, 'script') && Reflect.field(stateData, 'script')) switchToScriptState(Reflect.field(stateData, 'state'));
                        else switchState(Reflect.field(stateData, 'state'), Reflect.hasField(stateData, 'params') ? Reflect.field(stateData, 'params') : []);
                        
                        setGlobalVar('optionsStateSelInt', selInt.menus);
                    }
                }
            });
        }

        if (controls.BACK && canSelect.menus)
        {
            setGlobalVar('optionsStateSelInt', selInt.menus);
    
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
    
            canSelect.menus = false;
        }
    } else if (canSelect.options) {
        if (controlsUp || controlsDown)
        {
            selInt.options = controlsUp ? (selInt.options == 0 ? options.length - 1 : selInt.options - 1) : controlsDown ? (selInt.options == options.length - 1 ? 0 : selInt.options + 1) : selInt;

            changeOptionsShit();
        }

        if (!options[selInt.options].get('blocked'))
        {
            if (controlsAccept)
            {
                if (options[selInt.options].get('type') == 'BOOL')
                {
                    switch (options[selInt.options].get('checkBox').animation.name)
                    {
                        case 'start', 'true':
                            options[selInt.options].get('checkBox').animation.play('false');
                            options[selInt.options].set('value', false);
                        case 'finish', 'false':
                            options[selInt.options].get('checkBox').animation.play('true');
                            options[selInt.options].set('value', true);
                    }
                }
            }
    
            if (controls.UI_LEFT || controls.UI_RIGHT)
            {
                var pressed = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
    
                if (holdTime > 0.5 || pressed)
                {
                    switch (options[selInt.options].get('type'))
                    {
                        case 'STRING':
                            options[selInt.options].set('stringIndex', FlxMath.bound(options[selInt.options].get('stringIndex') + (controls.UI_LEFT ? -1 : controls.UI_RIGHT ? 1 : 0), 0, options[selInt.options].get('strings').length - 1));
                            options[selInt.options].set('value', options[selInt.options].get('strings')[options[selInt.options].get('stringIndex')]);
                            options[selInt.options].get('attaText').text = options[selInt.options].get('value');
                        case 'INTEGER':
                            options[selInt.options].set('value', FlxMath.bound(options[selInt.options].get('value') + (controls.UI_LEFT ? -options[selInt.options].get('change') : controls.UI_RIGHT ? options[selInt.options].get('change') : 0), options[selInt.options].get('min'), options[selInt.options].get('max')));
                        case 'FLOAT':
                            options[selInt.options].set('value', FlxMath.roundDecimal(FlxMath.bound(options[selInt.options].get('value') + (controls.UI_LEFT ? -options[selInt.options].get('change') : controls.UI_RIGHT ? options[selInt.options].get('change') : 0), options[selInt.options].get('min'), options[selInt.options].get('max')), options[selInt.options].get('decimals')));
                    }
                    
                    options[selInt.options].get('attaText').text = options[selInt.options].get('value');
                }
    
                holdTime += elapsed;
            } else if (controls.UI_LEFT_R || controls.UI_RIGHT_R) {
                holdTime = 0;
            }
        }

        if (controls.BACK)
        {
            descriptionsBG.visible = descriptions.visible = false;

            parseMenus();

            for (optionMap in options) saveData.set(optionMap.get('variable'), optionMap.get('value'));

            saveConfig();

            canSelect.options = false;
        }
    }
}

function parseMenus()
{
    menusSprites.clear();
    menus = [];

    FlxTween.cancelTweensOf(FlxG.camera.scroll);
    FlxTween.tween(FlxG.camera.scroll, {x: 0}, 60 / Conductor.bpm, {ease: FlxEase.circInOut, onComplete: () -> { 
        canSelect.menus = true;
        selInt.options = 0;
    }});

    for (menu in jsonData.menus)
    {
        var mapData:StringMap<Dynamic> = new StringMap<Dynamic>();

        var text:Alphabet = new Alphabet(0, 0, menu.name + ' >', true);
        text.snapToPosition();
        text.antialiasing = ClientPrefs.data.antialiasing;
        text.alpha = 0.25;
        menusSprites.add(text);
        
        mapData.set('index', menus.length);
        mapData.set('name', menu.name);
        mapData.set('text', text);
        mapData.set('stateData', Reflect.hasField(menu, 'stateData') ? menu.stateData : null);

        menus.push(mapData);
    }

    changeMenusShit();
}

function changeMenusShit()
{
    for (menuMap in menus)
    {
        if (menuMap.get('index') == selInt.menus) menuMap.get('text').alpha = 1;
        else menuMap.get('text').alpha = 0.25;

        FlxTween.cancelTweensOf(menuMap.get('text'));
        FlxTween.tween(menuMap.get('text'), {x: 150 - 30 * (Math.abs(menuMap.get('index') - selInt.menus) * Math.abs(menuMap.get('index') - selInt.menus) / 2), y: 318 + (menuMap.get('index') - selInt.menus) * 105}, 30 / Conductor.bpm, {ease: FlxEase.cubeOut});
    }
}

function parseOptions()
{
    optionsSprites.clear();
    options = [];

    FlxTween.cancelTweensOf(FlxG.camera.scroll);
    FlxTween.tween(FlxG.camera.scroll, {x: FlxG.width}, 60 / Conductor.bpm, {ease: FlxEase.circInOut, onComplete: () -> { canSelect.options = true; }});

    for (menu in jsonData.menus)
    {
        if (menus[selInt.menus].get('name') == menu.name)
        {
            if (Reflect.hasField(menu, 'options'))
            {
                for (option in menu.options)
                {
                    var optionData:StringMap<Dynamic> = new StringMap<Dynamic>();
                
                    optionData.set('blocked', Reflect.hasField(option, 'blocked') && option.blocked);

                    var save:FlxSave = new FlxSave();
                    save.bind('preferences', CoolUtil.getSavePath() + '/' + Mods.currentModDirectory);

                    option.default = save != null && Reflect.hasField(save.data.settings, option.variable) && !optionData.get('blocked') ? Reflect.field(save.data.settings, option.variable) : option.default;

                    var text:Alphabet = new Alphabet(FlxG.width, 0, option.name + (option.type.toUpperCase() == 'BOOL' ? '' : ':'), true);
                    text.snapToPosition();
                    text.antialiasing = ClientPrefs.data.antialiasing;
                    text.alpha = 0.25;
                    text.scaleX = text.scaleY = 0.75;
                    if (optionData.get('blocked')) for (letter in text.members) letter.color = FlxColor.fromRGB(100, 100, 125);
                    optionsSprites.add(text);
                
                    optionData.set('index', options.length);
                    optionData.set('text', text);
                    optionData.set('name', option.name);
                    optionData.set('description', option.description);
                    optionData.set('variable', option.variable);
                    optionData.set('type', option.type.toUpperCase());
                    optionData.set('default', option.default);
                    optionData.set('value', option.default);
                
                    switch (option.type.toUpperCase())
                    {
                        case 'BOOL':
                            var checkBox:AttachedSprite = new AttachedSprite();
                            checkBox.frames = Paths.getSparrowAtlas('checkboxanim');
                            checkBox.animation.addByPrefix('start', 'start', 24, false);
                            checkBox.animation.addByPrefix('finish', 'finish', 24, false);
                            checkBox.animation.addByPrefix('true', 'true', 24, false);
                            checkBox.animation.addByPrefix('false', 'false', 24, false);
                            checkBox.animation.play(option.default ? 'start' : 'finish');
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
                            if (optionData.get('blocked')) checkBox.color = FlxColor.fromRGB(100, 100, 125);
                            optionsSprites.add(checkBox);
                
                            optionData.set('checkBox', checkBox);
                        case 'INTEGER', 'FLOAT', 'STRING':
                            var attaText:AttachedText = new AttachedText(option.default, text.width + 20, -40, false, 0.8);
                            attaText.snapToPosition();
                            attaText.antialiasing = ClientPrefs.data.antialiasing;
                            attaText.alpha = 0.25;
                            attaText.sprTracker = text;
                            attaText.copyAlpha = true;
                            if (optionData.get('blocked')) attaText.color = FlxColor.fromRGB(100, 100, 125);
                            optionsSprites.add(attaText);
                
                            optionData.set('attaText', attaText);
                    }
                
                    switch (option.type.toUpperCase())
                    {
                        case 'STRING':
                            optionData.set('strings', option.strings);
                            optionData.set('stringIndex', option.strings.indexOf(optionData.get('value')));
                        case 'INTEGER':
                            optionData.set('min', option.min);
                            optionData.set('max', option.max);
                            optionData.set('change', option.change);
                        case 'FLOAT':
                            optionData.set('min', option.min);
                            optionData.set('max', option.max);
                            optionData.set('change', option.change);
                            optionData.set('decimals', option.decimals);
                    }
                
                    options.push(optionData);
                }
            }
        }
    }

    changeOptionsShit();
}

function changeOptionsShit()
{
    for (optionMap in options)
    {
        if (optionMap.get('index') == selInt.options) optionMap.get('text').alpha = 1;
        else optionMap.get('text').alpha = 0.25;

        FlxTween.cancelTweensOf(optionMap.get('text'));
        FlxTween.tween(optionMap.get('text'), {x: FlxG.width + 250 + 30 * (Math.abs(optionMap.get('index') - selInt.options) * Math.abs(optionMap.get('index') - selInt.options) / 2), y: 318 + (optionMap.get('index') - selInt.options) * 75}, 30 / Conductor.bpm, {ease: FlxEase.cubeOut});
    }

    descriptions.text = options[selInt.options].get('description');
    descriptions.x = FlxG.width / 2 - descriptions.width / 2;
    descriptions.y = FlxG.height - descriptions.height - 50;

    descriptionsBG.scale.x = descriptions.width + 20;
    descriptionsBG.scale.y = descriptions.height + 20;
    descriptionsBG.updateHitbox();
    descriptionsBG.x = descriptions.x - 10;
    descriptionsBG.y = descriptions.y - 10;

    descriptionsBG.visible = descriptions.visible = options[selInt.options].get('description') != '';
}

function saveConfig()
{
    addHaxeLibrary('JsonPrinter', 'haxe.format');

    var fileConfig:Dynamic = {};

    for (string in saveData.keys()) Reflect.setField(fileConfig, string, saveData.get(string));

    var save:FlxSave;
    save = new FlxSave();
    save.bind('preferences', CoolUtil.getSavePath() + '/' + Mods.currentModDirectory);
    save.data.settings = fileConfig;
    save.flush();

    ClientPrefs.loadJsonPrefs();
    ClientPrefs.saveSettings();
    ClientPrefs.loadPrefs();
}