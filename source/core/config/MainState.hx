package core.config;

import openfl.Lib;
import openfl.display.StageScaleMode;

import utils.debug.FPSCounter;

#if windows import cpp.WindowsCPP; #end

class MainState extends MusicBeatState
{
    public static var fpsVar:FPSCounter;

    override public function create()
    {
        ClientPrefs.loadPrefs();
    
        #if windows WindowsCPP.setWindowLayered(); #end
    
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

		Mods.pushGlobalMods();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

        super.create();

        #if !mobile
        fpsVar = new FPSCounter();
        FlxG.game.addChild(fpsVar);
        Lib.current.stage.align = "tl";
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        #end

        try
        {
            var jsonToLoad:String = Paths.modFolders('data.json');
            if(!FileSystem.exists(jsonToLoad))
                jsonToLoad = Paths.getSharedPath('data.json');
    
            var jsonData = haxe.Json.parse(sys.io.File.getContent(jsonToLoad));

            CoolVars.developerMode = Reflect.hasField(jsonData, 'developerMode') ? jsonData.developerMode : true;

            trace('Developer Mode: ' + CoolVars.developerMode);
    
            CoolVars.scriptFromInitialState = Reflect.hasField(jsonData, 'initialState') ? jsonData.initialState : 'introState';
            CoolVars.scriptFromPlayStateIfStoryMode = Reflect.hasField(jsonData, 'fromPlayStateIfStoryMode') ? jsonData.fromPlayStateIfStoryMode : 'storyMenuState';
            CoolVars.scriptFromPlayStateIfFreeplay = Reflect.hasField(jsonData, 'fromPlayStateIfFreeplay') ? jsonData.fromPlayStateIfFreeplay : 'freeplayState';
            CoolVars.scriptFromEditors = Reflect.hasField(jsonData, 'fromEditors') ? jsonData.fromEditors : 'masterEditorMenu';
            CoolVars.scriptFromOptions = Reflect.hasField(jsonData, 'fromOptions') ? jsonData.fromOptions : 'mainMenuState';

            trace('Initial State: ' + CoolVars.scriptFromInitialState);
            trace('From PlayState if Story Mode: ' + CoolVars.scriptFromPlayStateIfStoryMode);
            trace('From PlayState if Freeplay: ' + CoolVars.scriptFromPlayStateIfFreeplay);
            trace('From Editors: ' + CoolVars.scriptFromEditors);
            trace('From Options: ' + CoolVars.scriptFromOptions);

            if (Reflect.hasField(jsonData, 'title')) lime.app.Application.current.window.title = jsonData.title;
            #if windows WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title); #end
            
			var iconPath:String = Reflect.hasField(jsonData, 'icon') ? 'mods/' + Mods.currentModDirectory + '/' + jsonData.icon + '.png' : 'assets/shared/images/appIcon.png';
			if(!FileSystem.exists(iconPath)) iconPath = 'assets/shared/images/appIcon.png';
            
            lime.app.Application.current.window.setIcon(lime.graphics.Image.fromFile(iconPath));
        } catch(error:Dynamic) {
            trace(error);
        }

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

        MusicBeatState.switchState(new ScriptState(CoolVars.scriptFromInitialState));

        CoolVars.engineVersion = lime.app.Application.current.meta.get('version');

		#if CHECK_FOR_UPDATES
		if (ClientPrefs.data.checkForUpdates) 
        {
			trace('Checking for Update...');

			var http = new haxe.Http("https://raw.githubusercontent.com/AlejoGDOfficial/ALE-Engine/refs/heads/beta/githubVersion.txt");

			http.onData = function (data:String)
			{
				CoolVars.onlineVersion = data.split('\n')[0].trim();

				trace('Current Version: ' + CoolVars.onlineVersion);
                trace('Your Version: ' + CoolVars.engineVersion);

				if (CoolVars.onlineVersion != CoolVars.engineVersion) 
                {
                    trace('Versions aren\'t matching!');
                    
					CoolVars.outdated = true;
				}
			}

			http.onError = function (error) {
				trace('Error: $error');
			}

			http.request();
		}
		#end
    }
}