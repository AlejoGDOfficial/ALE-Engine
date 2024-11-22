package states.editors;

import flixel.ui.FlxButton;
import flixel.addons.ui.*;

import haxe.Json;

import states.editors.content.Prompt;

class LanguagesEditorState extends MusicBeatState
{
    var defaultData:Dynamic;
    var jsonData:Dynamic;
    var jsonSections:Array<String> = [];

    var uiExists:Bool = false;

    var uiBox:FlxUITabMenu;

    var sectionsMenu:FlxUIDropDownMenu;
    var sectionsMenuLabels:Array<StrNameLabel> = [];
    var sectionsInputName:FlxInputText;
    var sectionsAddButton:FlxButton;
    var sectionsDeleteButton:FlxButton;

    var keysMenu:FlxUIDropDownMenu;
    var keysInputName:FlxInputText;
    var keysNumberStepperCreateArrayLevels:FlxUINumericStepper;
    var keysNumberStepperCreateArraySize:FlxUINumericStepper;
    var keysCreateArrayButton:FlxButton;
    var keysCreateArrayPreview:FlxText;
    var keysInputString:FlxInputText;
    var keysCreateStringButton:FlxButton;
    var keysInputIndex:FlxInputText;
    var keysPushStringButton:FlxButton;
    var keysRemoveStringButton:FlxButton;
    var keysReplaceStringButton:FlxButton;
    var keysDeleteButton:FlxButton;
    var keysMenuLabels:Array<StrNameLabel> = [];

    var languagesMenu:FlxUIDropDownMenu;
    var languagesMenuLabels:Array<StrNameLabel> = [];
    var languagesInputName:FlxInputText;
    var languagesInputSuffix:FlxInputText;
    var languagesAddButton:FlxButton;
    var languagesDeleteButton:FlxButton;
    
    var sectionData:FlxText;
    var sectionDataText:Array<String> = [];

    var saveButton:FlxButton;
    var resetButton:FlxButton;

    var scrollBar:FlxSprite;

    var languages:Array<String>;
    var suffixes:Array<String>;

    var cameraScroll:Float = 0;

    var unsavedProgress:Bool = false;

    override public function create()
    {
		FlxG.sound.music.stop();

		if (ClientPrefs.data.cacheOnGPU) Paths.clearUnusedMemory();

        jsonData = haxe.Json.parse(sys.io.File.getContent(Paths.modFolders('scripts/config/translations.json')));

        defaultData = haxe.Json.parse(sys.io.File.getContent(Paths.modFolders('scripts/config/translations.json')));

		LanguageManager.loadPhrases();

        languages = LanguageManager.languages;
        suffixes = LanguageManager.suffixes;

		saveButton = new FlxButton(20, 0, 'Save', function() 
        {
            saveData();
        });
        add(saveButton);
        saveButton.y = FlxG.height - saveButton.height - 20;

		resetButton = new FlxButton(saveButton.x + saveButton.width + 40, 0, 'Reset', function() 
        {
            jsonData = defaultData;

            reloadKeysMenu();
            reloadLanguagesMenu();
            reloadSectionsMenu();
            showSectionData();
        });
        add(resetButton);
        resetButton.y = FlxG.height - resetButton.height - 20;

        scrollBar = new FlxSprite().makeGraphic(10, 1, FlxColor.GRAY);
        add(scrollBar);
        scrollBar.scrollFactor.set(0, 0);
        scrollBar.x = FlxG.width - scrollBar.width - 5;
        scrollBar.alpha = 0.5;

        sectionData = new FlxText(0, 20, FlxG.width / 2, '');
        sectionData.setFormat(null, 16, FlxColor.WHITE, FlxTextAlign.RIGHT);
        add(sectionData);
        sectionData.x = FlxG.width - sectionData.width - 20;
        sectionData.scrollFactor.set(1, 1);

        createEditorUI();

        showSectionData();
        
        super.create();
    }

