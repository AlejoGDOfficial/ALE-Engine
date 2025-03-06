import core.backend.Mods;

import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUIDropDownMenu;

import game.editors.ChartingState;
import game.states.PlayState;

import utils.helpers.Difficulty;

import flixel.ui.FlxButton;

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

function onCreate()
{
    var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    add(bg);
    bg.alpha = 0;
    FlxTween.tween(bg, {alpha: 0.75}, 0.5, {ease: FlxEase.cubeOut});

    add(new FlxText(200, 500, 0, 'Press ENTER to proceed | Press ESCAPE to cancel', 15));

    songNameInput = new FlxInputText(200, 300, 150);
    add(songNameInput);

    voicesCheckBox = new FlxUICheckBox(400, 300, null, null, "Has voice track", 100);
    add(voicesCheckBox);
    voicesCheckBox.checked = true;

    bpmNumberStepper = new FlxUINumericStepper(600, 300, 1, 150, 0, 400);
    add(bpmNumberStepper);

    speedNumberStepper = new FlxUINumericStepper(800, 300, 0.1, 1, 0.1, 10, 2);
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
    
    opponentDropDown = new FlxUIDropDownMenu(200, 400, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true));
    add(opponentDropDown);
    if (characters.contains('dad')) opponentDropDown.selectedLabel = 'dad';

    gfDropDown = new FlxUIDropDownMenu(400, 400, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true));
    add(gfDropDown);
    if (characters.contains('gf')) gfDropDown.selectedLabel = 'gf';

    playerDropDown = new FlxUIDropDownMenu(600, 400, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true));
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

    stageDropDown = new FlxUIDropDownMenu(800, 400, FlxUIDropDownMenu.makeStrIdLabelArray(stages, true));
    add(stageDropDown);
    if (stages.contains('stage')) stageDropDown.selectedLabel = 'stage';

    add(new FlxText(songNameInput.x, songNameInput.y - 15, 0, 'Song:'));
    add(new FlxText(bpmNumberStepper.x, bpmNumberStepper.y - 15, 0, 'Song BPM:'));
    add(new FlxText(speedNumberStepper.x, speedNumberStepper.y - 15, 0, 'Song Speed:'));

    add(new FlxText(opponentDropDown.x, opponentDropDown.y - 15, 0, 'Opponent:'));
    add(new FlxText(gfDropDown.x, gfDropDown.y - 15, 0, 'Girlfriend:'));
    add(new FlxText(playerDropDown.x, playerDropDown.y - 15, 0, 'Boyfriend:'));

    add(new FlxText(stageDropDown.x, stageDropDown.y - 15, 0, 'Stage:'));

    metaText = new FlxText(200, 100, FlxG.width - 400, 'MetaData: No MetaData', 12);
    add(metaText);

    metaNameInput = new FlxInputText(700, 500, 150);
    add(metaNameInput);
    
    metaValueInput = new FlxInputText(900, 500, 150);
    add(metaValueInput);

    add(new FlxText(metaNameInput.x, metaNameInput.y - 15, 0, 'Meta Name:'));
    add(new FlxText(metaValueInput.x, metaValueInput.y - 15, 0, 'Meta Value:'));

    var addMetaButton = new FlxButton(700, 550, 'Add Meta', () -> {
        if (metaNameInput.text != '') Reflect.setField(metaData, metaNameInput.text, metaValueInput.text);
        metaText.text = 'MetaData: ' + Std.string(metaData);
    });
    addMetaButton.scrollFactor.set(1, 1);
    addMetaButton.antialiasing = ClientPrefs.data.antialiasing;
    add(addMetaButton);

    var deleteMetaButton = new FlxButton(900, 550, 'Remove Meta', () -> {
        if (metaNameInput.text != '' && Reflect.hasField(metaData, metaNameInput.text)) metaData = shittyDeleteField(metaData, metaNameInput.text);
        metaText.text = 'MetaData: ' + Std.string(metaData);
    });
    deleteMetaButton.scrollFactor.set(1, 1);
    deleteMetaButton.antialiasing = ClientPrefs.data.antialiasing;
    add(deleteMetaButton);
}

function shittyDeleteField(object:Dynamic, removeField:String)
{
    var newObject:Dynamic = {};

    for (field in Reflect.fields(object)) if (field != removeField) Reflect.setField(newObject, field, Reflect.field(object, field));
    
    return newObject;
}

function onUpdatePost()
{
    if (controls.BACK)
    {
        close();
    }
}

function onUpdate()
{
    if (FlxG.keys.justPressed.ENTER)
    {
        FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

        new FlxTimer().start(1, function(tmr:FlxTimer)
        {
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

            PlayState.chartingMode = true;

            MusicBeatState.switchState(new ChartingState());

            close();
        });
    }
}