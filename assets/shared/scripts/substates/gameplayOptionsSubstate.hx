import visuals.objects.Alphabet;
import visuals.objects.AttachedSprite;

import haxe.ds.StringMap;

var options:Array<StringMap> = [];

function onCreate()
{
    var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    add(bg);
    bg.alpha = 0;
    FlxTween.tween(bg, {alpha: 0.5}, 30 / Conductor.bpm, {ease: FlxEase.cubeOut});

    var daOptions:Array<Array<String>> = [
        ['Practice Mode', 'practice'],
        ['Botplay', 'botplay']
    ];

    for (option in daOptions)
    {
        var optionData:StringMap<Dynamic> = new StringMap<Dynamic>();

        var text = new Alphabet(0, 0, option[0]);
        add(text);
        text.scaleX = text.scaleY = 0.75;
        text.alpha = 0.5;

        var checkBox:AttachedSprite = new AttachedSprite();
        checkBox.frames = Paths.getSparrowAtlas('checkboxanim');
        checkBox.animation.addByPrefix('start', 'start', 24, false);
        checkBox.animation.addByPrefix('finish', 'finish', 24, false);
        checkBox.animation.addByPrefix('true', 'true', 24, false);
        checkBox.animation.addByPrefix('false', 'false', 24, false);
        checkBox.animation.play(ClientPrefs.data.gameplaySettings.get(option[1]) ? 'start' : 'finish');
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
        add(checkBox);

        optionData.set('text', text);
        optionData.set('checkBox', checkBox);
        optionData.set('variable', option[1]);
        optionData.set('value', ClientPrefs.data.gameplaySettings.get(option[1]));

        options.push(optionData);
    }

    changeShit();
}

var selInt:Int = 0;

function onUpdatePost()
{
    if (controls.UI_UP_P || controls.UI_DOWN_P)
    {
        if (controls.UI_DOWN_P)
        {
            if (selInt >= options.length - 1) selInt = 0;
            else selInt++;
        }

        if (controls.UI_UP_P)
        {
            if (selInt <= 0) selInt = options.length - 1;
            else selInt--;
        }

        changeShit();
    }

    if (controls.ACCEPT)
    {
        switch (options[selInt].get('checkBox').animation.name)
        {
            case 'start', 'true':
                options[selInt].get('checkBox').animation.play('false');
                options[selInt].set('value', false);
            case 'finish', 'false':
                options[selInt].get('checkBox').animation.play('true');
                options[selInt].set('value', true);
        }

        ClientPrefs.data.gameplaySettings.set(options[selInt].get('variable'), options[selInt].get('value'));
    }

    if (controls.BACK)
    {
        ClientPrefs.saveSettings();

        close();
    }
}

function changeShit()
{
    for (option in options)
    {
        var text:Alphabet = option.get('text');

        if (options.indexOf(option) == selInt) text.alpha = 1;
        else text.alpha = 0.5;

        FlxTween.cancelTweensOf(text);
        FlxTween.tween(text, {x: 200 - 20 * Math.abs(options.indexOf(option) - selInt) * Math.abs(options.indexOf(option) - selInt) / 2, y: 330 + 100 * (options.indexOf(option) - selInt)}, 0.2, {ease: FlxEase.cubeOut});
    }
}