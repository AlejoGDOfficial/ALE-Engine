package core.config;

import openfl.Lib;
import openfl.display.StageScaleMode;

import utils.debug.FPSCounter;

import flixel.util.FlxSave;

#if (cpp && windows) import cpp.WindowsCPP; #end

@:access(utils.helpers.CoolVars)
class MainState extends MusicBeatState
{
    public static var fpsVar:FPSCounter;

    override public function create()
    {
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

		Mods.pushGlobalMods();

        ClientPrefs.loadJsonPrefs();
        ClientPrefs.loadPrefs();

        utils.save.Highscore.load();

        var scoreSave:FlxSave = new FlxSave();
        scoreSave.bind('score', CoolUtil.getSavePath() + '/' + Mods.currentModDirectory);
        
        if (scoreSave.data.weekCompleted != null) utils.save.Highscore.weekCompleted = scoreSave.data.weekCompleted;

        #if (windows && cpp) WindowsCPP.setWindowLayered(); #end

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

        super.create();

		#if DISCORD_ALLOWED
		DiscordClient.prepare();
		#end

        fpsVar = new FPSCounter();
        FlxG.game.addChild(fpsVar);
        Lib.current.stage.align = "tl";
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

        if (Reflect.hasField(CoolVars.gameData, 'title')) lime.app.Application.current.window.title = CoolVars.gameData.title;
        #if (windows && cpp) WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title); #end
        
        var iconPath:String = Reflect.hasField(CoolVars.gameData, 'icon') ? 'mods/' + Mods.currentModDirectory + '/' + CoolVars.gameData.icon + '.png' : 'assets/shared/images/appIcon.png';
        if(!FileSystem.exists(iconPath)) iconPath = 'assets/shared/images/appIcon.png';
        
        lime.app.Application.current.window.setIcon(lime.graphics.Image.fromFile(iconPath));

		CoolVars.skipTransIn = true;
		CoolVars.skipTransOut = true;

        CoolVars.engineVersion = lime.app.Application.current.meta.get('version');
        
		#if CHECK_FOR_UPDATES
		if (ClientPrefs.data.checkForUpdates) 
        {
			trace('Checking for Update...');

			var http = new haxe.Http("https://raw.githubusercontent.com/AlejoGDOfficial/ALE-Engine/refs/heads/main/githubVersion.txt");

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

        new FlxTimer().start(1, function(tmr:FlxTimer)
        {
            MusicBeatState.switchState(new #if android CopyState() #else ScriptState(CoolVars.scriptInitialState) #end);
        });
    }
}