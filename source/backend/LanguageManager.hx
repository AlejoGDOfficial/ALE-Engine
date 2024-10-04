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

    public static var languages:Array<String> = ['english'];
    public static var suffixes:Array<String> = ['eng'];

    public static var curLanguage:String = ClientPrefs.data.language;

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

    public static function setPhrase(id:String, texts:Array<Dynamic>)
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
}