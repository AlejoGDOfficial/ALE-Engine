package backend;

#if LUA_ALLOWED
import stateslua.*;
#else
import stateslua.LuaUtils;
import stateslua.HScript;
#end

#if SScript
import tea.SScript;
#end

import haxe.ds.StringMap;

import options.LanguageSubState;

class LanguageManager
{
    public function new() {}

    public static var phrases:Array<StringMap<Dynamic>> = [];
    public static var images:Array<StringMap<Dynamic>> = [];
    public static var sounds:Array<StringMap<Dynamic>> = [];
    public static var sparrowAtlases:Array<StringMap<Dynamic>> = [];
    public static var packerAtlases:Array<StringMap<Dynamic>> = [];
    public static var asepriteAtlases:Array<StringMap<Dynamic>> = [];
    public static var atlases:Array<StringMap<Dynamic>> = [];

    public static var languages:Array<String> = [];
    public static var suffixes:Array<String> = [];
    public static var curLanguage:String = ClientPrefs.data.language;

    #if LUA_ALLOWED public static var luaArray:Array<FunkinLua> = []; #end
    
    #if (LUA_ALLOWED || HSCRIPT_ALLOWED)
    private static var luaDebugGroup:FlxTypedGroup<stateslua.DebugLuaText>;
    #end

	#if HSCRIPT_ALLOWED
	public static var hscriptArray:Array<HScript> = [];
	public static var instancesExclude:Array<String> = [];
	#end

    public static function setLanguages(names:Array<String>, abbr:Array<String>)
    {
        languages = names;
        suffixes = abbr;
        LanguageSubState.languages = names;
    }

    public static function getSuffix()
    {
        var index:Int = languages.indexOf(curLanguage);

        return '_' + suffixes[index];
    }

    public static function setPhrase(id:String, texts:Array<String>)
    {
        var phraseData:StringMap<Dynamic> = new StringMap();

        phraseData.set('id', id);

        for (i in 0...texts.length)
        {
            phraseData.set('text_' + languages[i], texts[i]);
        }
        
        phrases.push(phraseData);
    }

    public static function getPhrase(funcID:String):Dynamic
    {
        for (phrase in phrases)
        {
            var id = phrase.get('id');
            var text = phrase.get('text_' + curLanguage);

            if (id == funcID)
            {
                return text;
            }
        }

        return 'No text found';
    }

    public static function setImage(id:String, paths:Array<String>)
    {
        var imageData:StringMap<Dynamic> = new StringMap();

        imageData.set('id', id);

        for (i in 0...paths.length)
        {
            imageData.set('image_' + languages[i], paths[i]);
        }
        
        images.push(imageData);
    }

    public static function getImage(funcID:String):Dynamic
    {
        for (image in images)
        {
            var id = image.get('id');
            var path = image.get('image_' + curLanguage);

            if (id == funcID)
            {
                return Paths.image(path);
            }
        }

        return 'ID not found';
    }

    public static function setSound(id:String, paths:Array<String>)
    {
        var soundData:StringMap<Dynamic> = new StringMap();

        soundData.set('id', id);

        for (i in 0...paths.length)
        {
            soundData.set('sound_' + languages[i], paths[i]);
        }
        
        sounds.push(soundData);
    }

    public static function getSound(funcID:String):Dynamic
    {
        for (sound in sounds)
        {
            var id = sound.get('id');
            var path = sound.get('sound_' + curLanguage);

            if (id == funcID)
            {
                return Paths.sound(path);
            }
        }

        return 'ID not found';
    }

    public static function setSparrowAtlas(id:String, paths:Array<String>)
    {
        var sparrowAtlasData:StringMap<Dynamic> = new StringMap();

        sparrowAtlasData.set('id', id);

        for (i in 0...paths.length)
        {
            sparrowAtlasData.set('sparrowAtlas_' + languages[i], paths[i]);
        }
        
        sparrowAtlases.push(sparrowAtlasData);
    }

    public static function getSparrowAtlas(funcID:String):Dynamic
    {
        for (sparrowAtlas in sparrowAtlases)
        {
            var id = sparrowAtlas.get('id');
            var path = sparrowAtlas.get('sparrowAtlas_' + curLanguage);

            if (id == funcID)
            {
                return Paths.getSparrowAtlas(path);
            }
        }

        return 'ID not found';
    }

