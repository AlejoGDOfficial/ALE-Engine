import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;

var bg:FlxSprite;
var magentaBg:FlxSprite;

var storyModeImage:FlxSprite;
var freeplayImage:FlxSprite;
var optionsImage:FlxSprite;

var coolVersion:FlxText;

function onCreate()
{
    bg = new FlxSprite().loadGraphic(Paths.image('menuBGYellow'));
    add(bg);
    bg.scale.set(1.25, 1.25);
    bg.screenCenter('x');

    magentaBg = new FlxSprite().loadGraphic(Paths.image('menuBGMagenta'));
    add(magentaBg);
    magentaBg.scale.set(1.25, 1.25);
    magentaBg.screenCenter('x');
    magentaBg.visible = false;

    storyModeImage = new FlxSprite();
    storyModeImage.frames = Paths.getSparrowAtlas('mainMenuState/storyMode');
    storyModeImage.animation.addByPrefix('basic', 'basic', 24, true);
    storyModeImage.animation.addByPrefix('white', 'white', 24, true);
    storyModeImage.animation.play('basic');
    add(storyModeImage);

    freeplayImage = new FlxSprite();
    freeplayImage.frames = Paths.getSparrowAtlas('mainMenuState/freeplay');
    freeplayImage.animation.addByPrefix('basic', 'basic', 24, true);
    freeplayImage.animation.addByPrefix('white', 'white', 24, true);
    freeplayImage.animation.play('basic');
    add(freeplayImage);

    optionsImage = new FlxSprite();
    optionsImage.frames = Paths.getSparrowAtlas('mainMenuState/options');
    optionsImage.animation.addByPrefix('basic', 'basic', 24, true);
    optionsImage.animation.addByPrefix('white', 'white', 24, true);
    optionsImage.animation.play('basic');
    add(optionsImage);

    Type.resolveEnum('flixel.text.FlxTextBorderStyle').OUTLINE;

    coolVersion = new FlxText(10, 0, 0, 'Friday Night Funkin 0.3.0\nALE Engine EXPERIMENTAL (P.E. 1.0 Pre-Release)');
    coolVersion.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, 'left');
    add(coolVersion);
    coolVersion.y = FlxG.height - coolVersion.height - 10;
    coolVersion.borderStyle = FlxTextBorderStyle.OUTLINE;
    coolVersion.borderSize = 1;
    coolVersion.borderColor = FlxColor.BLACK;

    changeShit();
}

var selInt:Int = 0;

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
        }

        if (controls.UI_UP_P || controls.UI_DOWN_P || FlxG.mouse.wheel != 0)
        {
            if (controls.UI_UP_P || FlxG.mouse.wheel > 0)
            {
                if (selInt > 0)
                {
                    selInt -= 1;
                } else if (selInt == 0) {
                    selInt = 2;
                }
    
                FlxG.sound.play(Paths.sound('scrollMenu'));
            } else if (controls.UI_DOWN_P || FlxG.mouse.wheel < 0) {
                if (selInt < 2)
                {
                    selInt += 1;
                } else if (selInt == 2) {
                    selInt = 0;
                }
    
                FlxG.sound.play(Paths.sound('scrollMenu'));
            }

            changeShit();
        }

        if (controls.ACCEPT)
        {
            FlxFlicker.flicker(magentaBg, 1.1, 0.15, false);

            switch (selInt)
            {
                case 0:
                    FlxFlicker.flicker(storyModeImage, 0, 0.05);
                case 1:
                    FlxFlicker.flicker(freeplayImage, 0, 0.06);
                case 2:
                    FlxFlicker.flicker(optionsImage, 0, 0.06);
            }

            canSelect = false;

            if (selInt != 0)
            {
                FlxTween.tween(storyModeImage, {alpha: 0}, 60 / Conductor.bpm);
            }
            if (selInt != 1)
            {
                FlxTween.tween(freeplayImage, {alpha: 0}, 60 / Conductor.bpm);
            }
            if (selInt != 2)
            {
                FlxTween.tween(optionsImage, {alpha: 0}, 60 / Conductor.bpm);
            }

            FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
        
            new FlxTimer().start(1, function(tmr:FlxTimer)
            {
                switch (selInt)
                {
                    case 0:
                        switchToScriptState('storyMenuState', true);
                    case 1:
                        switchToScriptState('freeplayState', true);
                    case 2:
                        switchToSomeStates('OptionsState', true);
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
    if (selInt == 0)
    {
        storyModeImage.animation.play('white');
    } else {
        storyModeImage.animation.play('basic');
    }

    storyModeImage.centerOffsets();
    storyModeImage.x = FlxG.width / 2 - storyModeImage.width / 2;
    storyModeImage.y = FlxG.height / 4 - storyModeImage.height / 2;

    if (selInt == 1)
    {
        freeplayImage.animation.play('white');
    } else {
        freeplayImage.animation.play('basic');
    }

    freeplayImage.centerOffsets();
    freeplayImage.x = FlxG.width / 2 - freeplayImage.width / 2;
    freeplayImage.y = FlxG.height / 4 * 2 - freeplayImage.height / 2;

    if (selInt == 2)
    {
        optionsImage.animation.play('white');
    } else {
        optionsImage.animation.play('basic');
    }

    optionsImage.centerOffsets();
    optionsImage.x = FlxG.width / 2 - optionsImage.width / 2;
    optionsImage.y = FlxG.height / 4 * 3 - optionsImage.height / 2;

    FlxTween.cancelTweensOf(bg);
    FlxTween.tween(bg, {y: FlxG.height / 2 - bg.height / 2 - 25 * (selInt)}, 60 / Conductor.bpm, {ease: FlxEase.cubeOut});

    FlxTween.cancelTweensOf(magentaBg);
    FlxTween.tween(magentaBg, {y: FlxG.height / 2 - bg.height / 2 - 25 * (selInt)}, 60 / Conductor.bpm, {ease: FlxEase.cubeOut});
}