import haxe.ds.StringMap;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import flixel.math.FlxRect;
import flixel.ui.FlxButton;

import visuals.objects.Alphabet;
import visuals.objects.AttachedSprite;

import tjson.TJSON as Json;

import utils.mods.Mods;

import haxe.ds.StringMap;

import gameplay.states.game.PlayState;
import core.backend.SwagSong;
import utils.helpers.Difficulty;

import gameplay.states.editors.ChartingState;

var difficultyTextBG:FlxSprite;
var difficultyText:FlxText;

var canSelectSongs:Bool = false;
var creatingSong:Bool = false;

var bg:FlxBackdrop;

function onCreate()
{
    Paths.sound('scrollMenu');

    bg = new FlxBackdrop().loadGraphic(Paths.image('editors/listNote'));
    add(bg);
    bg.scale.set(0.75, 0.75);
    bg.updateHitbox();
    bg.alpha = 0.1;

    difficultyTextBG = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
    add(difficultyTextBG);
    difficultyTextBG.alpha = 0.5;

    difficultyText = new FlxText(0, 10, 0);
    difficultyText.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, 'center');
    add(difficultyText);
    difficultyText.antialiasing = ClientPrefs.data.antialiasing;
    difficultyText.x = FlxG.width - difficultyText.width - 10;
		
    var foldersToCheck = [];

    if (FileSystem.exists(Paths.getSharedPath('weeks')) && FileSystem.isDirectory(Paths.getSharedPath('weeks'))) foldersToCheck.push(Paths.getSharedPath('weeks'));
    if (FileSystem.exists(Paths.mods(Mods.currentModDirectory + '/weeks')) && FileSystem.isDirectory(Paths.mods(Mods.currentModDirectory + '/weeks'))) foldersToCheck.push(Paths.mods(Mods.currentModDirectory + '/weeks'));

    addSong('< New Song >', 'face', ['Press Enter']);

    var weeks = [];

    for (folder in foldersToCheck)
    {
        var files = FileSystem.readDirectory(folder).filter(function(file) return StringTools.endsWith(file, '.json'));

        for (file in files)
        {
            var replaced = false;

            for (i in 0...weeks.length)
            {
                if (weeks[i][1] != null && weeks[i][1] == file) 
                {
                    weeks[i][0] = folder;

                    replaced = true;
                }
            }

            if (!replaced) weeks.push([folder, file]);
        }
    }

    for (week in weeks)
    {
        var jsonData = Json.parse(File.getContent(week[0] + '/' + week[1]));

        var jsonDiff:Array = Reflect.hasField(jsonData, 'difficulties') && jsonData.difficulties != '' ? jsonData.difficulties.join('').split(',') : null;
        
        for (song in jsonData.songs)
        {
            addSong(song[0], song[1], jsonDiff == null ? ['Easy', 'Normal', 'Hard'] : jsonDiff);
        }
    }

    new FlxTimer().start(1, function(tmr:FlxTimer)
    {
        changeSongShit();
        changeDifficultyShit();
        canSelectSongs = true;
    });

    createUI(false);
}

var songs:Array<StringMap> = [];
var difficulties:Array = ['Easy', 'Normal', 'Hard'];

var curWeek:String = '';

var songsSelInt:Int = existsGlobalVar('chartEditorListSongsSelInt') ? getGlobalVar('chartEditorListSongsSelInt') : 0;
var difficultiesSelInt:Int = existsGlobalVar('chartEditorListDifficultiesSelInt') ? getGlobalVar('chartEditorListDifficultiesSelInt') : 0;

function onBeatHit()
{
    for (song in songs)
    {
        if (songs.indexOf(song) == songsSelInt && canSelectSongs)
        {
            song.get('icon').scale.x = 1.15;
            song.get('icon').scale.y = 1.15;
        }
    }

    if (curBeat % 2 == 0 && (canSelectSongs || creatingSong))
    {
        FlxTween.cancelTweensOf(bg);
        bg.angle = -90;
        FlxTween.tween(bg, {x: bg.x + bg.width / 2, y: bg.y + bg.height / 2}, 120 / Conductor.bpm, {ease: FlxEase.cubeOut});
    }
}

