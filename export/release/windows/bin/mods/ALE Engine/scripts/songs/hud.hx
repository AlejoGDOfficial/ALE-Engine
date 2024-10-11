import backend.CoolUtil;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;

function onCreatePost()
{
    iconP1.x = healthBar.barCenter + (150 * iconP1.scale.x - 150) / 2 - 25;
    iconP2.x = healthBar.barCenter - (150 * iconP2.scale.x) / 2 - 25 * 2;

    game.scoreTxt = new FlxText(0, healthBar.y + 40, FlxG.width, "", 20);
    game.scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, 'center');
    game.scoreTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
    game.scoreTxt.borderSize = 1;
    game.scoreTxt.borderColor = FlxColor.BLACK;
    game.scoreTxt.borderSize = 1.25;
    game.uiGroup.add(game.scoreTxt);

    game.botplayTxt = new FlxText(400, 105, FlxG.width - 800, '' + getPhrase('playStateBotPlay'), 32);
    game.botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, 'center');
    game.botplayTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
    game.botplayTxt.borderSize = 1;
    game.botplayTxt.borderColor = FlxColor.BLACK;
    game.botplayTxt.borderSize = 1.25;
    game.botplayTxt.visible = cpuControlled;
    game.uiGroup.add(game.botplayTxt);

    if(ClientPrefs.data.downScroll)
        botplayTxt.y = 715;
}

function onBeatHit()
{
    iconP1.scale.set(1.2, 1.2);
    iconP2.scale.set(1.2, 1.2);

    iconP1.updateHitbox();
    iconP2.updateHitbox();
}

var tempScore:String;
var curTime:Float = 0;

function onUpdate(elapsed:Float)
{
    curTime += elapsed;

    if (cpuControlled)
    {
        botplayTxt.visible = true;
        botplayTxt.alpha = Math.sin(curTime * 2) * 0.5 + 0.5;
    } else {
        botplayTxt.visible = false;
    }

    scoreTxt.applyMarkup(
        tempScore,
        [
            new FlxTextFormatMarkerPair(new FlxTextFormat(CoolUtil.colorFromString('909090')), '*'),
            new FlxTextFormatMarkerPair(new FlxTextFormat(CoolUtil.colorFromString('FF00FF')), '#'),
            new FlxTextFormatMarkerPair(new FlxTextFormat(CoolUtil.colorFromString('00FFFF')), '&'),
            new FlxTextFormatMarkerPair(new FlxTextFormat(CoolUtil.colorFromString('00FF95')), '^'),
            new FlxTextFormatMarkerPair(new FlxTextFormat(CoolUtil.colorFromString('FFFF00')), '!'),
            new FlxTextFormatMarkerPair(new FlxTextFormat(CoolUtil.colorFromString('FF5F5F')), '~')
        ]
    );
}

public var ratingFC:String = '';

function onUpdateScore(miss:Bool)
{
    var accuracy:String = '-% *[' + getPhrase('playStateNA') + ']*';

    if(totalPlayed != 0)
    {
        var percent:Float = CoolUtil.floorDecimal(game.ratingPercent * 100, 2);
        accuracy = percent + '% - ' + ratingFC;
    }

    if (instakillOnMiss)
    {
        tempScore = getPhrase('playStateScoreTxt')[0] + songScore + '   ' + getPhrase('playStateScoreTxt')[2] + accuracy;
    } else {
        tempScore = getPhrase('playStateScoreTxt')[0] + songScore + '   ' + getPhrase('playStateScoreTxt')[1] + misses + '   ' + getPhrase('playStateScoreTxt')[2] + accuracy;
    }
    
}    

function onUpdateIconsScale(elapsed:Float)
{
    iconP1.scale.set(FlxMath.lerp(iconP1.scale.x, 1, 0.33), FlxMath.lerp(iconP1.scale.y, 1, 0.33));
    iconP1.updateHitbox();

    iconP2.scale.set(FlxMath.lerp(iconP2.scale.x, 1, 0.33), FlxMath.lerp(iconP2.scale.y, 1, 0.33));
    iconP2.updateHitbox();
}

function onUpdateIconsPosition()
{
    iconP1.x = FlxMath.lerp(iconP1.x, healthBar.barCenter + (150 * iconP1.scale.x - 150) / 2 - 25, 0.5);
    iconP2.x = FlxMath.lerp(iconP2.x, healthBar.barCenter - (150 * iconP2.scale.x) / 2 - 25 * 2, 0.5);
}

function onFullComboFunction()
{
    if (misses == 0)
    {
        if (bads > 0 || shits > 0) 
        {
            ratingFC = '^' + getPhrase('playStateFC') + '^';
        } else if (goods > 0) {
            ratingFC = '&' + getPhrase('playStateGFC') + '&';
        } else if (sicks > 0) {
            ratingFC = '#' + getPhrase('playStateSFC') + '#';
        }
    } else {
        if (misses < 10) ratingFC = '!' + getPhrase('playStateSDCB') + '!';
        else ratingFC = '~' + getPhrase('playStateClear') + '~';
    }
}