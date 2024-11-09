import backend.CoolUtil;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;

var scoreTxt:FlxText;
var botplayTxt:FlxText;

var tempScore:String;

function onCreatePost()
{
    iconP1.x = healthBar.barCenter + (150 * iconP1.scale.x - 150) / 2 - 25;
    iconP2.x = healthBar.barCenter - (150 * iconP2.scale.x) / 2 - 25 * 2;

    scoreTxt = new FlxText(0, healthBar.y + 40, FlxG.width, "", 20);
    scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, 'center');
    scoreTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
    scoreTxt.borderSize = 1;
    scoreTxt.borderColor = FlxColor.BLACK;
    scoreTxt.borderSize = 1.25;
    game.updateScore(false);
    uiGroup.add(scoreTxt);

    botplayTxt = new FlxText(400, 105, FlxG.width - 800, '' + getPhrase('playStateBotPlay'), 32);
    botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, 'center');
    botplayTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
    botplayTxt.borderSize = 1;
    botplayTxt.borderColor = FlxColor.BLACK;
    botplayTxt.borderSize = 1.25;
    botplayTxt.visible = cpuControlled;
    uiGroup.add(botplayTxt);

    if(ClientPrefs.data.downScroll)
        botplayTxt.y = 715;
    
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

function onBeatHit()
{
    iconP1.scale.set(1.2, 1.2);
    iconP1.updateHitbox();
    iconP2.scale.set(1.2, 1.2);
    iconP2.updateHitbox();
    updateIconsPosition(false);
}

function onUpdatePost(elapsed:Float)
{
    if (cpuControlled)
    {
        botplayTxt.visible = true;
    } else {
        botplayTxt.visible = false;
    }

    updateIconsScale();
    updateIconsPosition(true);
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

    fullComboFunction();
}    

function onRecalculateRating()
{
    if (scoreTxt != null)
    {
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
}

function updateIconsScale()
{
    iconP1.scale.set(fpsLerp(iconP1.scale.x, 1, 0.33), fpsLerp(iconP1.scale.y, 1, 0.33));
    iconP1.updateHitbox();

    iconP2.scale.set(fpsLerp(iconP2.scale.x, 1, 0.33), fpsLerp(iconP2.scale.y, 1, 0.33));
    iconP2.updateHitbox();
}

function updateIconsPosition(doLerp:Bool)
{
    iconP1.x = doLerp ? fpsLerp(iconP1.x, healthBar.barCenter + (150 * iconP1.scale.x - 150) / 2 - 25, 0.33) : healthBar.barCenter + (150 * iconP1.scale.x - 150) / 2 - 25;
    iconP2.x = doLerp ? fpsLerp(iconP2.x, healthBar.barCenter - (150 * iconP2.scale.x) / 2 - 25 * 2, 0.33) : healthBar.barCenter - (150 * iconP2.scale.x) / 2 - 25 * 2;
}

function fullComboFunction()
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