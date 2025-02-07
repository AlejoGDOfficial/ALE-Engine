import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import core.config.DiscordClient;
import core.config.ClientPrefs;
import gameplay.states.game.PlayState;
import utils.scripting.states.LuaUtils;

var bg:FlxSprite;
var magentaBg:FlxSprite;

var options:Array<String> = ['storyMode', 'freeplay', 'credits', 'options'];
var images:Array<FlxSprite> = [];

var selectedMenu:String;

var version:FlxText;

var selInt:Int = 0;

var objectsScale:Array = [];
var selectingObject:Array = [];

function onCreate()
{
    DiscordClient.changePresence('In the Menus...', 'Main Menu');

    if (existsGlobalVar('mainMenuStateSelInt'))
    {
        selInt = getGlobalVar('mainMenuStateSelInt');
    }

    bg = new FlxSprite().loadGraphic(Paths.image('menuBGYellow'));
    add(bg);
    bg.antialiasing = ClientPrefs.data.antialiasing;
    bg.scrollFactor.set(0, 0.25 * 5 / options.length);
    bg.scale.set(1.25, 1.25);
    bg.screenCenter('x');

    magentaBg = new FlxSprite().loadGraphic(Paths.image('menuBGMagenta'));
    add(magentaBg);
    magentaBg.antialiasing = ClientPrefs.data.antialiasing;
    magentaBg.scrollFactor.set(0, 0.25 * 5 / options.length);
    magentaBg.scale.set(1.25, 1.25);
    magentaBg.screenCenter('x');
    magentaBg.visible = false;

    for (i in options)
    {
        var img = new FlxSprite();
        img.frames = Paths.getSparrowAtlas('mainMenuState/' + i);
        img.animation.addByPrefix('basic', 'basic', 24, true);
        img.animation.addByPrefix('white', 'white', 24, true);
        img.animation.play('basic');
        add(img);
        img.antialiasing = ClientPrefs.data.antialiasing;
        img.scrollFactor.set(0, 0);
        images.push(img);
        objectsScale.push([img.scale.x, img.scale.y]);
        selectingObject.push(false);
    }

    Type.resolveEnum('flixel.text.FlxTextBorderStyle').OUTLINE;

    version = new FlxText(10, 0, 0, '');
    version.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, 'left');
    add(version);
    version.borderStyle = FlxTextBorderStyle.OUTLINE;
    version.borderSize = 1;
    version.borderColor = FlxColor.BLACK;
    version.antialiasing = ClientPrefs.data.antialiasing;
    version.applyMarkup(
        'Friday Night Funkin\' 0.2.8\nALE Engine *' + CoolVars.engineVersion + '* (P.E. 0.7.3)\nPress `CTRL + SHIFT + TAB` to `Select` the `Current Mod`',
        [
            new FlxTextFormatMarkerPair(new FlxTextFormat(CoolUtil.colorFromString('00FFFF')), '*'),
            new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromRGB(255, 125, 255)), '`')
        ]
    );
    version.scrollFactor.set(0, 0);
    version.y = FlxG.height - version.height - 10;

    for (i in 0...options.length)
    {
        images[i].centerOffsets();
        images[i].x = FlxG.width / 2 - images[i].width / 2;
        images[i].y = FlxG.height / (images.length + 1) * (i + 1) - images[i].height / 2;
    }

    if (LuaUtils.getBuildTarget() != 'android') changeShit();
}

var canSelect:Bool = true;

