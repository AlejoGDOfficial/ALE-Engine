import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import backend.CoolUtil;

var texts:Array<FlxText>;

var options:Array<String> = [
    'Chart Editor',
    'Character Editor',
    'Stage Editor',
    'Menu Character Editor',
    'Dialogue Editor',
    'Dialogue Portrait Editor',
    'Note Splash Editor',
    'Show Console'
];

var bg:FlxSprite;

function onCreate()
{
    bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    add(bg);
    bg.color = 0xFF353535;

    texts = [];

    for (i in 0...options.length) {
        var text = new FlxText(30, 10 + (i * 87), 0, options[i]);
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

var selInt:Int;

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
        
            new FlxTimer().start(1, function(tmr:FlxTimer)
            {
                switch (selInt)
                {
                    case 0:
                        switchToSomeStates('ChartingState');
                    case 1:
                        switchToSomeStates('CharacterEditorState');
                    case 2:
                        switchToSomeStates('StageEditorState');
                    case 3:
                        switchToSomeStates('MenuCharacterEditorState');
                    case 4:
                        switchToSomeStates('DialogueEditorState');
                    case 5:
                        switchToSomeStates('DialogueCharacterEditorState');
                    case 6:
                        switchToSomeStates('NoteSplashEditorState');
                    case 7:
                        switchToScriptState('mainMenuState', true);
                        showConsole();
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
