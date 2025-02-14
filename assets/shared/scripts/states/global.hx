import utils.mods.Mods;
import tjson.TJSON as Json;

function onCreate() Conductor.bpm = Reflect.hasField(CoolVars.gameData, 'bpm') ? CoolVars.gameData.bpm : 102;

var ignoreReset = ['editors/chartEditorList', 'crashState', 'freeplayState'];

function onUpdate(elapsed:Float)
{
	if ((ignoreReset.contains(FlxG.state.targetFileName) ? FlxG.keys.justPressed.F5 : controls.RESET) && CoolVars.developerMode) resetScriptState();

    if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;
}