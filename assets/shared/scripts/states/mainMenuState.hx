import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import core.config.DiscordClient;
import core.config.ClientPrefs;
import options.OptionsState;
import gameplay.states.game.PlayState;

var bg:FlxSprite;
var magentaBg:FlxSprite;

var options:Array<String> = ['storyMode', 'freeplay', 'credits', 'options'];
var images:Array<FlxSprite> = [];

var selectedMenu:String;

var version:FlxText;

var selInt:Int = 0;

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
    }

    Type.resolveEnum('flixel.text.FlxTextBorderStyle').OUTLINE;

    version = new FlxText(10, 0, 0, '');
    version.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, 'left');
    add(version);
    version.borderStyle = FlxTextBorderStyle.OUTLINE;
    version.borderSize = 1;
    version.borderColor = FlxColor.BLACK;
    version.applyMarkup(
        'Friday Night Funkin\' 0.3.0\nALE Engine *' + CoolVars.engineVersion + '* (P.E. 1.0 Pre-Release)',
        [new FlxTextFormatMarkerPair(new FlxTextFormat(CoolUtil.colorFromString('FF00FF')), '*')]
    );
    version.scrollFactor.set(0, 0);
    version.y = FlxG.height - version.height - 10;

    changeShit();
}

var canSelect:Bool = true;

function onUpdate(elapsed:Float)
{
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

        if (controls.ACCEPT)
        {
            if (ClientPrefs.data.flashing) FlxFlicker.flicker(magentaBg, 1.1, 0.15, false);

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
                        MusicBeatState.switchState(new options.OptionsState());
                        OptionsState.onPlayState = false;
                        if (PlayState.SONG != null)
                        {
                            PlayState.SONG.arrowSkin = null;
                            PlayState.SONG.splashSkin = null;
                            PlayState.stageUI = 'normal';
                        }
                }
            });
        }
	
        if (controls.justPressed('debug_1'))
        {
            MusicBeatState.switchState(new ScriptState('masterEditorMenu', true));
        }
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