function onUpdate(elapsed:Float)
{
    for (song in songs)
    {
        if (song.get('icon').scale.x != 1 || song.get('icon').scale.y != 1 )
        {
            song.get('icon').scale.x = fpsLerp(song.get('icon').scale.x, 1, 0.33); 
            song.get('icon').scale.y = fpsLerp(song.get('icon').scale.y, 1, 0.33); 
        }
    }

    if (canSelectSongs && !creatingSong)
    {
        if (songs.length > 1)
        {
            if (controls.UI_UP_P || controls.UI_DOWN_P || FlxG.mouse.wheel != 0)
            {
                if (controls.UI_UP_P || FlxG.mouse.wheel > 0)
                {
                    if (songsSelInt > 0)
                    {
                        songsSelInt -= 1;
                    } else if (songsSelInt == 0) {
                        songsSelInt = songs.length - 1;
                    }
                } else if (controls.UI_DOWN_P || FlxG.mouse.wheel < 0) {
                    if (songsSelInt < songs.length - 1)
                    {
                        songsSelInt += 1;
                    } else if (songsSelInt == songs.length - 1) {
                        songsSelInt = 0;
                    }
                }
            
                changeSongShit();
                changeDifficultyShit();
            }
        }

        if (difficulties.length > 1)
        {
            if (controls.UI_LEFT_P || controls.UI_RIGHT_P)
            {
                if (controls.UI_LEFT_P)
                {
                    if (difficultiesSelInt > 0)
                    {
                        difficultiesSelInt -= 1;
                    } else if (difficultiesSelInt == 0) {
                        difficultiesSelInt = difficulties.length - 1;
                    }
                } else if (controls.UI_RIGHT_P) {
                    if (difficultiesSelInt < difficulties.length - 1)
                    {
                        difficultiesSelInt += 1;
                    } else if (difficultiesSelInt == difficulties.length - 1) {
                        difficultiesSelInt = 0;
                    }
                }
            
                changeDifficultyShit();
            }
        }

        if (controls.ACCEPT)
        {
            setGlobalVar('chartEditorListSongsSelInt', songsSelInt);
            setGlobalVar('chartEditorListDifficultiesSelInt', difficultiesSelInt);

            for (song in songs)
            {
                if (songs.indexOf(song) == songsSelInt)
                {
                    if (ClientPrefs.data.flashing)
                    {
                        FlxFlicker.flicker(song.get('text'), song.get('name') == '< New Song >' ? 1 : 0, 0.05);
                        FlxFlicker.flicker(song.get('icon'), song.get('name') == '< New Song >' ? 1 : 0, 0.05);
                    }

                    FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
                    
                    new FlxTimer().start(1, function(tmr:FlxTimer)
                    {
                        if (song.get('name') == '< New Song >')
                        {
                            FlxTween.cancelTweensOf(FlxG.camera.scroll);
                            FlxTween.tween(FlxG.camera.scroll, {x: FlxG.width}, 60 / Conductor.bpm, {ease: FlxEase.circInOut});

                            creatingSong = true;
                        } else {
                            var foldersToCheck = [];
    
                            if (FileSystem.exists(Paths.mods(Mods.currentModDirectory + '/data')) && FileSystem.isDirectory(Paths.mods(Mods.currentModDirectory + '/data'))) foldersToCheck.push(Paths.mods(Mods.currentModDirectory + '/data'));
                            if (FileSystem.exists(Paths.getSharedPath('data')) && FileSystem.isDirectory(Paths.getSharedPath('data'))) foldersToCheck.push(Paths.getSharedPath('data'));
    
                            for (folder in foldersToCheck)
                            {
                                var entries = FileSystem.readDirectory(folder);

                                var songFormatted = StringTools.replace(song.get('name').toLowerCase(), ' ', '-');
                                var diffFormatted = StringTools.replace(difficulties[difficultiesSelInt].toLowerCase(), ' ', '-');
                                
                                for (entry in entries)
                                {
                                    if (FileSystem.isDirectory(folder + '/' + entry) && entry.toLowerCase() == songFormatted)
                                    {
                                        if (FileSystem.exists(folder + '/' + entry + '/' + songFormatted + (diffFormatted == 'normal' ? '' : '-' + diffFormatted) + '.json'))
                                        {
                                            Difficulty.resetList();
    
                                            var jsonData = Json.parse(File.getContent(folder + '/' + entry + '/' + songFormatted + (diffFormatted == 'normal' ? '' : '-' + diffFormatted) + '.json'));
                                            if (!Reflect.hasField(jsonData.song, 'events')) Reflect.setField(jsonData.song, 'events', []);
                                            
                                            var songData = jsonData.song;
    
                                            PlayState.SONG = songData;
                                            MusicBeatState.switchState(new ChartingState());
                                        }
                                    }
                                }
                            }
                        }
                    });
                } else if (songs[songsSelInt].get('name') != '< New Song >') {
                    FlxTween.tween(song.get('text'), {alpha: 0}, 0.5, {ease: FlxEase.cubeIn});
                    FlxTween.tween(song.get('icon'), {alpha: 0}, 0.5, {ease: FlxEase.cubeIn});
                }
            }

            canSelectSongs = false;
        }

        if (controls.BACK)
        {
            setGlobalVar('chartEditorListSongsSelInt', songsSelInt);
            setGlobalVar('chartEditorListDifficultiesSelInt', difficultiesSelInt);

            for (song in songs) FlxTween.cancelTweensOf(song.get('text'));

            MusicBeatState.switchState(new ScriptState('masterEditorMenu'));

            FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);

            canSelectSongs = false;
        }

        if (!FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.CONTROL) openSubState('gameplay.states.substates.GameplayChangersSubstate', []);
    } else if (creatingSong) {
        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxTween.cancelTweensOf(FlxG.camera.scroll);
            FlxTween.tween(FlxG.camera.scroll, {x: 0}, 60 / Conductor.bpm, {ease: FlxEase.circInOut});

            creatingSong = false;
            canSelectSongs = true;
        }

        if (FlxG.keys.justPressed.ENTER) createUI(true);
    }
}

