function onCreate()
{
    Conductor.bpm = 102;
}

function onUpdate(elapsed:Float)
{
	if (controls.RESET)
	{
		resetScriptState();
	}

    if (FlxG.sound.music != null)
        Conductor.songPosition = FlxG.sound.music.time;

    FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, 0.1);
}

function onBeatHit()
{
    FlxG.camera.zoom += 0.01;
}