    function saveData()
    {
        try {
            Json.parse(jsonData);

            File.saveContent(Paths.modFolders('scripts/config/translations.json'), haxe.Json.stringify(jsonData, null, '    '));
            
            trace("JSON saved successfully.");

            unsavedProgress = false;
        } catch (e:Dynamic) {
            trace("Error: JSON is not valid and was not saved.");
        }
    }

    function createArray(levels:Float, size:Float):Array<Dynamic>
    {
        var result = [];
    
        for (_ in 0...languages.length)
        {
            result.push([]);
        }

        for (_ in 0...Math.floor(levels))
        {
            var currentLevel = [];
    
            if (size > 0)
            {
                for (i in 0...Math.floor(size)) {
                    currentLevel.push([]);
                }
            }
    
            for (i in 0...result.length)
            {
                result[i].push(currentLevel);
            }
        }
    
        return result;
    }        

    var dragingData = {isTrue: false, mouseOffset: 0.0, barY: 0.0};

    var wheelMode:Bool = true;

    override public function update(elapsed:Float)
    {
        if (uiExists) keysCreateArrayPreview.text = 'Array: ' + Std.string(createArray(keysNumberStepperCreateArrayLevels.value, keysNumberStepperCreateArraySize.value)[languages.indexOf(languagesMenu.selectedId)]);
        
        if (FlxG.mouse.overlaps(scrollBar) && FlxG.mouse.justPressed)
        {
            FlxTween.cancelTweensOf(scrollBar);
            FlxTween.tween(scrollBar, {alpha: 1}, 0.25, {ease: FlxEase.cubeOut});

            dragingData.isTrue = true;
            dragingData.mouseOffset = FlxG.mouse.screenY - scrollBar.y;
        }

        if (FlxG.mouse.justReleased) 
        {
            FlxTween.cancelTweensOf(scrollBar);
            FlxTween.tween(scrollBar, {alpha: 0.5}, 0.25, {ease: FlxEase.cubeOut});

            dragingData.isTrue = false;
        }

        if (sectionData.height > FlxG.height)
        {
            if (FlxG.mouse.wheel != 0)
            {
                cameraScroll += FlxG.mouse.wheel * -50;
                dragingData.barY = (cameraScroll * (FlxG.height - scrollBar.height)) / (sectionData.height / 2 + 20);
                wheelMode = true;
            } else if (dragingData.isTrue) {
                dragingData.barY = FlxG.mouse.screenY - dragingData.mouseOffset;
                cameraScroll = (scrollBar.y - 0) / (FlxG.height - scrollBar.height) * (sectionData.height / 2 + 20);
                wheelMode = false;
            }
        }
        
        if (FlxG.keys.justPressed.ESCAPE)
        {
            if (unsavedProgress)
            {
                openSubState(new ExitConfirmationPrompt());
            } else {
                LanguageManager.loadPhrases();
                MusicBeatState.switchState(new ScriptState(CoolVars.globalVars.get("fromEditors")));
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
            }
        }

        if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.S) saveData();

        dragingData.barY = FlxMath.bound(dragingData.barY, 0, FlxG.height - scrollBar.height - 1);

        scrollBar.y = wheelMode ? CoolUtil.fpsLerp(scrollBar.y, dragingData.barY, 0.25) : dragingData.barY;

        cameraScroll = FlxMath.bound(cameraScroll, 0, sectionData.height / 2 + 20);

        FlxG.camera.scroll.y = wheelMode ? CoolUtil.fpsLerp(FlxG.camera.scroll.y, cameraScroll, 0.25) : cameraScroll;