function changeSongShit()
{
    for (song in songs)
    {
        if (songs.indexOf(song) == songsSelInt)
        {
            if (song.get('text').alpha != 1) song.get('text').alpha = 1;
        } else {
            if (song.get('text').alpha != 0.5) song.get('text').alpha = 0.5;
        }

        FlxTween.cancelTweensOf(song.get('text'));
        FlxTween.tween(song.get('text'), {x: 100 + 50 * (songs.indexOf(song) - songsSelInt), y: 318 + 120 * (songs.indexOf(song) - songsSelInt)}, 30 / Conductor.bpm, {ease: FlxEase.cubeOut});
    }

    FlxG.sound.play(Paths.sound('scrollMenu'));
}

function changeDifficultyShit()
{
    for (song in songs)
    {
        if (songs.indexOf(song) == songsSelInt)
        {
            if (difficulties.length != song.get('difficulties').length) difficultiesSelInt = 0;

            difficulties = song.get('difficulties');
        }
    }

    if (difficulties.length == 1) difficultyText.text = (songs[songsSelInt].get('name') == '< New Song >' ? 'TIP' : 'DIFFICULTY') + '\n' + difficulties[difficultiesSelInt];
    else difficultyText.text = 'DIFFICULTIES\n' + '<' + difficulties[difficultiesSelInt] + '>';

    difficultyText.x = FlxG.width - difficultyText.width - 10;

    difficultyTextBG.scale.x = difficultyText.width * 2 + 40;
    difficultyTextBG.scale.y = difficultyText.height * 2 + 40;
    difficultyTextBG.x = FlxG.width - difficultyTextBG.width;
}

function addSong(name:String, icon:String, difficulties:Array)
{
    var songData:StringMap = new StringMap();

    var text:Alphabet = new Alphabet(100 + 50 * (songs.length - songsSelInt), 318 + 120 * (songs.length - songsSelInt), name, true);
    text.snapToPosition();
    add(text);
    text.alpha = 0.5;
    text.scaleX = text.scaleY = 1.1;
    text.antialiasing = ClientPrefs.data.antialiasing;
    if (name == '< New Song >') text.color = FlxColor.CYAN;

    var iconPath = 'icons/' + icon;
    if (!Paths.fileExists('images/' + iconPath + '.png', 'IMAGE')) iconPath = 'icons/icon-' + icon;
    if (!Paths.fileExists('images/' + iconPath + '.png', 'IMAGE')) iconPath = 'icons/icon-face';
    if (!Paths.fileExists('images/' + iconPath + '.png', 'IMAGE')) iconPath = 'icons/face';

    var iconSprite:AttachedSprite = new AttachedSprite(iconPath, null, null, false);
    if (name != '< New Song >') add(iconSprite);
    iconSprite.sprTracker = text;
    iconSprite.xAdd = text.width + 5;
    iconSprite.yAdd = text.height / 2 - iconSprite.height / 2;
    iconSprite.clipRect = new FlxRect(0, 0, iconSprite.width / 2, iconSprite.height);
    iconSprite.antialiasing = ClientPrefs.data.antialiasing;

    songData.set('text', text);
    songData.set('icon', iconSprite);
    songData.set('name', name);
    songData.set('difficulties', difficulties);

    songs.push(songData);
}

