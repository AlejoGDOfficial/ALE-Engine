import backend.CoolUtil;

function onBeatHit()
{
    iconP1.scale.set(1.2, 1.2);
    iconP2.scale.set(1.2, 1.2);

    iconP1.updateHitbox();
    iconP2.updateHitbox();
}

function onUpdateScore(miss:Bool)
{
    var str:String = game.ratingName;

    if(totalPlayed != 0)
    {
        var percent:Float = CoolUtil.floorDecimal(game.ratingPercent * 100, 2);
        str = percent + ratingFC;
    }

    var tempScore:String;
    if(!instakillOnMiss) tempScore = getPhrase('playStateScoreTxt')[0] + songScore + ' | ' + getPhrase('playStateScoreTxt')[1] + songMisses + ' | ' + getPhrase('playStateScoreTxt')[2] + str;
    else tempScore = getPhrase('playStateScoreTxt')[0] + songScore + ' | ' + getPhrase('playStateScoreTxt')[2] + str;
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
    var iconOffset:Int = 26;
    iconP1.x = FlxMath.lerp(iconP1.x, healthBar.barCenter + (150 * iconP1.scale.x - 150) / 2 - iconOffset, 0.5);
    iconP2.x = FlxMath.lerp(iconP2.x, healthBar.barCenter - (150 * iconP2.scale.x) / 2 - iconOffset * 2, 0.5);
}