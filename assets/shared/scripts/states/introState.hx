import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import core.config.DiscordClient;

var skippedIntro:Bool = false;

var epicTexts:FlxText;

var logo:FlxSprite;
var gf:FlxSprite;
var titleText:FlxSprite;

function onCreate()
{
    DiscordClient.changePresence('In the Menus...', 'Intro Menu');

    epicTexts = new FlxText(0, 0, FlxG.width, '');
    epicTexts.setFormat(Paths.font('funkinRegular.otf'), 78, FlxColor.WHITE, 'center');
    add(epicTexts);
    epicTexts.antialiasing = ClientPrefs.data.antialiasing;
    epicTexts.y = FlxG.height / 2 - epicTexts.height / 2;
    changeShit('ALE ENGINE BY');

    logo = new FlxSprite(-125, -100);
    logo.frames = Paths.getSparrowAtlas('introState/logo');
    logo.animation.addByPrefix('bump', 'logo bumpin', 24, false);
    logo.animation.play('bump');
    add(logo);
    logo.antialiasing = ClientPrefs.data.antialiasing;
    logo.alpha = 0;

    gf = new FlxSprite(550, 40);
    gf.frames = Paths.getSparrowAtlas('introState/gf');
    gf.animation.addByIndices('danceLeft', 'gf', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
    gf.animation.addByIndices('danceRight', 'gf', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
    add(gf);
    gf.antialiasing = ClientPrefs.data.antialiasing;
    gf.alpha = 0;

    titleText = new FlxSprite(150, 576);
    titleText.frames = Paths.getSparrowAtlas('introState/titleEnter');
    titleText.animation.addByPrefix('idle', "IDLE", 24);
    titleText.animation.addByPrefix('press', "PRESSED", 24);
    titleText.animation.addByPrefix('freeze', "FREEZE", 24);
    add(titleText);
    titleText.antialiasing = ClientPrefs.data.antialiasing;
    titleText.animation.play('idle');
    titleText.centerOffsets();
    titleText.updateHitbox();

    titleText.alpha = 0;
    titleText.color = 0xFF33FFFF;
}

function onCreatePost()
{
    if (FlxG.sound.music == null)
    {
        FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);

        FlxTween.num(255, 32, 60 / Conductor.bpm, {ease: FlxEase.cubeOut}, windowColorTween);
    } else {
        skipIntro();
    }
}

function skipIntro()
{
    skippedIntro = true;
    changeShit('');
    gf.alpha = 1;
    logo.alpha = 1;
    titleText.alpha = 1;
}

var curTime:Float = 0;

var changingState:Bool = false;

var selectingObject:Bool = false;
var objectScale:Float = 1;

var canSelect = true;

function onUpdate(elapsed:Float)
{
    curTime += elapsed;

    titleText.scale.x = fpsLerp(titleText.scale.x, objectScale, 0.3);
    titleText.scale.y = fpsLerp(titleText.scale.y, objectScale, 0.3);

    if (buildTarget == 'android')
    {
        if (canSelect && FlxG.mouse.justPressed && FlxG.mouse.overlaps(titleText))
        {
            selectingObject = true;
        } else if (FlxG.mouse.justReleased && !FlxG.mouse.overlaps(titleText) || !FlxG.mouse.overlaps(titleText)) {
            selectingObject = false;
        }
    }

    objectScale = selectingObject ? 1.05 : 1;

    if (canSelect && (controls.ACCEPT || (FlxG.mouse.justReleased && selectingObject)) && !changingState)
    {
        if (skippedIntro)
        {
            titleText.animation.play(ClientPrefs.data.flashing ? 'press' : 'freeze');
            
            changingState = true;

            titleText.color = FlxColor.WHITE;
            titleText.alpha = 1;

            FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

            new FlxTimer().start(1.2, function(tmr:FlxTimer)
            {
                MusicBeatState.switchState(new ScriptState('mainMenuState', true));
            });

            selectingObject = false;
            canSelect = false;
        } else {
            FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : FlxColor.BLACK, ClientPrefs.data.flashing ? 3 : 1);
            skipIntro();
        }
    }

    if (skippedIntro && !changingState)
    {  
        titleText.alpha = 0.64 + Math.sin(curTime * 2) * 0.36;
    }
}

function changeShit(text:String)
{
    epicTexts.text = text;
    epicTexts.y = FlxG.height / 2 - epicTexts.height / 2;
}

var sickBeats:Float = 0;

var phrases:Array<String> = [
        "ALE ENGINE BY",
        "ALE ENGINE BY",
        "ALE ENGINE BY\nALEJOGDOFFICIAL",
        "",
        "POWERED BY",
        "POWERED BY",
        "POWERED BY\nPSYCH ENGINE",
        "",
        "DON'T TOUCH",
        "DON'T TOUCH",
        "DON'T TOUCH\nMY SOURCE CODE",
        "",
        "FRIDAY",
        "FRIDAY\nNIGHT",
        "FRIDAY\nNIGHT\nFUNKIN'",
        "FRIDAY\nNIGHT\nFUNKIN'\nALE ENGINE"
    ];

function onBeatHit()
{
    if(logo != null)
        logo.animation.play('bump', true);

    if (curBeat % 2 == 0)
    {
        gf.animation.play('danceRight');
    }
    if (curBeat % 2 == 1)
    {
        gf.animation.play('danceLeft');
    }

    sickBeats = sickBeats + 1;

    if (!skippedIntro)
    {
        changeShit(phrases[sickBeats]);

        if (sickBeats == 16)
        {
            FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : FlxColor.BLACK, ClientPrefs.data.flashing ? 3 : 1);
            skipIntro();
        }
    }
}

function windowColorTween(value:Float)
{
    setBorderColor(Math.floor(value), Math.floor(value), Math.floor(value));
}