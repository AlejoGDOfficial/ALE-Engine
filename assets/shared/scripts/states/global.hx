import utils.mods.Mods;
import tjson.TJSON as Json;

function onCreate() Conductor.bpm = Reflect.hasField(CoolVars.gameData, 'bpm') ? CoolVars.gameData.bpm : 102;

var ignoreReset = ['editors/chartEditorList'];

function onUpdate(elapsed:Float)
{
	if ((ignoreReset.contains(ScriptState.targetFileName) ? FlxG.keys.justPressed.F5 : controls.RESET) && CoolVars.developerMode) resetScriptState();

    if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;

    FlxG.camera.zoom = fpsLerp(FlxG.camera.zoom, 1, 0.1);
}

function onBeatHit() if (ClientPrefs.data.camZooms && curBeat % 4 == 0) FlxG.camera.zoom += 0.01;