        super.update(elapsed);
    }

    function createEditorUI()
    {
		uiBox = new FlxUITabMenu(null, 
            [
                {name: 'Sections', label: 'Sections'},
                {name: 'Languages', label: 'Languages'},
                {name: 'Keys', label: 'Keys'}
            ],
            true
        );
		uiBox.resize(250, 350);
		uiBox.x = 20;
		uiBox.y = 20;
		uiBox.scrollFactor.set(0, 0);
        add(uiBox);

        createSectionsUI();
        createKeysUI();
        createLanguagesUI();

        uiExists = true;
    }

    function createSectionsUI()
    {
        var tabGroupSections:FlxUI = new FlxUI(null, uiBox);
        tabGroupSections.name = 'Sections';
        
        sectionsInputName = new FlxInputText(20, 75, 200);

        sectionsMenu = new FlxUIDropDownMenu(20, 20, [new StrNameLabel("null", "Null")], function(str:String)
        {
            sectionsInputName.text = str;

            showSectionData();
            reloadKeysMenu();
        });

		sectionsAddButton = new FlxButton(20, 120, 'Add', function() {
            if (!Reflect.hasField(jsonData, sectionsInputName.text)) 
            {
                Reflect.setField(jsonData, sectionsInputName.text, {example: []});

                trace('Added Section: ' + sectionsInputName.text);
            
                var sectionContent = Reflect.field(jsonData, sectionsInputName.text);
                var exampleArray = Reflect.field(sectionContent, 'example');
            
                for (i in 0...suffixes.length)
                {
                    exampleArray.push('data_' + suffixes[i]);
                }
            
                reloadSectionsMenu();
                reloadKeysMenu();
                showSectionData();

                unsavedProgress = true;
            }
        });

		sectionsDeleteButton = new FlxButton(sectionsAddButton.x + sectionsAddButton.width + 40, 120, 'Delete', function() {
            if (sectionsMenuLabels.length > 1)
            {
                if (Reflect.hasField(jsonData, sectionsMenu.selectedId)) 
                {
                    Reflect.deleteField(jsonData, sectionsMenu.selectedId);
        
                    trace('Deleted Section: ' + sectionsInputName.text);
                }
    
                reloadSectionsMenu();
                reloadKeysMenu();
                showSectionData();

                unsavedProgress = true;
            }
        });

        tabGroupSections.add(sectionsAddButton);
        tabGroupSections.add(sectionsDeleteButton);
        tabGroupSections.add(sectionsInputName);
        tabGroupSections.add(sectionsMenu);

        reloadSectionsMenu();

        uiBox.addGroup(tabGroupSections);
    }

    function createKeysUI()
    {
        var tabGroupKeys:FlxUI = new FlxUI(null, uiBox);
        tabGroupKeys.name = 'Keys';
        
        keysInputName = new FlxInputText(20, 75, 200);

        keysCreateArrayPreview = new FlxText(20, keysInputName.y + keysInputName.height + 5, FlxG.width / 2, '');
        keysCreateArrayPreview.setFormat(null, 10, FlxColor.WHITE, FlxTextAlign.LEFT);

		keysNumberStepperCreateArrayLevels = new FlxUINumericStepper(20, keysCreateArrayPreview.y + keysCreateArrayPreview.height + 5, 1, 0, 0);

		keysNumberStepperCreateArraySize = new FlxUINumericStepper(keysNumberStepperCreateArrayLevels.x + keysNumberStepperCreateArrayLevels.width + 40, keysCreateArrayPreview.y + keysCreateArrayPreview.height + 5, 1, 0, 0);

		keysCreateArrayButton = new FlxButton(20, keysNumberStepperCreateArrayLevels.y + keysNumberStepperCreateArrayLevels.height + 5, 'Create Array', function() {
            var sectionContent = Reflect.field(jsonData, sectionsMenu.selectedId);

            if (!Reflect.hasField(sectionContent, keysInputName.text))
            {
                Reflect.setField(sectionContent, keysInputName.text, createArray(keysNumberStepperCreateArrayLevels.value, keysNumberStepperCreateArraySize.value));
                trace('Created Key (' + sectionsMenu.selectedId + '): ' + keysInputName.text + ' = ' + Std.string(createArray(keysNumberStepperCreateArrayLevels.value, keysNumberStepperCreateArraySize.value)[languages.indexOf(languagesMenu.selectedId)]));

                unsavedProgress = true;
            }

            reloadKeysMenu();
            showSectionData();
        });
        
        keysInputString = new FlxInputText(20, keysCreateArrayButton.y + keysCreateArrayButton.height + 10, 200);
        
		keysCreateStringButton = new FlxButton(20, keysInputString.y + keysInputString.height + 5, 'Create String', function() {
            var sectionContent = Reflect.field(jsonData, sectionsMenu.selectedId);

            if (!Reflect.hasField(sectionContent, keysInputName.text))
            {
                Reflect.setField(sectionContent, keysInputName.text, []);

                var key = Reflect.field(sectionContent, keysInputName.text);

                for (i in 0...languages.length)
                {
                    key.push(null);
                }

                key[languages.indexOf(languagesMenu.selectedId)] = keysInputString.text;

                trace('Created Key (' + sectionsMenu.selectedId + '): ' + keysInputName.text + ' = ' + keysInputString.text);

                unsavedProgress = true;
            }

            reloadKeysMenu();
            showSectionData();
        });
        
        keysInputIndex = new FlxInputText(20, keysCreateStringButton.y + keysCreateStringButton.height + 10, 200);
        
		keysPushStringButton = new FlxButton(20, keysInputIndex.y + keysInputIndex.height + 5, 'Push String', function() {
            var sectionContent = Reflect.field(jsonData, sectionsMenu.selectedId);
            var keyContent = Reflect.field(sectionContent, keysMenu.selectedId);

            if (Std.is(CoolUtil.getNestedValue(keyContent, Std.string(languages.indexOf(languagesMenu.selectedId)) + ' ' + keysInputIndex.text), Array))
            {
                CoolUtil.getNestedValue(keyContent, Std.string(languages.indexOf(languagesMenu.selectedId)) + ' ' + keysInputIndex.text).push(keysInputString.text);

                trace('Pushed String (' + keysMenu.selectedId + '): ' + keysInputString.text);

                unsavedProgress = true;
            }

            showSectionData();
        });
        
		keysRemoveStringButton = new FlxButton(keysPushStringButton.x + keysPushStringButton.width + 40, keysInputIndex.y + keysInputIndex.height + 5, 'Remove String', function() {
            var sectionContent = Reflect.field(jsonData, sectionsMenu.selectedId);
            var keyContent = Reflect.field(sectionContent, keysMenu.selectedId);

            if (!Std.is(CoolUtil.getNestedValue(keyContent, Std.string(languages.indexOf(languagesMenu.selectedId)) + ' ' + keysInputIndex.text), Array))
            {
                CoolUtil.removeNestedValue(keyContent, Std.string(languages.indexOf(languagesMenu.selectedId)) + ' ' + keysInputIndex.text);

                trace('Removed String (' + keysMenu.selectedId + '): ' + CoolUtil.getNestedValue(keyContent, Std.string(languages.indexOf(languagesMenu.selectedId)) + ' ' + keysInputIndex.text));

                unsavedProgress = true;
            }

            showSectionData();
        });
        
		keysReplaceStringButton = new FlxButton(20, keysRemoveStringButton.y + keysRemoveStringButton.height + 5, 'Replace String', function() {
            var sectionContent = Reflect.field(jsonData, sectionsMenu.selectedId);
            var keyContent = Reflect.field(sectionContent, keysMenu.selectedId);

            if (!Std.is(CoolUtil.getNestedValue(keyContent, Std.string(languages.indexOf(languagesMenu.selectedId)) + ' ' + keysInputIndex.text), Array))
            {
                trace('Replaced String (' + keysMenu.selectedId + '): ' + CoolUtil.getNestedValue(keyContent, Std.string(languages.indexOf(languagesMenu.selectedId)) + ' ' + keysInputIndex.text) + ' -> ' + keysInputString.text);
            
                CoolUtil.setNestedValue(keyContent, Std.string(languages.indexOf(languagesMenu.selectedId)) + ' ' + keysInputIndex.text, keysInputString.text);

                unsavedProgress = true;
            }

            showSectionData();
        });
        
		keysDeleteButton = new FlxButton(20, keysReplaceStringButton.y + keysReplaceStringButton.height + 10, 'Delete', function() {
            if (keysMenuLabels.length > 1)
            {
                var sectionContent = Reflect.field(jsonData, sectionsMenu.selectedId);
    
                if (Reflect.hasField(sectionContent, keysMenu.selectedId))
                {
                    Reflect.deleteField(sectionContent, keysMenu.selectedId);
    
                    trace('Deleted Key: ' + keysMenu.selectedId);

                    unsavedProgress = true;
                }
    
                reloadKeysMenu();
                showSectionData();
            }
        });

        keysMenu = new FlxUIDropDownMenu(20, 20, [new StrNameLabel("null", "Null")], function(str:String)
        {
            keysInputName.text = str;
            keysInputString.text = '';
            keysInputIndex.text = '';
            keysNumberStepperCreateArrayLevels.value = 0;
            keysNumberStepperCreateArraySize.value = 0;
        });

        tabGroupKeys.add(keysInputName);

        tabGroupKeys.add(keysCreateArrayPreview);
        tabGroupKeys.add(keysNumberStepperCreateArrayLevels);
        tabGroupKeys.add(keysNumberStepperCreateArraySize);
        tabGroupKeys.add(keysCreateArrayButton);

        tabGroupKeys.add(keysInputString);
        tabGroupKeys.add(keysCreateStringButton);
        tabGroupKeys.add(keysInputIndex);
        tabGroupKeys.add(keysPushStringButton);
        tabGroupKeys.add(keysRemoveStringButton);
        tabGroupKeys.add(keysReplaceStringButton);

        tabGroupKeys.add(keysDeleteButton);

        tabGroupKeys.add(keysMenu);

        reloadKeysMenu();

        uiBox.addGroup(tabGroupKeys);
    }

    function createLanguagesUI()
    {
        var tabGroupLanguages:FlxUI = new FlxUI(null, uiBox);
        tabGroupLanguages.name = 'Languages';
        
        languagesInputName = new FlxInputText(20, 75, 200);
        languagesInputSuffix = new FlxInputText(20, languagesInputName.y + languagesInputName.height + 5, 200);

        languagesMenu = new FlxUIDropDownMenu(20, 20, [new StrNameLabel("null", "Null")], function(str:String)
        {
            languagesInputName.text = str;
            languagesInputSuffix.text = suffixes[languages.indexOf(str)];
            
            showSectionData();
        });

		languagesAddButton = new FlxButton(20, 120, 'Add', function() {
            if (languages.length > 0)
            {
                for (section in Reflect.fields(jsonData)) {
                    for (dataKey in Reflect.fields(Reflect.field(jsonData, section))) {
                        var dataArray = cast Reflect.field(Reflect.field(jsonData, section), dataKey);
                        if (Std.is(dataArray, Array)) dataArray.push(null);
                    }
                }

                if (!languages.contains(languagesInputName.text) && !jsonData.languages[0].contains(languagesInputName.text) && !suffixes.contains(languagesInputSuffix.text) && !jsonData.languages[1].contains(languagesInputSuffix.text))
                {
                    trace('Added Language/Suffix: ' + languagesInputName.text + '/' + languagesInputSuffix.text);

                    languages.push(languagesInputName.text);
                    jsonData.languages[0].push(languagesInputName.text);

                    suffixes.push(languagesInputSuffix.text);
                    jsonData.languages[1].push(languagesInputSuffix.text);
                }
                    
                reloadLanguagesMenu();
                showSectionData();

                unsavedProgress = true;
            }
        });

		languagesDeleteButton = new FlxButton(languagesAddButton.x + languagesAddButton.width + 40, 120, 'Delete', function() {
            if (languagesMenuLabels.length > 1)
            {
                for (section in Reflect.fields(jsonData)) {
                    for (dataKey in Reflect.fields(Reflect.field(jsonData, section))) {
                        var dataArray = cast Reflect.field(Reflect.field(jsonData, section), dataKey);
                        if (Std.is(dataArray, Array)) dataArray.splice(languages.indexOf(languagesMenu.selectedId), 1);
                    }
                }

                trace('Deleted Language/Suffix: ' + languagesMenu.selectedId + '/' + suffixes[languages.indexOf(languagesMenu.selectedId)]);
            
                jsonData.languages[0].remove(languagesMenu.selectedId);
                languages.remove(languagesMenu.selectedId);

                jsonData.languages[1].splice(languages.indexOf(languagesMenu.selectedId), 1);
                suffixes.splice(languages.indexOf(languagesMenu.selectedId), 1);

                reloadLanguagesMenu();

                languagesInputName.text = languagesMenu.selectedId;
                languagesInputSuffix.text = suffixes[languages.indexOf(languagesMenu.selectedId)];

                showSectionData();

                unsavedProgress = true;
            }
        });

        tabGroupLanguages.add(languagesAddButton);
        tabGroupLanguages.add(languagesDeleteButton);
        tabGroupLanguages.add(languagesInputName);
        tabGroupLanguages.add(languagesInputSuffix);
        tabGroupLanguages.add(languagesMenu);

        uiBox.addGroup(tabGroupLanguages);

        reloadLanguagesMenu();
    }

    function reloadSectionsMenu()
    {
        sectionsMenuLabels = [];

        for (section in Reflect.fields(jsonData))
        {
            var labelText = section != "languages" && section != null ? section : "Undefined Section";
            if (labelText != "Undefined Section") sectionsMenuLabels.push(new StrNameLabel(labelText, labelText));
        }

        sectionsMenu.setData(sectionsMenuLabels);
    }

    function reloadKeysMenu()
    {
        keysMenuLabels = [];

        var sectionContent = Reflect.field(jsonData, sectionsMenu.selectedId);
        
        if (sectionContent != null) {
            for (key in Reflect.fields(sectionContent))
            {
                keysMenuLabels.push(new StrNameLabel(key, key));
            }
        }

        keysMenu.setData(keysMenuLabels);
    }

    function reloadLanguagesMenu()
    {
        languagesMenuLabels = [];

        for (lang in languages)
        {
            var labelText = lang != null ? lang : "Undefined Language";
            languagesMenuLabels.push(new StrNameLabel(labelText, labelText));
        }

        languagesMenu.setData(languagesMenuLabels);
    }

    function showSectionData()
    {
        sectionDataText = [];

        for (section in Reflect.fields(jsonData))
        {
            if (section == sectionsMenu.selectedId)
            {
                sectionDataText.push(section + ":\n");

                var sectionContent = Reflect.field(jsonData, section);
                
                for (data in Reflect.fields(sectionContent))
                {
                    var values = Reflect.field(sectionContent, data);
                    
                    var valueString = (values.length > 0) ? values[languages.indexOf(languagesMenu.selectedId)] : "N/A";
                    
                    sectionDataText.push(data + ":\n- " + valueString + "\n");
                }
            }
        }

        sectionData.text = sectionDataText.join("\n");
        sectionData.updateHitbox();

        scrollBar.scale.y = sectionData.height / 2 - FlxG.height;
        scrollBar.updateHitbox();
        scrollBar.visible = sectionData.height > FlxG.height;

        dragingData.barY = 0;
        cameraScroll = 0;
    }
}