package utils.scripting;

import openfl.utils.Assets as OpenFlAssets;
import flixel.util.FlxSave;

import visuals.objects.Character;

import options.*;
import gameplay.states.editors.*;

import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;

#if VIDEOS_ALLOWED
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#else import vlc.MP4Handler as VideoHandler; #end
#end

#if LUA_ALLOWED
import utils.scripting.states.*;
#end

#if SScript
import tea.SScript;
#end

class ScriptState extends MusicBeatState
{
    public static var targetFileName:String; 

    public function new(scriptName:String) 
    {
        super();

        targetFileName = scriptName;
    }

	public var runtimeShaders:Map<String, Array<String>> = new Map<String, Array<String>>();

    public static var instance:ScriptState;

    #if LUA_ALLOWED public var luaArray:Array<FunkinLua> = []; #end
    
    #if (LUA_ALLOWED || HSCRIPT_ALLOWED)
    private var luaDebugGroup:FlxTypedGroup<utils.scripting.states.DebugLuaText>;
    #end

	#if LUA_ALLOWED
	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, FlxText> = new Map<String, FlxText>();
	public var modchartSaves:Map<String, FlxSave> = new Map<String, FlxSave>();
	#end

	#if HSCRIPT_ALLOWED
	public var hscriptArray:Array<HScript> = [];
	public var instancesExclude:Array<String> = [];
	#end

	public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();

	var keysPressed:Array<Int> = [];
	private var keysArray:Array<String>;

    override public function create()
    {
		Paths.clearUnusedMemory();

        instance = this;

		#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
		luaDebugGroup = new FlxTypedGroup<utils.scripting.states.DebugLuaText>();
		add(luaDebugGroup);
		#end
		
		#if LUA_ALLOWED startLuasNamed('scripts/states/' + targetFileName + '.lua'); #end
		#if HSCRIPT_ALLOWED startHScriptsNamed('scripts/states/' + targetFileName + '.hx'); #end
		#if LUA_ALLOWED startLuasNamed('scripts/states/global.lua'); #end
		#if HSCRIPT_ALLOWED startHScriptsNamed('scripts/states/global.hx'); #end

		callOnScripts('onCreatePost');

        super.create();
    }

    override public function update(elapsed:Float)
    {
		callOnScripts('onUpdate', [elapsed]);

		if (FlxG.sound.music != null && FlxG.sound.music.looped) FlxG.sound.music.onComplete = fixMusic.bind();

		callOnScripts('onUpdatePost', [elapsed]);

        super.update(elapsed);
    }

	var lastStepHit:Int = -1;

	override function stepHit()
	{
		super.stepHit();

		if(curStep >= lastStepHit) {
			return;
		}

		lastStepHit = curStep;
		setOnScripts('curStep', curStep);
		callOnScripts('onStepHit');
	}

	var lastBeatHit:Int = -1;

	override function beatHit()
	{
		if(lastBeatHit >= curBeat) {
			return;
		}

		super.beatHit();

		lastBeatHit = curBeat;

		setOnScripts('curBeat', curBeat);
		callOnScripts('onBeatHit');
	}

	var lastSectionHit:Int = -1;

	override function sectionHit()
	{
		if (lastSectionHit >= curSection)
		{
			return;
		}

		super.sectionHit();

		setOnScripts('curSection', curSection);
		callOnScripts('onSectionHit');
	}

	function fixMusic()
	{
		MusicBeatState.instance.resetMusicVars();
		
		lastStepHit = -1;
		lastBeatHit = -1;
		lastSectionHit = -1;
	}

    #if (LUA_ALLOWED || HSCRIPT_ALLOWED)
    public function addTextToDebug(text:String, color:FlxColor) 
    {
        var newText:utils.scripting.states.DebugLuaText = luaDebugGroup.recycle(utils.scripting.states.DebugLuaText);
        newText.text = text;
        newText.color = color;
        newText.disableTime = 6;
        newText.alpha = 1;
        newText.setPosition(10, 8 - newText.height);

        luaDebugGroup.forEachAlive(function(spr:utils.scripting.states.DebugLuaText) {
            spr.y += newText.height + 2;
        });
        luaDebugGroup.add(newText);

        Sys.println(text);
    }
    #end

    public function getLuaObject(tag:String, text:Bool=true):FlxSprite
        return variables.get(tag);

	public static var inCutscene:Bool;

