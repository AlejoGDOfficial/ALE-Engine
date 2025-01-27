import gameplay.states.game.PlayState;
import visuals.objects.Alphabet;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxGradient;
import flixel.ui.FlxButton;
import flixel.group.FlxTypedGroup;
import utils.scripting.ScriptSubstate;

import tjson.TJSON as Json;

var jaxyGradient:FlxSprite;
var jaxy:FlxTypedGroup<FlxSprite>;

var uhOhText:Alphabet;

function onCreate()
{
    FlxG.sound.playMusic(Paths.music('crash'));

    var errorGradient:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width / 2, FlxG.height, [FlxColor.fromRGB(50, 50, 125), FlxColor.fromRGB(125, 50, 50)]);
    errorGradient.scrollFactor.set();
    errorGradient.antialiasing = ClientPrefs.data.antialiasing;
    add(errorGradient);
    errorGradient.alpha = 0.1;

    var crashText = new Alphabet(0, 50, 'Game Crashed!', true);
    crashText.snapToPosition();
    crashText.antialiasing = ClientPrefs.data.antialiasing;
    crashText.scaleX = crashText.scaleY = 0.8;
    add(crashText);
    crashText.x = FlxG.width / 4 - crashText.width / 2;
    
    var blackGradient:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width / 2, 150, [FlxColor.TRANSPARENT, FlxColor.BLACK]);
    blackGradient.scrollFactor.set(0, -0.05);
    add(blackGradient);
    blackGradient.antialiasing = ClientPrefs.data.antialiasing;
    blackGradient.y = FlxG.height - blackGradient.height;

    printError();

    var closeButton = new FlxButton(0, 0, 'Close Game', Sys.exit);
    closeButton.scrollFactor.set(0, -0.05);
    closeButton.antialiasing = ClientPrefs.data.antialiasing;
    add(closeButton);
    closeButton.x = FlxG.width / 8 - closeButton.width / 2;
    closeButton.y = blackGradient.y + blackGradient.height / 2 - closeButton.height / 2;

    var restartButton = new FlxButton(0, 0, 'Reset Game', () -> {
        CoolUtil.resetEngine();
    });
    restartButton.scrollFactor.set(0, -0.05);
    restartButton.antialiasing = ClientPrefs.data.antialiasing;
    add(restartButton);
    restartButton.x = FlxG.width / 8 * 3 - restartButton.width / 2;
    restartButton.y = blackGradient.y + blackGradient.height / 2 - restartButton.height / 2;

    jaxyGradient = FlxGradient.createGradientFlxSprite(FlxG.width / 2, FlxG.height, [FlxColor.fromRGB(15, 0, 15), FlxColor.fromRGB(150, 150, 200)]);
    jaxyGradient.scrollFactor.set();
    jaxyGradient.antialiasing = ClientPrefs.data.antialiasing;
    add(jaxyGradient);
    jaxyGradient.x = FlxG.width - jaxyGradient.width;
    jaxyGradient.alpha = 0.25;

    jaxy = new FlxTypedGroup<FlxSprite>();
    add(jaxy);

    for (i in 0...2)
    {
        var image = new FlxSprite().loadGraphic(Paths.image('crashState/' + 'jaxon' + (i == 0 ? 'OG' : '')));
        image.scrollFactor.set(0, -0.01);
        if (i == 0)
        {
            image.alpha = 0.5;
            image.scale.x = image.scale.y = 0.75;
            image.updateHitbox();
        }
        image.antialiasing = ClientPrefs.data.antialiasing;
        image.x = FlxG.width - image.width - 115 * i;
        image.y = FlxG.height - image.height + 10;
        image.angle = 5;
        jaxy.add(image);
    }

    uhOhText = new Alphabet(FlxG.width / 2 + 100, 65, 'Uh-Oh!', true);
    uhOhText.scrollFactor.set(0, -0.01);
    uhOhText.snapToPosition();
    uhOhText.antialiasing = ClientPrefs.data.antialiasing;
    uhOhText.scaleX = uhOhText.scaleY = 0.8;
    add(uhOhText);
    uhOhText.angle = -10;
    
    var line:FlxSprite = new FlxSprite().makeGraphic(10, FlxG.width, FlxColor.WHITE);
    line.scrollFactor.set();
    add(line);
    line.x = FlxG.width / 2 - line.width / 2;
}

function onCreatePost()
{
    var dataJsonToLoad:String = Paths.modFolders('data.json');

    if(!FileSystem.exists(dataJsonToLoad))
        dataJsonToLoad = Paths.getSharedPath('data.json');

    var dataJson = Json.parse(File.getContent(dataJsonToLoad));

    Conductor.bpm = Reflect.hasField(dataJson, 'crashStateBpm') ? dataJson.crashStateBpm : 90;
}

