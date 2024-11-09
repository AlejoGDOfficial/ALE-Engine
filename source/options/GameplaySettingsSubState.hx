package options;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = LanguageManager.getPhrase('optionsGameplay', 'Menu');
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplay', 'Downscroll'), //Name
			LanguageManager.getPhrase('optionsGameplay', 'DownscrollDesc'), //Description
			'downScroll', //Save data variable name
			BOOL); //Variable type
		addOption(option);

		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplay', 'GhostTapping'),
			LanguageManager.getPhrase('optionsGameplay', 'GhostTappingDesc'),
			'ghostTapping',
			BOOL);
		addOption(option);
		
		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplay', 'AutoPause'),
			LanguageManager.getPhrase('optionsGameplay', 'AutoPauseDesc'),
			'autoPause',
			BOOL);
		addOption(option);
		option.onChange = onChangeAutoPause;

		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplay', 'DisableResetButton'),
			LanguageManager.getPhrase('optionsGameplay', 'DisableResetButtonDesc'),
			'noReset',
			BOOL);
		addOption(option);

		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplay', 'RatingOffset'),
			LanguageManager.getPhrase('optionsGameplay', 'RatingOffsetDesc'),
			'ratingOffset',
			INT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplay', 'SickHitWindow'),
			LanguageManager.getPhrase('optionsGameplay', 'SickHitWindowDesc'),
			'sickWindow',
			INT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplay', 'GoodHitWindow'),
			LanguageManager.getPhrase('optionsGameplay', 'GoodHitWindowDesc'),
			'goodWindow',
			INT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplay', 'BadHitWindow'),
			LanguageManager.getPhrase('optionsGameplay', 'BadHitWindowDesc'),
			'badWindow',
			INT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option(LanguageManager.getPhrase('optionsGameplay', 'SafeFrames'),
			LanguageManager.getPhrase('optionsGameplay', 'SafeFramesDesc'),
			'safeFrames',
			FLOAT);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		super();
	}

	function onChangeAutoPause()
		FlxG.autoPause = ClientPrefs.data.autoPause;
}