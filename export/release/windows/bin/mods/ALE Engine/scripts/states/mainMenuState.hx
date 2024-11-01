import backend.CoolUtil;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import cpp.*;
import backend.LanguageManager;
import backend.ClientPrefs;
import scripting.menus.CustomSubstate;

var bg:FlxSprite;
var magentaBg:FlxSprite;

var options:Array<String> = ['storyMode', 'freeplay', 'credits', 'options'];
var images:Array<FlxSprite> = [];

var selectedMenu:String;

var version:FlxText;

var selInt:Int = 0;

function onCreate()
{
    var blackBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    add(blackBg);
    blackBg.scrollFactor.set(0, 0);
    
    if (existsGlobalVar('mainMenuStateSelInt'))
    {
        selInt = getGlobalVar('mainMenuStateSelInt');
    }

    bg = new FlxSprite().loadGraphic(Paths.image('menuBGYellow'));
    add(bg);
    bg.scale.set(1.25, 1.25);
    bg.screenCenter('x');

    magentaBg = new FlxSprite().loadGraphic(Paths.image('menuBGMagenta'));
    add(magentaBg);
    magentaBg.scale.set(1.25, 1.25);
    magentaBg.screenCenter('x');
    magentaBg.visible = false;

    for (i in options)
    {
        var img = new FlxSprite();
        img.frames = Paths.getSparrowAtlas('mainMenuState/' + i + LanguageManager.getSuffix());
        img.animation.addByPrefix('basic', 'basic', 24, true);
        img.animation.addByPrefix('white', 'white', 24, true);
        img.animation.play('basic');
        add(img);
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
        'Friday Night Funkin\' 0.2.8\nALE Engine *' + getGlobalVar('engineVersion') + '* (P.E. 0.7.3)',
        [new FlxTextFormatMarkerPair(new FlxTextFormat(CoolUtil.colorFromString('FF0000')), '*')]
    );
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
                switchToScriptState('introState', true);
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
            FlxFlicker.flicker(magentaBg, 1.1, 0.15, false);

            canSelect = false;

            for (i in 0...images.length)
            {
                if (i == selInt)
                {
                    FlxFlicker.flicker(images[i], 0, 0.05);
                } else {
                    FlxTween.tween(images[i], {alpha: 0}, 60 / Conductor.bpm);
                }
            }

            setGlobalVar('mainMenuStateSelInt', selInt);

            FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
        
            new FlxTimer().start(1, function(tmr:FlxTimer)
            {
                switch (selectedMenu)
                {
                    case 'storyMode':
                        switchToScriptState('storyMenuState', true);
                    case 'freeplay':
                        switchToScriptState('freeplayState', true);
                    case 'credits':
                        switchToScriptState('creditsState', true);
                    case 'options':
                        switchToSomeStates('options.OptionsState', true);
                }
            });
        }
	
        if (controls.justPressed('debug_1'))
        {
            switchToScriptState('masterEditorMenu', true);
        }
    }
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

    FlxTween.cancelTweensOf(bg);
    FlxTween.tween(bg, {y: FlxG.height / 2 - bg.height / 2 - (25 * (selInt)) / options.length - 1}, 60 / Conductor.bpm, {ease: FlxEase.cubeOut});

    FlxTween.cancelTweensOf(magentaBg);
    FlxTween.tween(magentaBg, {y: FlxG.height / 2 - magentaBg.height / 2 - (25 * (selInt)) / options.length - 1}, 60 / Conductor.bpm, {ease: FlxEase.cubeOut});
}