function onBeatHit()
{
    if (curBeat % 4 == 0)
    {
        if (jaxy.length == 2)
        {
            var first = jaxy.members[0];
            var last = jaxy.members[1];

            jaxy.remove(first, false);
            jaxy.remove(last, false);

            jaxy.add(last);
            jaxy.add(first);
        }
    }
}

var curTime:Float = 0;

var camOffset = 0;
var mouseOffset = 0;

var textsHeight:Float = 150;

function onUpdate(elapsed:Float)
{
    curTime += elapsed;

    jaxyGradient.alpha = Math.sin(curTime * 0.5) * 0.05 + 0.20;

    if (jaxy.length == 2)
    {
        var firstImage = jaxy.members[0];
        firstImage.alpha = fpsLerp(firstImage.alpha, 0.5, 0.2);
        firstImage.scale.x = firstImage.scale.y = fpsLerp(firstImage.scale.x, 0.75, 0.1);
        firstImage.updateHitbox();
        firstImage.x = fpsLerp(firstImage.x, FlxG.width - firstImage.width + 15, 0.1);
        firstImage.y = fpsLerp(FlxG.height - firstImage.height + 10, 0.1);

        var secondImage = jaxy.members[1];
        secondImage.alpha = fpsLerp(secondImage.alpha, 1, 0.2);
        secondImage.scale.x = secondImage.scale.y = fpsLerp(secondImage.scale.x, 1, 0.1);
        secondImage.updateHitbox();
        secondImage.x = fpsLerp(secondImage.x, FlxG.width - secondImage.width - 115, 0.1);
        secondImage.y = fpsLerp(secondImage.y, FlxG.height - secondImage.height + 10, 0.1);
    }

    for (letter in uhOhText.members)
    {
        letter.y = 65 + Math.sin(curTime + uhOhText.members.indexOf(letter)) * 10;
        letter.x = FlxG.width / 2 + 70 + 45 * uhOhText.members.indexOf(letter) + Math.sin(curTime * 2 + uhOhText.members.indexOf(letter)) * 5;
    }

    if (FlxG.mouse.wheel != 0) camOffset += FlxG.mouse.wheel < 0 ? 50 : FlxG.mouse.wheel > 0 ? -50 : 0;
    else if (FlxG.mouse.justPressed) {
        mouseOffset = FlxG.mouse.y;
    } else if (FlxG.mouse.pressed) {
        camOffset -= FlxG.mouse.y - mouseOffset;
    }
    camOffset = FlxMath.bound(camOffset, 0, textsHeight + 150 > FlxG.height ? textsHeight - 600 : 0);

    FlxG.camera.scroll.y = fpsLerp(FlxG.camera.scroll.y, camOffset, 0.2);
}

function printError()
{
    var rpadLenght = '';

    for (data in error.trace)
    {
        switch (data.length)
        {
            case 2:
                if (data[0].length > rpadLenght.length) rpadLenght = data[0];
        }
    }
    
    var errorRpadLenght = '';

    for (data in error.trace)
    {
        switch (data.length)
        {
            case 2:
                var daString = StringTools.replace(StringTools.rpad(data[0], ' ', rpadLenght.length + 3), 'CLS:', '') + data[1];
                if (daString.length > errorRpadLenght.length) errorRpadLenght = daString;
        }
    }

    createErrorText('ALE Engine (' + CoolVars.engineVersion + ') Crash Handler | Error: \n\n' + error.message);
    createErrorText(' ');

    for (data in error.trace)
    {
        switch (data.length)
        {
            case 1:
                createErrorText(data[0]);
            case 2:
                createErrorText(StringTools.rpad(StringTools.replace(StringTools.rpad(data[0], ' ', rpadLenght.length + 3), 'CLS:', '') + data[1], ' ', errorRpadLenght.length));
            default:
                createErrorText(' ');
        }
    }

    createErrorText('');
    
    createErrorText('Runtime Information:');

    createErrorText('Time: ' + error.date.split(' ')[1] + '    Date: ' + error.date.split(' ')[0]);
    createErrorText('Mod: ' + error.activeMod + '    System: ' + error.systemName);
}

var yPos = 150;

function createErrorText(string:String)
{
    var text = new FlxText(0, yPos, FlxG.width / 2 - 100, string);
    text.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, 'center');
    add(text);
    text.antialiasing = ClientPrefs.data.antialiasing;
    text.updateHitbox();
    text.x = FlxG.width / 4 - text.width / 2;

    yPos += text.height + 5;

    textsHeight += text.height + 5;
}