	public function startVideo(name:String)
	{
		#if VIDEOS_ALLOWED
		inCutscene = true;

		var filepath:String = Paths.video(name);
		#if sys
		if(!FileSystem.exists(filepath))
		#else
		if(!OpenFlAssets.exists(filepath))
		#end
		{
			FlxG.log.warn('Couldnt find video file: ' + name);
			return;
		}

		var video:VideoHandler = new VideoHandler();
			#if (hxCodec >= "3.0.0")
			// Recent versions
			video.play(filepath);
			video.onEndReached.add(function()
			{
				video.dispose();
				inCutscene = false;
				return;
			}, true);
			#else
			// Older versions
			video.playVideo(filepath);
			video.finishCallback = function()
			{
				inCutscene = false;
				return;
			}
			#end
		#else
		FlxG.log.warn('Platform not supported!');
		startAndEnd();
		return;
		#end
	}

	private function keyPressed(key:Int)
	{
		var ret:Dynamic = callOnScripts('onKeyPressPre', [key]);
		if(ret == LuaUtils.Function_Stop) return;

		if(!keysPressed.contains(key)) keysPressed.push(key);

		callOnScripts('onKeyPress', [key]);
	}

	private function keyReleased(key:Int)
	{
		var ret:Dynamic = callOnScripts('onKeyReleasePre', [key]);
		if(ret == LuaUtils.Function_Stop) return;

		callOnScripts('onKeyRelease', [key]);
	}

	private function keysCheck():Void
	{
		var holdArray:Array<Bool> = [];
		var pressArray:Array<Bool> = [];
		var releaseArray:Array<Bool> = [];
		for (key in keysArray)
		{
			holdArray.push(controls.pressed(key));
			if(controls.controllerMode)
			{
				pressArray.push(controls.justPressed(key));
				releaseArray.push(controls.justReleased(key));
			}
		}
	}

	override function destroy() {
		instance = null;

		#if LUA_ALLOWED
		for (lua in luaArray)
		{
			lua.call('onDestroy', []);
			lua.stop();
		}
		luaArray = null;
		FunkinLua.customFunctions.clear();
		#end

		#if HSCRIPT_ALLOWED
		for (script in hscriptArray)
			if(script != null)
			{
				script.call('onDestroy');
				script.destroy();
			}

		hscriptArray = null;
		#end
	}

	#if LUA_ALLOWED
	public function startLuasNamed(luaFile:String)
	{
		#if MODS_ALLOWED
		var luaToLoad:String = Paths.modFolders(luaFile);
		if(!FileSystem.exists(luaToLoad))
			luaToLoad = Paths.getSharedPath(luaFile);

		if(FileSystem.exists(luaToLoad))
		#elseif sys
		var luaToLoad:String = Paths.getSharedPath(luaFile);
		if(OpenFlAssets.exists(luaToLoad))
		#end
		{
			for (script in luaArray)
				if(script.scriptName == luaToLoad) return false;

			new FunkinLua(luaToLoad);
			return true;
		}
		return false;
	}
	#end

	#if HSCRIPT_ALLOWED
	public function startHScriptsNamed(scriptFile:String)
	{
		#if MODS_ALLOWED
		var scriptToLoad:String = Paths.modFolders(scriptFile);
		if(!FileSystem.exists(scriptToLoad))
			scriptToLoad = Paths.getSharedPath(scriptFile);
		#else
		var scriptToLoad:String = Paths.getSharedPath(scriptFile);
		#end

		if(FileSystem.exists(scriptToLoad))
		{
			if (SScript.global.exists(scriptToLoad)) return false;

			initHScript(scriptToLoad);
			return true;
		}
		return false;
	}

	public function initHScript(file:String)
	{
		try
		{
			var newScript:HScript = new HScript(null, file);
			if(newScript.parsingException != null)
			{
				addTextToDebug('ERROR ON LOADING: ${newScript.parsingException.message}', FlxColor.RED);
				newScript.destroy();
				return;
			}

			hscriptArray.push(newScript);
			if(newScript.exists('onCreate'))
			{
				var callValue = newScript.call('onCreate');
				if(!callValue.succeeded)
				{
					for (e in callValue.exceptions)
					{
						if (e != null)
						{
							var len:Int = e.message.indexOf('\n') + 1;
							if(len <= 0) len = e.message.length;
								addTextToDebug('ERROR ($file: onCreate) - ${e.message.substr(0, len)}', FlxColor.RED);
						}
					}

					newScript.destroy();
					hscriptArray.remove(newScript);
					trace('failed to initialize tea interp!!! ($file)');
				}
				else trace('initialized tea interp successfully: $file');
			}

		}
		catch(e)
		{
			var len:Int = e.message.indexOf('\n') + 1;
			if(len <= 0) len = e.message.length;
			addTextToDebug('ERROR - ' + e.message.substr(0, len), FlxColor.RED);
			var newScript:HScript = cast (SScript.global.get(file), HScript);
			if(newScript != null)
			{
				newScript.destroy();
				hscriptArray.remove(newScript);
			}
		}
	}
	#end