var metaText:FlxText;
    
var songNameInput:FlxInputText;
var voicesCheckBox:FlxUICheckBox;
var bpmNumberStepper:FlxUINumericStepper;
var speedNumberStepper:FlxUINumericStepper;
var metaNameInput:FlxInputText;
var metaValueInput:FlxInputText;

var opponentDropDown:FlxUIDropDownMenu;
var gfDropDown:FlxUIDropDownMenu;
var playerDropDown:FlxUIDropDownMenu;

var stageDropDown:FlxUIDropDownMenu;

var metaData:Dynamic = {};

function createUI(create:Bool)
{
    addHaxeLibrary('FlxUINumericStepper', 'flixel.addons.ui');
    addHaxeLibrary('FlxUIDropDownMenu', 'flixel.addons.ui');
    addHaxeLibrary('FlxUICheckBox', 'flixel.addons.ui');
    addHaxeLibrary('FlxInputText', 'flixel.addons.ui');

    if (create)
    {
        FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

        FlxTween.cancelTweensOf(FlxG.camera.scroll);

        FlxTween.tween(FlxG.camera.scroll, {x: FlxG.width * 2}, 60 / Conductor.bpm, {
            ease: FlxEase.circInOut,
            onComplete: function() {
                Difficulty.resetList();
        
                var songData = {
                    song: songNameInput.text == null || StringTools.trim(songNameInput.text) == '' ? 'Test' : songNameInput.text,
                    notes: [],
                    events: [],
                    bpm: bpmNumberStepper.value,
                    needsVoices: voicesCheckBox.checked,
                    player1: playerDropDown.selectedLabel,
                    player2: opponentDropDown.selectedLabel,
                    gfVersion: gfDropDown.selectedLabel,
                    speed: speedNumberStepper.value,
                    stage: stageDropDown.selectedLabel
                };

                if (metaData != {} && metaData != null) Reflect.setField(songData, 'metadata', metaData);
        
                PlayState.SONG = songData;

                MusicBeatState.switchState(new ChartingState());
            }
        });

        FlxTween.tween(bg, {alpha: 0}, 60 / Conductor.bpm, {ease: FlxEase.circInOut});

        creatingSong = false;
    } else {
        add(new FlxText(FlxG.width + 200, 500, 0, 'Press ENTER to proceed | Press ESCAPE to cancel', 15));

        songNameInput = new FlxInputText(FlxG.width + 200, 300, 150);
        add(songNameInput);

		voicesCheckBox = new FlxUICheckBox(FlxG.width + 400, 300, null, null, "Has voice track", 100);
        add(voicesCheckBox);
        voicesCheckBox.checked = true;
    
        bpmNumberStepper = new FlxUINumericStepper(FlxG.width + 600, 300, 1, 150, 0, 400);
        add(bpmNumberStepper);
    
        speedNumberStepper = new FlxUINumericStepper(FlxG.width + 800, 300, 0.1, 1, 0.1, 10, 2);
        add(speedNumberStepper);
        
        var characters = [];
    
        var foldersToCheck = [];
    
        if (FileSystem.exists(Paths.mods(Mods.currentModDirectory + '/characters')) && FileSystem.isDirectory(Paths.mods(Mods.currentModDirectory + '/characters'))) foldersToCheck.push(Paths.mods(Mods.currentModDirectory + '/characters'));
        if (FileSystem.exists(Paths.getSharedPath('characters')) && FileSystem.isDirectory(Paths.getSharedPath('characters'))) foldersToCheck.push(Paths.getSharedPath('characters'));
    
        for (folder in foldersToCheck)
        {
            var files = FileSystem.readDirectory(folder);
    
            for (file in files)
            {
                if (StringTools.endsWith(file, '.json'))
                {
                    var characterToCheck = file.substr(0, file.length - 5);
        
                    if (!StringTools.endsWith(characterToCheck, '-dead') && StringTools.trim(characterToCheck).length > 0 && !characters.contains(characterToCheck)) characters.push(characterToCheck);
                }
            }
        }
        
        opponentDropDown = new FlxUIDropDownMenu(FlxG.width + 200, 400, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true));
        add(opponentDropDown);
        if (characters.contains('dad')) opponentDropDown.selectedLabel = 'dad';
    
        gfDropDown = new FlxUIDropDownMenu(FlxG.width + 400, 400, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true));
        add(gfDropDown);
        if (characters.contains('gf')) gfDropDown.selectedLabel = 'gf';
    
        playerDropDown = new FlxUIDropDownMenu(FlxG.width + 600, 400, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true));
        add(playerDropDown);
        if (characters.contains('bf')) playerDropDown.selectedLabel = 'bf';
        
        var stages = [];
    
        var foldersToCheck = [];
    
        if (FileSystem.exists(Paths.mods(Mods.currentModDirectory + '/stages')) && FileSystem.isDirectory(Paths.mods(Mods.currentModDirectory + '/stages'))) foldersToCheck.push(Paths.mods(Mods.currentModDirectory + '/stages'));
        if (FileSystem.exists(Paths.getSharedPath('stages')) && FileSystem.isDirectory(Paths.getSharedPath('stages'))) foldersToCheck.push(Paths.getSharedPath('stages'));
    
        for (folder in foldersToCheck)
        {
            var files = FileSystem.readDirectory(folder);
    
            for (file in files)
            {
                if (StringTools.endsWith(file, '.json'))
                {
                    var stageToCheck = file.substr(0, file.length - 5);
        
                    if (!StringTools.trim(stageToCheck).length > 0 && !stages.contains(stageToCheck)) stages.push(stageToCheck);
                }
            }
        }
    
        if (stages.length < 1) stages.push('stage');
    
        stageDropDown = new FlxUIDropDownMenu(FlxG.width + 800, 400, FlxUIDropDownMenu.makeStrIdLabelArray(stages, true));
        add(stageDropDown);
        if (stages.contains('stage')) stageDropDown.selectedLabel = 'stage';
    
        add(new FlxText(songNameInput.x, songNameInput.y - 15, 0, 'Song:'));
        add(new FlxText(bpmNumberStepper.x, bpmNumberStepper.y - 15, 0, 'Song BPM:'));
        add(new FlxText(speedNumberStepper.x, speedNumberStepper.y - 15, 0, 'Song Speed:'));

        add(new FlxText(opponentDropDown.x, opponentDropDown.y - 15, 0, 'Opponent:'));
        add(new FlxText(gfDropDown.x, gfDropDown.y - 15, 0, 'Girlfriend:'));
        add(new FlxText(playerDropDown.x, playerDropDown.y - 15, 0, 'Boyfriend:'));

        add(new FlxText(stageDropDown.x, stageDropDown.y - 15, 0, 'Stage:'));

        metaText = new FlxText(FlxG.width + 200, 100, FlxG.width - 400, 'MetaData: No MetaData', 12);
        add(metaText);

        metaNameInput = new FlxInputText(FlxG.width + 700, 500, 150);
        add(metaNameInput);
        
        metaValueInput = new FlxInputText(FlxG.width + 900, 500, 150);
        add(metaValueInput);

        add(new FlxText(metaNameInput.x, metaNameInput.y - 15, 0, 'Meta Name:'));
        add(new FlxText(metaValueInput.x, metaValueInput.y - 15, 0, 'Meta Value:'));

        var addMetaButton = new FlxButton(FlxG.width + 700, 550, 'Add Meta', () -> {
            if (metaNameInput.text != '') Reflect.setField(metaData, metaNameInput.text, metaValueInput.text);
            metaText.text = 'MetaData: ' + Std.string(metaData);
        });
        addMetaButton.scrollFactor.set(1, 1);
        addMetaButton.antialiasing = ClientPrefs.data.antialiasing;
        add(addMetaButton);

        var deleteMetaButton = new FlxButton(FlxG.width + 900, 550, 'Remove Meta', () -> {
            if (metaNameInput.text != '' && Reflect.hasField(metaData, metaNameInput.text)) metaData = shittyDeleteField(metaData, metaNameInput.text);
            metaText.text = 'MetaData: ' + Std.string(metaData);
        });
        deleteMetaButton.scrollFactor.set(1, 1);
        deleteMetaButton.antialiasing = ClientPrefs.data.antialiasing;
        add(deleteMetaButton);
    }
}

function shittyDeleteField(object:Dynamic, removeField:String)
{
    var newObject:Dynamic = {};

    for (field in Reflect.fields(object)) if (field != removeField) Reflect.setField(newObject, field, Reflect.field(object, field));
    
    return newObject;
}