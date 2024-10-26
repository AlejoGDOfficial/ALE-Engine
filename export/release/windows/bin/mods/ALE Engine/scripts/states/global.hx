function onCreate()
{
    Conductor.bpm = 102;
}

function onUpdate(elapsed:Float)
{
	if (!ClientPrefs.data.noReset && controls.RESET)
	{
		resetScriptState();
	}

    FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, 0.1);
}

function onBeatHit()
{
    FlxG.camera.zoom += 0.01;
}