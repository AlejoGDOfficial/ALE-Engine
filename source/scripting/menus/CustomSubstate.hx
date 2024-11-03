package scripting.menus;

import flixel.FlxObject;

class CustomSubstate extends MusicBeatSubstate
{
	public static var name:String = 'unnamed';
	public static var instance:CustomSubstate;

	#if LUA_ALLOWED
	public static function implement(funk:FunkinLua)
	{
		var lua = funk.lua;
		Lua_helper.add_callback(lua, "openCustomSubstate", openCustomSubstate);
		Lua_helper.add_callback(lua, "closeCustomSubstate", closeCustomSubstate);
		Lua_helper.add_callback(lua, "insertToCustomSubstate", insertToCustomSubstate);
	}
	#end
	
	public static function openCustomSubstate(name:String, ?pauseGame:Bool = false)
	{
		if(pauseGame)
		{
			FlxG.camera.followLerp = 0;
			ScriptState.instance.persistentUpdate = false;
			ScriptState.instance.persistentDraw = true;
			if(FlxG.sound.music != null) {
				FlxG.sound.music.pause();
			}
		}
		ScriptState.instance.openSubState(new CustomSubstate(name));
		ScriptState.instance.setOnHScript('customSubstate', instance);
		ScriptState.instance.setOnHScript('customSubstateName', name);
	}

	public static function closeCustomSubstate()
	{
		if(instance != null)
		{
			ScriptState.instance.closeSubState();
			instance = null;
			return true;
		}
		return false;
	}

	public static function insertToCustomSubstate(tag:String, ?pos:Int = -1)
	{
		if(instance != null)
		{
			var tagObject:FlxObject = cast (MusicBeatState.getVariables().get(tag), FlxObject);
			#if LUA_ALLOWED if(tagObject == null) tagObject = cast (MusicBeatState.getVariables().get(tag), FlxObject); #end

			if(tagObject != null)
			{
				if(pos < 0) instance.add(tagObject);
				else instance.insert(pos, tagObject);
				return true;
			}
		}
		return false;
	}

	override function create()
	{
		instance = this;

		ScriptState.instance.callOnScripts('onCustomSubstateCreate', [name]);
		super.create();
		ScriptState.instance.callOnScripts('onCustomSubstateCreatePost', [name]);
	}
	
	public function new(name:String)
	{
		CustomSubstate.name = name;
		super();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}
	
	override function update(elapsed:Float)
	{
		ScriptState.instance.callOnScripts('onCustomSubstateUpdate', [name, elapsed]);
		super.update(elapsed);
		ScriptState.instance.callOnScripts('onCustomSubstateUpdatePost', [name, elapsed]);
	}

	override function destroy()
	{
		ScriptState.instance.callOnScripts('onCustomSubstateDestroy', [name]);
		name = 'unnamed';

		ScriptState.instance.setOnHScript('customSubstate', null);
		ScriptState.instance.setOnHScript('customSubstateName', name);
		super.destroy();
	}
}
