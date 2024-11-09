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

    public static var jsonData:Dynamic;

    public static var languages:Array<String> = ['english'];
    public static var suffixes:Array<String> = ['eng'];

    public static var curLanguage:String = ClientPrefs.data.language;

    public static function loadPhrases():Void
    {
        try {
            var jsonString = File.getContent(Paths.modFolders("scripts/config/translations.json"));
            if(!FileSystem.exists(jsonString))
            {
                jsonString = Paths.getSharedPath("scripts/config/translations.json"); 
            }
            
            jsonData = haxe.format.JsonParser.parse(jsonString);
        } catch (e:Dynamic) {
            trace("Error loading JSON file: " + e);
            return;
        }

        if (jsonData.languages != null && jsonData.languages.length >= 2)
        {
            languages = jsonData.languages[0];
            suffixes = jsonData.languages[1];
            LanguageSubState.languages = languages;

            if (!languages.contains(ClientPrefs.data.language))
            {
                ClientPrefs.data.language = languages[0];
                curLanguage = ClientPrefs.data.language;
            }
        }
        else
        {
            trace("Error: Expected sections not found in translations.json!");
        }
    }

    public static function getPhrase(section:String, key:String):Dynamic
    {
        var langIndex = languages.indexOf(curLanguage);
        var sectionData = Reflect.field(jsonData, section);
        var keyData = Reflect.field(sectionData, key);
        return keyData[langIndex];
    }

    public static function getSuffix():String
    {
        var index:Int = languages.indexOf(curLanguage);

        return '_' + suffixes[index];
    }
}