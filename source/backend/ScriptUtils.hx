package backend;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.animation.FlxAnimationController;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import openfl.events.KeyboardEvent;
import haxe.Json;

import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;

import objects.VideoSprite;

#if LUA_ALLOWED
import stateslua.*;
#else
import stateslua.LuaUtils;
import stateslua.HScript;
#end

#if SScript
import tea.SScript;
#end

class ScriptUtils {
    public var paths:String; 
    public var runtimeShaders:Map<String, Array<String>> = new Map<String, Array<String>>();
    public var videoCutscene:VideoSprite = null;

    public static var instance:ScriptUtils;

    #if LUA_ALLOWED public var luaArray:Array<FunkinLua> = []; #end
    
    #if (LUA_ALLOWED || HSCRIPT_ALLOWED)
    private var luaDebugGroup:FlxTypedGroup<stateslua.DebugLuaText>;
    #end

    #if HSCRIPT_ALLOWED
    public var hscriptArray:Array<HScript> = [];
    public var instancesExclude:Array<String> = [];
    #end

    var keysPressed:Array<Int> = [];
    private var keysArray:Array<String>;

    public function new(scriptName:String) {
        paths = scriptName;
    }

    public function create() {
        instance = this;
        #if (LUA_ALLOWED || HSCRIPT_ALLOWED)
        luaDebugGroup = new FlxTypedGroup<stateslua.DebugLuaText>();
        #end
        
        #if LUA_ALLOWED startLuasNamed(paths); #end
        #if HSCRIPT_ALLOWED startHScriptsNamed(paths); #end
        callOnScripts('onCreatePost');
    }

    public function update(elapsed:Float) {
        callOnScripts('onUpdate', [elapsed]);
        callOnScripts('onUpdatePost', [elapsed]);
    }

    public function stepHit(curStep:Int, lastStepHit:Int) {
        if (curStep == lastStepHit) {
            return lastStepHit;
        }
        lastStepHit = curStep;
        setOnScripts('curStep', curStep);
        callOnScripts('onStepHit');
        return lastStepHit;
    }

    public function beatHit(curBeat:Int, lastBeatHit:Int) {
        if (lastBeatHit >= curBeat) {
            return lastBeatHit;
        }
        lastBeatHit = curBeat;
        setOnScripts('curBeat', curBeat);
        callOnScripts('onBeatHit');
        return lastBeatHit;
    }

    public function sectionHit(curSection:Int) {
        setOnScripts('curSection', curSection);
        callOnScripts('onSectionHit');
    }