	public function callOnScripts(funcToCall:String, args:Array<Dynamic> = null, ignoreStops = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
		var returnVal:Dynamic = LuaUtils.Function_Continue;
		if(args == null) args = [];
		if(exclusions == null) exclusions = [];
		if(excludeValues == null) excludeValues = [LuaUtils.Function_Continue];

		var result:Dynamic = callOnLuas(funcToCall, args, ignoreStops, exclusions, excludeValues);
		if(result == null || excludeValues.contains(result)) result = callOnHScript(funcToCall, args, ignoreStops, exclusions, excludeValues);
		return result;
	}

	public function callOnLuas(funcToCall:String, args:Array<Dynamic> = null, ignoreStops = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
		var returnVal:Dynamic = LuaUtils.Function_Continue;
		#if LUA_ALLOWED
		if(args == null) args = [];
		if(exclusions == null) exclusions = [];
		if(excludeValues == null) excludeValues = [LuaUtils.Function_Continue];

		var arr:Array<FunkinLua> = [];
		for (script in luaArray)
		{
			if(script.closed)
			{
				arr.push(script);
				continue;
			}

			if(exclusions.contains(script.scriptName))
				continue;

			var myValue:Dynamic = script.call(funcToCall, args);
			if((myValue == LuaUtils.Function_StopLua || myValue == LuaUtils.Function_StopAll) && !excludeValues.contains(myValue) && !ignoreStops)
			{
				returnVal = myValue;
				break;
			}

			if(myValue != null && !excludeValues.contains(myValue))
				returnVal = myValue;

			if(script.closed) arr.push(script);
		}

		if(arr.length > 0)
			for (script in arr)
				luaArray.remove(script);
		#end
		return returnVal;
	}

	public function callOnHScript(funcToCall:String, args:Array<Dynamic> = null, ?ignoreStops:Bool = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
		var returnVal:Dynamic = LuaUtils.Function_Continue;

		#if HSCRIPT_ALLOWED
		if(exclusions == null) exclusions = new Array();
		if(excludeValues == null) excludeValues = new Array();
		excludeValues.push(LuaUtils.Function_Continue);

		var len:Int = hscriptArray.length;
		if (len < 1)
			return returnVal;
		for(i in 0...len) {
			var script:HScript = hscriptArray[i];
			if(script == null || !script.exists(funcToCall) || exclusions.contains(script.origin))
				continue;

			var myValue:Dynamic = null;
			try {
				var callValue = script.call(funcToCall, args);
				if(!callValue.succeeded)
				{
					var e = callValue.exceptions[0];
					if(e != null)
					{
						var len:Int = e.message.indexOf('\n') + 1;
						if(len <= 0) len = e.message.length;
						addTextToDebug('ERROR (${callValue.calledFunction}) - ' + e.message.substr(0, len), FlxColor.RED);
					}
				}
				else
				{
					myValue = callValue.returnValue;

					// compiler fuckup fix
					final stopHscript = myValue == LuaUtils.Function_StopHScript;
					final stopAll = myValue == LuaUtils.Function_StopAll;
					if((stopHscript || stopAll) && !excludeValues.contains(myValue) && !ignoreStops)
					{
						returnVal = myValue;
						break;
					}

					if(myValue != null && !excludeValues.contains(myValue))
						returnVal = myValue;
				}
			}
			catch (e:Dynamic) {}
		}
		#end

		return returnVal;
	}

	public function setOnScripts(variable:String, arg:Dynamic, exclusions:Array<String> = null) {
		if(exclusions == null) exclusions = [];
		setOnLuas(variable, arg, exclusions);
		setOnHScript(variable, arg, exclusions);
	}

	public function setOnLuas(variable:String, arg:Dynamic, exclusions:Array<String> = null) {
		#if LUA_ALLOWED
		if(exclusions == null) exclusions = [];
		for (script in luaArray) {
			if(exclusions.contains(script.scriptName))
				continue;

			script.set(variable, arg);
		}
		#end
	}

