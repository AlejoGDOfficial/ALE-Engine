function onCreate()
{
    Conductor.bpm = 102;
}

function onUpdate(elapsed:Float)
{
	if (FlxG.keys.justPressed.F5)
	{
		resetScriptState();
	}

    if (FlxG.sound.music != null)
        Conductor.songPosition = FlxG.sound.music.time;

    FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, Math.exp(-elapsed * 3.125));
}

function onBeatHit()
{
    FlxG.camera.zoom += 0.01;
}