function onUpdate(elapsed:Float)
{
    if (LuaUtils.getBuildTarget() == 'android')
    {
        for (object in images)
        {
            object.scale.x = fpsLerp(object.scale.x, objectsScale[images.indexOf(object)][0], 0.3);
            object.scale.y = fpsLerp(object.scale.y, objectsScale[images.indexOf(object)][1], 0.3);
    
            if (canSelect && FlxG.mouse.justPressed && FlxG.mouse.overlaps(object))
            {
                selectingObject[images.indexOf(object)] = true;
            } else if (FlxG.mouse.justReleased && !FlxG.mouse.overlaps(object) || !FlxG.mouse.overlaps(object)) {
                selectingObject[images.indexOf(object)] = false;
            }
    
            objectsScale[images.indexOf(object)][0] = selectingObject[images.indexOf(object)] ? 1.1 : 1;
            objectsScale[images.indexOf(object)][1] = selectingObject[images.indexOf(object)] ? 1.1 : 1;
        }
    }
    
    if (canSelect)
    {
        if (controls.BACK)
        {
            canSelect = false;

            FlxG.sound.play(Paths.sound('cancelMenu'));
    
            new FlxTimer().start(0.25, function(tmr:FlxTimer)
            {
                MusicBeatState.switchState(new ScriptState('introState', true));
            });

            setGlobalVar('mainMenuStateSelInt', selInt);
        }

        if (options.length > 1)
        {
            if (controls.UI_UP_P || controls.UI_DOWN_P || FlxG.mouse.wheel != 0)
            {
                if (controls.UI_UP_P || FlxG.mouse.wheel > 0)
                {
                    if (selInt > 0)
                    {
                        selInt -= 1;
                    } else if (selInt == 0) {
                        selInt = options.length - 1;
                    }
        
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                } else if (controls.UI_DOWN_P ||  FlxG.mouse.wheel < 0) {
                    if (selInt < options.length - 1)
                    {
                        selInt += 1;
                    } else if (selInt == options.length - 1) {
                        selInt = 0;
                    }
        
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                }
        
                changeShit();
            }
        }

        if (controls.ACCEPT ||(FlxG.mouse.justReleased && selectingObject.contains(true)))
        {
            if (ClientPrefs.data.flashing) FlxFlicker.flicker(magentaBg, 1.1, 0.15, false);

            if (buildTarget == 'android')
            {
                for (image in images)
                {
                    if (FlxG.mouse.overlaps(image)) selInt = images.indexOf(image);
                    changeShit();
                    selectingObject[images.indexOf(image)] = false;
                }
            }
            
            canSelect = false;

            for (i in 0...images.length)
            {
                if (i == selInt)
                {
                    if (ClientPrefs.data.flashing) FlxFlicker.flicker(images[i], 0, 0.05);
                } else {
                    FlxTween.tween(images[i], {alpha: 0}, 60 / Conductor.bpm, {ease: FlxEase.cubeIn});
                }
            }

            setGlobalVar('mainMenuStateSelInt', selInt);

            FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
        
            new FlxTimer().start(1, function(tmr:FlxTimer)
            {
                switch (selectedMenu)
                {
                    case 'storyMode':
                        MusicBeatState.switchState(new ScriptState('storyMenuState', true));
                    case 'freeplay':
                        MusicBeatState.switchState(new ScriptState('freeplayState', true));
                    case 'credits':
                        MusicBeatState.switchState(new ScriptState('creditsState', true));
                    case 'options':
                        MusicBeatState.switchState(new ScriptState('optionsState', true));
                }
            });
        }
	
        if (controls.justPressed('debug_1') && CoolVars.developerMode) MusicBeatState.switchState(new ScriptState('masterEditorMenu', true));
    }

    FlxG.camera.scroll.y = fpsLerp(FlxG.camera.scroll.y, (selInt + (options.length - 1) / 2) * 25, 0.1);
}

function changeShit()
{
    for (i in 0...options.length)
    {
        if (i == selInt)
        {
            images[i].animation.play('white');
            selectedMenu = options[i];
        } else {
            images[i].animation.play('basic');
        }
    
        images[i].centerOffsets();
        images[i].x = FlxG.width / 2 - images[i].width / 2;
        images[i].y = FlxG.height / (images.length + 1) * (i + 1) - images[i].height / 2;
    }
}