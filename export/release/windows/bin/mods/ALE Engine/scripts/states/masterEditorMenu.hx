import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import backend.DiscordClient;
import backend.CoolUtil;

var texts:Array<FlxText>;

var options:Array<String> = [
    'ChartEditor',
    'CharacterEditor',
    'StageEditor',
    'DialogueEditor',
    'DialoguePortraitEditor',
    'NoteSplashEditor',
    'LanguagesEditor'
];

var bg:FlxSprite;

var selInt:Int = 0;

var consoleVisible:Bool = false;

function onCreate()
{
    DiscordClient.changePresence('In the Menus...', 'Master Editor Menu');

    if (existsGlobalVar('consoleVisible') && getGlobalVar('consoleVisible'))
    {
        options.push('HideConsole');
    } else {
        options.push('ShowConsole');
    }

    if (existsGlobalVar('masterEditorMenuSelInt'))
    {
        selInt = getGlobalVar('masterEditorMenuSelInt');
    }

    bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    add(bg);
    bg.color = 0xFF353535;

    texts = [];

    for (i in 0...options.length) {
        var text = new FlxText(30, 18 + (i * 87), 0, getPhrase('masterEditorMenu', options[i]));
        text.setFormat(Paths.font('emptyPhantomMuff.ttf'), 70, FlxColor.WHITE, 'left');
        add(text);
        text.borderStyle = FlxTextBorderStyle.OUTLINE;
        text.borderSize = 3;
        text.borderColor = FlxColor.BLACK;
        text.alpha = 0.25;
        texts.push(text);
    }

    changeShit();
}

var canSelect:Bool = true;

function onUpdate(elapsed:Float)
{
    if (canSelect)
    {
        if (controls.BACK)
        {
            switchToScriptState('mainMenuState', true);

            FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);

            canSelect = false;

            setGlobalVar('masterEditorMenuSelInt', selInt);
        }

        if (controls.UI_UP_P || controls.UI_DOWN_P)
        {
            if (controls.UI_UP_P)
            {
                if (selInt > 0)
                {
                    selInt -= 1;
                } else if (selInt == 0) {
                    selInt = texts.length - 1;
                }
    
                FlxG.sound.play(Paths.sound('scrollMenu'));
            } else if (controls.UI_DOWN_P) {
                if (selInt < texts.length - 1)
                {
                    selInt += 1;
                } else if (selInt == texts.length -1) {
                    selInt = 0;
                }
    
                FlxG.sound.play(Paths.sound('scrollMenu'));
            }
    
            changeShit();
        }

        if (controls.ACCEPT)
        {
            if (selInt == 7)
            {
                FlxFlicker.flicker(texts[selInt], 1, 0.05);
            } else {
                canSelect = false;
                FlxFlicker.flicker(texts[selInt], 0, 0.05);
            }

            FlxTween.tween(texts[selInt], {x: FlxG.width / 2 - texts[selInt].width / 2}, 120 / Conductor.bpm, {ease: FlxEase.cubeOut});

            for (i in 0...texts.length)
            {
                if (i != selInt)
                {
                    FlxTween.tween(texts[i], {x: -15, alpha: 0}, 120 / Conductor.bpm, {ease: FlxEase.cubeOut});
                }
            }

            FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

            setGlobalVar('masterEditorMenuSelInt', selInt);
        
            new FlxTimer().start(1, function(tmr:FlxTimer)
            {
                if (selInt >= 0 && selInt < 7) FlxG.mouse.visible = true;

                switch (selInt)
                {
                    case 0:
                        switchToSomeStates('states.editors.ChartingState');
                    case 1:
                        switchToSomeStates('states.editors.CharacterEditorState');
                    case 2:
                        switchToSomeStates('states.editors.StageEditorState');
                    case 3:
                        switchToSomeStates('states.editors.DialogueEditorState');
                    case 4:
                        switchToSomeStates('states.editors.DialogueCharacterEditorState');
                    case 5:
                        switchToSomeStates('states.editors.NoteSplashEditorState');
                    case 6:
                        switchToSomeStates('states.editors.LanguagesEditorState');
                    case 7:
                        switchToScriptState('mainMenuState', true);
                        if (options[7] == 'HideConsole')
                        {
                            hideConsole();
                            setGlobalVar('consoleVisible', false);
                        } else if (options[7] == 'ShowConsole') {
                            showConsole();
                            setGlobalVar('consoleVisible', true);
                        }
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
    for (i in 0...texts.length)
    {
        FlxTween.cancelTweensOf(texts[i]);

        if (i == selInt)
        {
            texts[i].alpha = 1;
            FlxTween.tween(texts[i], {x: 100}, 30 / Conductor.bpm, {ease: FlxEase.cubeOut});
        }
        else
        {
            texts[i].alpha = 0.25;
            FlxTween.tween(texts[i], {x: 20}, 30 / Conductor.bpm, {ease: FlxEase.cubeOut});
        }
    }
}
