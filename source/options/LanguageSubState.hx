package options;

import debug.FPSCounter;

class LanguageSubState extends MusicBeatSubstate
{
	var grpLanguages:FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();
	public static var languages:Array<String> = LanguageManager.languages;
	public static var curSelected:Int = 0;
	
	function capitalizeAndRemoveSpaces(input:String):String {
		var words = input.split(" ");
		var result = "";
		
		for (i in 0...words.length) {
			if (words[i] != "") {
				result += words[i].substr(0, 1).toUpperCase() + words[i].substr(1).toLowerCase();
			}
		}
	
		return result;
	}

	public function new()
	{
		super();

		var bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.screenCenter();
		add(bg);
		add(grpLanguages);

		for (lang in languages)
		{
			var name:String = languages[languages.indexOf(lang)];
			if(name == null) name = lang;

			var text:Alphabet = new Alphabet(0, 300, LanguageManager.getPhrase('optionsLanguage', capitalizeAndRemoveSpaces(name)), true);
			text.isMenuItem = true;
			text.targetY = languages.indexOf(lang);
			text.changeX = false;
			text.distancePerItem.y = 100;
			if(languages.length < 7)
			{
				text.changeY = false;
				text.screenCenter(flixel.util.FlxAxes.Y);
				text.y += (100 * (languages.indexOf(lang) - (languages.length / 2))) + 45;
			}
			text.screenCenter(flixel.util.FlxAxes.X);
			grpLanguages.add(text);
		}
		
		changeSelected();
	}

	var changedLanguage:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var mult:Int = (FlxG.keys.pressed.SHIFT) ? 4 : 1;
		if(controls.UI_UP_P)
			changeSelected(-1 * mult);
		if(controls.UI_DOWN_P)
			changeSelected(1 * mult);
		if(FlxG.mouse.wheel != 0)
			changeSelected(FlxG.mouse.wheel * mult);

		if(controls.BACK)
		{
			if(changedLanguage)
			{
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				MusicBeatState.resetState();
			}
			else close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.6);
			ClientPrefs.data.language = languages[curSelected];
			//trace(ClientPrefs.data.language);
			ClientPrefs.saveSettings();
			LanguageManager.curLanguage = languages[curSelected];
			changedLanguage = true;
		}
	}

	function changeSelected(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, languages.length-1);
		for (num => lang in grpLanguages)
		{
			lang.targetY = num - curSelected;
			lang.alpha = 0.6;
			if(num == curSelected) lang.alpha = 1;
		}
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
	}
}