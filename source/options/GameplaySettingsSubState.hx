package options;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = LanguageManager.getPhrase('optionsGameplayMenu');
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplayDownscroll'), //Name
			LanguageManager.getPhrase('optionsGameplayDownscrollDesc'), //Description
			'downScroll', //Save data variable name
			'bool'); //Variable type
		addOption(option);

		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplayGhostTapping'),
			LanguageManager.getPhrase("optionsGameplayGhostTappingDesc"),
			'ghostTapping',
			'bool');
		addOption(option);
		
		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplayAutoPause'),
			LanguageManager.getPhrase('optionsGameplayAutoPauseDesc'),
			'autoPause',
			'bool');
		addOption(option);
		option.onChange = onChangeAutoPause;

		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplayDisableResetButton'),
			LanguageManager.getPhrase('optionsGameplayDisableResetButtonDesc'),
			'noReset',
			'bool');
		addOption(option);

		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplayRatingOffset'),
			LanguageManager.getPhrase('optionsGameplayRatingOffsetDesc'),
			'ratingOffset',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplaySickHitWindow'),
			LanguageManager.getPhrase('optionsGameplaySickHitWindowDesc'),
			'sickWindow',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplayGoodHitWindow'),
			LanguageManager.getPhrase('optionsGameplayGoodHitWindowDesc'),
			'goodWindow',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplayBadHitWindow'),
			LanguageManager.getPhrase('optionsGameplayBadHitWindowDesc'),
			'badWindow',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplaySafeFrames'),
			LanguageManager.getPhrase('optionsGameplaySafeFramesDesc'),
			'safeFrames',
			'float');
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		super();
	}

	function onChangeHitsoundVolume()
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);

	function onChangeAutoPause()
		FlxG.autoPause = ClientPrefs.data.autoPause;
}