	public function setOnHScript(variable:String, arg:Dynamic, exclusions:Array<String> = null) {
		#if HSCRIPT_ALLOWED
		if(exclusions == null) exclusions = [];
		for (script in hscriptArray) {
			if(exclusions.contains(script.origin))
				continue;

			if(!instancesExclude.contains(variable))
				instancesExclude.push(variable);
			script.set(variable, arg);
		}
		#end
	}

	public function createRuntimeShader(name:String):FlxRuntimeShader
	{
		if(!ClientPrefs.data.shaders) return new FlxRuntimeShader();

		#if (!flash && MODS_ALLOWED && sys)
		if(!runtimeShaders.exists(name) && !initLuaShader(name))
		{
			FlxG.log.warn('Shader $name is missing!');
			return new FlxRuntimeShader();
		}

		var arr:Array<String> = runtimeShaders.get(name);
		return new FlxRuntimeShader(arr[0], arr[1]);
		#else
		FlxG.log.warn("Platform unsupported for Runtime Shaders!");
		return null;
		#end
	}

	public function initLuaShader(name:String, ?glslVersion:Int = 120)
	{
		if(!ClientPrefs.data.shaders) return false;

		#if (MODS_ALLOWED && !flash && sys)
		if(runtimeShaders.exists(name))
		{
			FlxG.log.warn('Shader $name was already initialized!');
			return true;
		}

		for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'shaders/'))
		{
			var frag:String = folder + name + '.frag';
			var vert:String = folder + name + '.vert';
			var found:Bool = false;
			if(FileSystem.exists(frag))
			{
				frag = File.getContent(frag);
				found = true;
			}
			else frag = null;

			if(FileSystem.exists(vert))
			{
				vert = File.getContent(vert);
				found = true;
			}
			else vert = null;

			if(found)
			{
				runtimeShaders.set(name, [frag, vert]);
				//trace('Found shader $name!');
				return true;
			}
		}
			#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
			addTextToDebug('Missing shader $name .frag AND .vert files!', FlxColor.RED);
			#else
			FlxG.log.warn('Missing shader $name .frag AND .vert files!');
			#end
		#else
		FlxG.log.warn('This platform doesn\'t support Runtime Shaders!');
		#end
		return false;
	}

    public function switchToScriptState(name:String, ?doTransition:Bool = true)
    {
		FlxTransitionableState.skipNextTransIn = !doTransition;
		FlxTransitionableState.skipNextTransOut = !doTransition;

		MusicBeatState.switchState(new ScriptState(name));
    }

	public function resetScriptState(?doTransition:Bool = false)
	{
		switchToScriptState(targetFileName, doTransition);
	}

	public function switchToSomeStates(state:String)
	{
		switch (state)
		{
			case 'options.OptionsState':
				MusicBeatState.switchState(new OptionsState());
				OptionsState.onPlayState = false;
				if (PlayState.SONG != null)
				{
					PlayState.SONG.arrowSkin = null;
					PlayState.SONG.splashSkin = null;
					PlayState.stageUI = 'normal';
				}
			case 'states.editors.ChartingState':
				LoadingState.loadAndSwitchState(new ChartingState(), false);
			case 'states.editors.CharacterEditorState':
				LoadingState.loadAndSwitchState(new CharacterEditorState(Character.DEFAULT_CHARACTER, false));
			case 'states.editors.WeekEditorState':
				LoadingState.loadAndSwitchState(new WeekEditorState());
			case 'states.editors.MenuCharacterEditorState':
				MusicBeatState.switchState(new MenuCharacterEditorState());
			case 'states.editors.DialogueEditorState':
				LoadingState.loadAndSwitchState(new DialogueEditorState(), false);
			case 'states.editors.DialogueCharacterEditorState':
				LoadingState.loadAndSwitchState(new DialogueCharacterEditorState(), false);
			case 'states.editors.NoteSplashEditorState':
				MusicBeatState.switchState(new NoteSplashEditorState());
		}
	}

	public function openSomeSubStates(subState:String)
	{
		switch (subState)
		{
			case 'substates.GameplayChangersSubstate':
				openSubState(new gameplay.states.substates.GameplayChangersSubstate());
		}
	}

	/*
	public function openScriptSubState(subState:String)
	{
		openSubState(new ScriptSubstate(subState));
	}
	*/
}