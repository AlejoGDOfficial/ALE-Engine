import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import core.config.DiscordClient;

var texts:Array<Alphabet>;

var options:Array<String> = [
    'Chart Editor',
    'Character Editor',
    'Dialogue Editor',
    'Dialogue Portrait Editor',
    'Note Splash Editor',
    'Week Editor'
];

var bg:FlxSprite;

var selInt:Int = 0;

var consoleVisible:Bool = false;

function onCreate()
{
    DiscordClient.changePresence('In the Menus...', 'Master Editor Menu');

    if (CoolVars.isConsoleVisible) options.push('Hide Console');
    else options.push('Show Console');

    if (existsGlobalVar('masterEditorMenuSelInt'))
    {
        selInt = getGlobalVar('masterEditorMenuSelInt');
    }

    bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    add(bg);
    bg.antialiasing = ClientPrefs.data.antialiasing;
    bg.color = 0xFF353535;

    texts = [];

    for (i in 0...options.length) 
    {
        var text:Alphabet = new Alphabet(30, 0, options[i], true);
        text.snapToPosition();
        add(text);
        text.antialiasing = ClientPrefs.data.antialiasing;
        text.alpha = 0.25;
        text.y = FlxG.height / 2 - (text.height + 15) * options.length / 2 + (i * (text.height + 15));
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
            MusicBeatState.switchState(new ScriptState('mainMenuState'));

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

                switch (options[selInt])
                {
                    case 'Chart Editor':
                        MusicBeatState.switchState(new gameplay.states.editors.ChartingState());
                    case 'Character Editor':
                        MusicBeatState.switchState(new gameplay.states.editors.CharacterEditorState(null, false));
                    case 'Dialogue Editor':
                        MusicBeatState.switchState(new gameplay.states.editors.DialogueEditorState());
                    case 'Dialogue Portrait Editor':
                        MusicBeatState.switchState(new gameplay.states.editors.DialogueCharacterEditorState());
                    case 'Note Splash Editor':
                        MusicBeatState.switchState(new gameplay.states.editors.NoteSplashEditorState());
                    case 'Week Editor':
                        MusicBeatState.switchState(new gameplay.states.editors.WeekEditorState());
                    case 'Show Console':
                        showConsole();
                        MusicBeatState.switchState(new ScriptState('mainMenuState'));
                    case 'Hide Console':
                        hideConsole();
                        MusicBeatState.switchState(new ScriptState('mainMenuState'));
                }
            });
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