    public static function setPackerAtlas(id:String, paths:Array<String>)
    {
        var packerAtlasData:StringMap<Dynamic> = new StringMap();

        packerAtlasData.set('id', id);

        for (i in 0...paths.length)
        {
            packerAtlasData.set('packerAtlas_' + languages[i], paths[i]);
        }
        
        packerAtlases.push(packerAtlasData);
    }

    public static function getPackerAtlas(funcID:String):Dynamic
    {
        for (packerAtlas in packerAtlases)
        {
            var id = packerAtlas.get('id');
            var path = packerAtlas.get('packerAtlas_' + curLanguage);

            if (id == funcID)
            {
                return Paths.getPackerAtlas(path);
            }
        }

        return 'ID not found';
    }

    public static function setAsepriteAtlas(id:String, paths:Array<String>)
    {
        var asepriteAtlasData:StringMap<Dynamic> = new StringMap();

        asepriteAtlasData.set('id', id);

        for (i in 0...paths.length)
        {
            asepriteAtlasData.set('asepriteAtlas_' + languages[i], paths[i]);
        }
        
        asepriteAtlases.push(asepriteAtlasData);
    }

    public static function getAsepriteAtlas(funcID:String):Dynamic
    {
        for (asepriteAtlas in asepriteAtlases)
        {
            var id = asepriteAtlas.get('id');
            var path = asepriteAtlas.get('asepriteAtlas_' + curLanguage);

            if (id == funcID)
            {
                return Paths.getAsepriteAtlas(path);
            }
        }

        return 'ID not found';
    }

    public static function setAtlas(id:String, paths:Array<String>)
    {
        var atlasData:StringMap<Dynamic> = new StringMap();

        atlasData.set('id', id);

        for (i in 0...paths.length)
        {
            atlasData.set('atlas_' + languages[i], paths[i]);
        }
        
        atlases.push(atlasData);
    }

    public static function getAtlas(funcID:String):Dynamic
    {
        for (atlas in atlases)
        {
            var id = atlas.get('id');
            var path = atlas.get('atlas_' + curLanguage);

            if (id == funcID)
            {
                return Paths.getAtlas(path);
            }
        }

        return 'ID not found';
    }

    public static function reloadLanguages()
    {
		#if LUA_ALLOWED startLuasNamed('scripts/config/config.lua'); #end
		#if HSCRIPT_ALLOWED startHScriptsNamed('scripts/config/config.hx'); #end

		callOnScripts('setupLanguages');
    }

	#if LUA_ALLOWED
	public static function startLuasNamed(luaFile:String)
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
	public static function startHScriptsNamed(scriptFile:String)
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

	public static function initHScript(file:String)
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

	public static function callOnScripts(funcToCall:String, args:Array<Dynamic> = null, ignoreStops = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
		var returnVal:Dynamic = LuaUtils.Function_Continue;
		if(args == null) args = [];
		if(exclusions == null) exclusions = [];
		if(excludeValues == null) excludeValues = [LuaUtils.Function_Continue];

		var result:Dynamic = callOnLuas(funcToCall, args, ignoreStops, exclusions, excludeValues);
		if(result == null || excludeValues.contains(result)) result = callOnHScript(funcToCall, args, ignoreStops, exclusions, excludeValues);
		return result;
	}

	public static function callOnLuas(funcToCall:String, args:Array<Dynamic> = null, ignoreStops = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
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

	public static function callOnHScript(funcToCall:String, args:Array<Dynamic> = null, ?ignoreStops:Bool = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
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

    #if (LUA_ALLOWED || HSCRIPT_ALLOWED)
    public static function addTextToDebug(text:String, color:FlxColor) 
    {
        var newText:stateslua.DebugLuaText = luaDebugGroup.recycle(stateslua.DebugLuaText);
        newText.text = text;
        newText.color = color;
        newText.disableTime = 6;
        newText.alpha = 1;
        newText.setPosition(10, 8 - newText.height);

        luaDebugGroup.forEachAlive(function(spr:stateslua.DebugLuaText) {
            spr.y += newText.height + 2;
        });
        luaDebugGroup.add(newText);

        Sys.println(text);
    }
    #end
}