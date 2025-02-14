import core.gameplay.stages.WeekData;
import visuals.objects.Character;
import flixel.FlxObject;
import flixel.FlxSubState;
import gameplay.states.game.PlayState;
import utils.scripting.ScriptState;

var boyfriend:Character;
var camFollow:FlxObject;

var characterName:String = PlayState.SONG.stage == 'school' || PlayState.SONG.stage == 'schoolEvil' ? 'bf-pixel-dead' : 'bf-dead';
var deathSoundName:String = PlayState.SONG.stage == 'school' || PlayState.SONG.stage == 'schoolEvil' ? 'fnf_loss_sfx-pixel' : 'fnf_loss_sfx';
var loopSoundName:String = PlayState.SONG.stage == 'school' || PlayState.SONG.stage == 'schoolEvil' ? 'gameOver-pixel' : 'gameOver';
var endSoundName:String = PlayState.SONG.stage == 'school' || PlayState.SONG.stage == 'schoolEvil' ? 'gameOverEnd-pixel' : 'gameOverEnd';

var deathDelay:Float = 0;

var charX:Float = 0;
var charY:Float = 0;

var overlay:FlxSprite;
var overlayConfirmOffsets:Dynamic = {x: 0, y: 0};

var LOCKON;

function onCreate() 
{
    if (PlayState.instance.boyfriend != null && PlayState.instance.boyfriend.curCharacter == characterName) {
        boyfriend = PlayState.instance.boyfriend;
    }

    Conductor.songPosition = 0;

    if (boyfriend == null) 
	{
        boyfriend = new Character(PlayState.instance.boyfriend.getScreenPosition().x, PlayState.instance.boyfriend.getScreenPosition().y, characterName, true);
        boyfriend.x += boyfriend.positionArray[0] - PlayState.instance.boyfriend.positionArray[0];
        boyfriend.y += boyfriend.positionArray[1] - PlayState.instance.boyfriend.positionArray[1];
    }
    boyfriend.skipDance = true;
    add(boyfriend);

    FlxG.sound.play(Paths.sound(deathSoundName));
    FlxG.camera.scroll.set();
    FlxG.camera.target = null;

    boyfriend.playAnim('firstDeath');

    camFollow = new FlxObject(0, 0, 1, 1);
    camFollow.setPosition(boyfriend.getGraphicMidpoint().x + boyfriend.cameraPosition[0], boyfriend.getGraphicMidpoint().y + boyfriend.cameraPosition[1]);
    FlxG.camera.follow(camFollow, LOCKON, 2);
    add(camFollow);

    FlxG.sound.music.loadEmbedded(Paths.music(loopSoundName), true);
}

var isEnding:Bool = false;

function onUpdate(elapsed:Float) 
{
    var justPlayedLoop:Bool = false;

    if (boyfriend != null && boyfriend.animation != null && boyfriend.animation.name == 'firstDeath' && boyfriend.animation.finished)
	{
        boyfriend.playAnim('deathLoop');

        if (overlay != null && overlay.animation.exists('deathLoop'))
        {
            overlay.visible = true;
            overlay.animation.play('deathLoop');
        }

        justPlayedLoop = true;
    }

    if (!isEnding) 
	{
        if (controls.ACCEPT) 
		{
            endBullshit();
        } else if (controls.BACK) {
            FlxG.sound.music.stop();
            PlayState.deathCounter = 0;
            PlayState.seenCutscene = false;
            PlayState.chartingMode = false;

            if (PlayState.isStoryMode) MusicBeatState.switchState(new ScriptState(CoolVars.scriptFromPlayStateIfStoryMode));
            else MusicBeatState.switchState(new ScriptState(CoolVars.scriptFromPlayStateIfFreeplay));

            FlxG.sound.playMusic(Paths.music('freakyMenu'));
        } else if (justPlayedLoop) {
            switch(PlayState.SONG.stage)
            {
                case 'tank':
                    coolStartDeath(0.2);
                    
                    FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 25, [])), 1, false, null, true, function() {
                        if(!isEnding) FlxG.sound.music.fadeIn(0.2, 1, 4);
                    });
                default:
                    coolStartDeath(1);
            }
        }
    }

    if (FlxG.sound.music != null && FlxG.sound.music.playing)
	{
        Conductor.songPosition = FlxG.sound.music.time;
    }
}

function coolStartDeath(?volume:Float = 1):Void
{
	FlxG.sound.music.play(true);
	FlxG.sound.music.volume = volume;
}

function endBullshit():Void
{
    if (!isEnding && boyfriend != null) 
	{
        isEnding = true;
        boyfriend.playAnim('deathConfirm', true);

        if (overlay != null && overlay.animation.exists('deathConfirm')) 
		{
            overlay.visible = true;
            overlay.animation.play('deathConfirm');
            overlay.offset.set(overlayConfirmOffsets.x, overlayConfirmOffsets.y);
        }

        FlxG.sound.music.stop();
        FlxG.sound.play(Paths.music(endSoundName));

        new FlxTimer().start(0.7, function(tmr:FlxTimer)
		{
            FlxG.camera.fade(FlxColor.BLACK, 2, false, function() {
                MusicBeatState.resetState();
            });
        });
    }
}