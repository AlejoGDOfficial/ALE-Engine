import tjson.TJSON as Json;

function onCreate()
{
    var jsonToLoad:String = Paths.modFolders('data.json');
    if(!FileSystem.exists(jsonToLoad))
        jsonToLoad = Paths.getSharedPath('data.json');

    var jsonData = Json.parse(File.getContent(jsonToLoad));

    Conductor.bpm = jsonData.bpm;
}

function onUpdate(elapsed:Float)
{
	if (controls.RESET)
	{
		resetScriptState();
	}

    if (FlxG.sound.music != null)
        Conductor.songPosition = FlxG.sound.music.time;

    FlxG.camera.zoom = fpsLerp(FlxG.camera.zoom, 1, 0.1);
}

function onBeatHit()
{
    if (ClientPrefs.data.camZooms) FlxG.camera.zoom += 0.01;
}