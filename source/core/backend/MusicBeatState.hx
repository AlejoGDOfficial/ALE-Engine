package core.backend;

import flixel.addons.ui.FlxUIState;
import flixel.FlxState;
import visuals.ALECamera;
import game.substates.ScriptTransition;

#if cpp import cpp.vm.Gc; #end

@:access(utils.helpers.CoolVars)
class MusicBeatState extends FlxUIState
{
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;

	public function resetMusicVars()
	{
		curSection = 0;
		stepsToDo = 0;
	
		curStep = 0;
		curBeat = 0;
	
		curDecStep = 0;
		curDecBeat = 0;
	}

	public var controls(get, never):Controls;
	private function get_controls()
	{
		return Controls.instance;
	}

	public static var instance:MusicBeatState;

	var _psychCameraInitialized:Bool = false;

	override function create() {
		instance = this;

		CoolVars.setGameData();

		if(!_psychCameraInitialized) initALECamera();

		if (game.substates.ScriptTransition.instance != null) game.substates.ScriptTransition.instance.close();

		if (!CoolVars.skipTransOut) 
		{
			openSubState(new ScriptTransition(false));
		}

		CoolVars.skipTransOut = false;
		CoolVars.transitionOut = CoolVars.scriptTransition;

		timePassedOnState = 0;

		super.create();
	}

	override function destroy()
	{
		instance = null;

		var killZombies:Bool = true;

		while (killZombies)
		{
			var zombie = Gc.getNextZombie();

			if (zombie == null)
				killZombies = false;
		
			var closeMethod = Reflect.field(zombie, "close");

			if (closeMethod != null && Reflect.isFunction(closeMethod))
				closeMethod.call(zombie, []);
		}

		Gc.run(true);
		Gc.compact();
		
		FlxG.bitmap.clearUnused;
		FlxG.bitmap.clearCache;

		super.destroy();
	}

	public function initALECamera():ALECamera
	{
		var camera = new ALECamera();
		FlxG.cameras.reset(camera);
		FlxG.cameras.setDefaultDrawTarget(camera, true);
		_psychCameraInitialized = true;
		
		return camera;
	}

	public static var timePassedOnState:Float = 0;
	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;
		timePassedOnState += elapsed;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if(curStep > 0)
				stepHit();

			if(PlayState.SONG != null)
			{
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}

		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;
		
		stagesFunc(function(stage:BaseStage) {
			stage.update(elapsed);
		});

		super.update(elapsed);
	}

	private function updateSection():Void
	{
		if(stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while(curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	private function rollbackSection():Void
	{
		if(curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;
				
				curSection++;
			}
		}

		if(curSection > lastSection) sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.data.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public static function switchState(nextState:FlxState = null)
	{
		if(nextState == null) nextState = FlxG.state;

		if(nextState == FlxG.state)
		{
			resetState();
			return;
		}

		if(CoolVars.skipTransIn) FlxG.switchState(nextState);
		else startTransition(nextState);

		CoolVars.skipTransIn = false;
		CoolVars.transitionIn = CoolVars.scriptTransition;
	}

	public static function resetState()
	{
		if(CoolVars.skipTransIn) FlxG.resetState();
		else startTransition();

		CoolVars.skipTransIn = false;
		CoolVars.transitionIn = CoolVars.scriptTransition;
	}

	public static function startTransition(nextState:FlxState = null)
	{
		if (game.substates.ScriptTransition.instance != null) game.substates.ScriptTransition.instance.close();
		
		if(nextState == null) nextState = FlxG.state;

		FlxG.state.openSubState(new ScriptTransition(true));

		if (nextState == FlxG.state) ScriptTransition.finishCallback = function() FlxG.resetState();
		else ScriptTransition.finishCallback = function() FlxG.switchState(nextState);
	}

	public function transitionStart() {}

	public function transitionEnd() {}

	public static function getState():MusicBeatState {
		return cast (FlxG.state, MusicBeatState);
	}

	public function stepHit():Void
	{
		stagesFunc(function(stage:BaseStage) {
			stage.curStep = curStep;
			stage.curDecStep = curDecStep;
			stage.stepHit();
		});

		if (curStep % 4 == 0)
			beatHit();
	}

	public var stages:Array<BaseStage> = [];
	public function beatHit():Void
	{
		//trace('Beat: ' + curBeat);
		stagesFunc(function(stage:BaseStage) {
			stage.curBeat = curBeat;
			stage.curDecBeat = curDecBeat;
			stage.beatHit();
		});
	}

	public function sectionHit():Void
	{
		//trace('Section: ' + curSection + ', Beat: ' + curBeat + ', Step: ' + curStep);
		stagesFunc(function(stage:BaseStage) {
			stage.curSection = curSection;
			stage.sectionHit();
		});
	}

	function stagesFunc(func:BaseStage->Void)
	{
		for (stage in stages)
			if(stage != null && stage.exists && stage.active)
				func(stage);
	}

	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
}
