import backend.Mods;
import backend.DiscordClient;
import objects.Alphabet;

var texts:Array<Alphabet> = [];

function onCreate()
{
    objects.AlphaCharacter.loadAlphabetData();

    backend.LanguageManager.loadPhrases();
    
    DiscordClient.changePresence('In the Menus...', 'Mods Menu');

    Mods.pushGlobalMods();

    var destinationY:Int = 0;

    for (mod in 0...2)
    {
        var text:Alphabet = new Alphabet(20, destinationY, 'mod', true);
        text.snapToPosition();
        add(text);
        destinationY += 100;
        texts.push(text);
    }

    changeShit();
}

var selInt:Int = 0;
var canSelect:Bool = true;

function onUpdate(elapsed:Float)
{
    if ((controls.UI_UP_P || controls.UI_DOWN_P) && canSelect)
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
        canSelect = false;

        FlxFlicker.flicker(texts[selInt], 0, 0.05);

        FlxTween.tween(texts[selInt], {x: FlxG.width / 2 - texts[selInt].width / 2}, 120 / Conductor.bpm, {ease: FlxEase.cubeOut});

        for (i in 0...texts.length)
        {
            if (i != selInt)
            {
                Mods.currentModDirectory = texts[i].text;
                FlxTween.tween(texts[i], {x: -15, alpha: 0}, 120 / Conductor.bpm, {ease: FlxEase.cubeOut});
            }
        }

        FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

        new FlxTimer().start(1, function(tmr:FlxTimer)
        {
            ScriptState.instance.openSubState(new substates.GameplayChangersSubstate());
        });
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