    public function addTextToDebug(text:String, color:FlxColor) {
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

    public function getLuaObject(tag:String, text:Bool=true):FlxSprite {
        return variables.get(tag);
    }

    public function startVideo(name:String, forMidSong:Bool = false, canSkip:Bool = true, loop:Bool = false, playOnLoad:Bool = true):VideoSprite {
        var foundFile:Bool = false;
        var fileName:String = Paths.video(name);

        #if sys
        if (FileSystem.exists(fileName))
        #else
        if (OpenFlAssets.exists(fileName))
        #end
        foundFile = true;

        if (foundFile) {
            videoCutscene = new VideoSprite(fileName, forMidSong, canSkip, loop);
            if (!forMidSong) {
                function onVideoEnd() {
                    videoCutscene = null;
                }
                videoCutscene.finishCallback = onVideoEnd;
                videoCutscene.onSkip = onVideoEnd;
            }
            if (playOnLoad)
                videoCutscene.videoSprite.play();
            return videoCutscene;
        }
        return null;
    }

    public function keyPressed(key:Int) {
        var ret:Dynamic = callOnScripts('onKeyPressPre', [key]);
        if (ret == LuaUtils.Function_Stop) return;
        if (!keysPressed.contains(key)) keysPressed.push(key);
        callOnScripts('onKeyPress', [key]);
    }

    public function keyReleased(key:Int) {
        var ret:Dynamic = callOnScripts('onKeyReleasePre', [key]);
        if (ret == LuaUtils.Function_Stop) return;
        callOnScripts('onKeyRelease', [key]);
    }

    public function keysCheck():Void {
        var holdArray:Array<Bool> = [];
        var pressArray:Array<Bool> = [];
        var releaseArray:Array<Bool> = [];
        for (key in keysArray) {
            holdArray.push(controls.pressed(key));
            if (controls.controllerMode) {
                pressArray.push(controls.justPressed(key));
                releaseArray.push(controls.justReleased(key));
            }
        }
    }

    public function destroy() {
        #if LUA_ALLOWED
        for (lua in luaArray) {
            lua.call('onDestroy', []);
            lua.stop();
        }
        luaArray = null;
        FunkinLua.customFunctions.clear();
        #end

        #if HSCRIPT_ALLOWED
        for (script in hscriptArray)
            if(script != null) {
                script.call('onDestroy');
                script.destroy();
            }
        hscriptArray = null;
        #end
    }

    public function startLuasNamed(luaFile:String) {
        #if MODS_ALLOWED
        var luaToLoad:String = Paths.modFolders(luaFile);
        if (!FileSystem.exists(luaToLoad))
            luaToLoad = Paths.getSharedPath(luaFile);

        if (FileSystem.exists(luaToLoad)) {
            for (script in luaArray)
                if(script.scriptName == luaToLoad) return false;

            new FunkinLua(luaToLoad);
            return true;
        }
        return false;
    }

    public function startHScriptsNamed(scriptFile:String) {
        #if MODS_ALLOWED
        var scriptToLoad:String = Paths.modFolders(scriptFile);
        if (!FileSystem.exists(scriptToLoad))
            scriptToLoad = Paths.getSharedPath(scriptFile);
        #end

        if (FileSystem.exists(scriptToLoad)) {
            if (SScript.global.exists(scriptToLoad)) return false;
            initHScript(scriptToLoad);
            return true;
        }
        return false;
    }

    public function initHScript(file:String) {
        try {
            var newScript:HScript = new HScript(null, file);
            if (newScript.parsingException != null) {
                addTextToDebug('ERROR ON LOADING: ${newScript.parsingException.message}', FlxColor.RED);
                newScript.destroy();
                return;
            }

            hscriptArray.push(newScript);
            if (newScript.exists('onCreate')) {
                var callValue = newScript.call('onCreate');
                if (!callValue.succeeded) {
                    for (e in callValue.exceptions) {
                        if (e != null) {
                            var len:Int = e.message.indexOf('\n') + 1;
                            if (len <= 0) len = e.message.length;
                            addTextToDebug('ERROR ($file: onCreate) - ${e.message.substr(0, len)}', FlxColor.RED);
                        }
                    }
                    newScript.destroy();
                    hscriptArray.remove(newScript);
                }
            }
        } catch(e) {
            var len:Int = e.message.indexOf('\n') + 1;
            if (len <= 0) len = e.message.length;
            addTextToDebug('ERROR - ' + e.message.substr(0, len), FlxColor.RED);
            var newScript:HScript = cast (SScript.global.get(file), HScript);
            if (newScript != null) {
                newScript.destroy();
                hscriptArray.remove(newScript);
            }
        }
    }

    public function callOnScripts(funcToCall:String, args:Array<Dynamic> = null, ignoreStops = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
        var returnVal:Dynamic = LuaUtils.Function_Continue;
        if (args == null) args = [];
        if (exclusions == null) exclusions = [];
        if (excludeValues == null) excludeValues = [LuaUtils.Function_Continue];

        var result:Dynamic = callOnLuas(funcToCall, args, ignoreStops, exclusions, excludeValues);
        if (result == null || excludeValues.contains(result)) result = callOnHScript(funcToCall, args, ignoreStops, exclusions, excludeValues);
        return result;
    }

    public function callOnLuas(funcToCall:String, args:Array<Dynamic> = null, ignoreStops = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
        var returnVal:Dynamic = LuaUtils.Function_Continue;
        #if LUA_ALLOWED
        for (script in luaArray)
            if (script != null) {
                if (exclusions.contains(script.scriptName) || returnVal == LuaUtils.Function_Stop && !ignoreStops) continue;
                returnVal = script.call(funcToCall, args);
                if (returnVal != null && !excludeValues.contains(returnVal)) break;
            }
        #end
        return returnVal;
    }

    public function callOnHScript(funcToCall:String, args:Array<Dynamic> = null, ignoreStops = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
        var returnVal:Dynamic = LuaUtils.Function_Continue;
        #if HSCRIPT_ALLOWED
        for (script in hscriptArray) {
            if (script != null && !exclusions.contains(script.scriptName) && (ignoreStops || returnVal != LuaUtils.Function_Stop)) {
                var callValue = script.call(funcToCall, args);
                if (callValue != null && callValue.succeeded && !excludeValues.contains(callValue.result)) {
                    returnVal = callValue.result;
                    break;
                }
            }
        }
        #end
        return returnVal;
    }

    public function setOnScripts(varName:String, varValue:Dynamic) {
        #if LUA_ALLOWED
        for (script in luaArray)
            if (script != null)
                script.setVariable(varName, varValue);
        #end

        #if HSCRIPT_ALLOWED
        for (script in hscriptArray)
            if (script != null)
                script.setVariable(varName, varValue);
        #end
    }
}