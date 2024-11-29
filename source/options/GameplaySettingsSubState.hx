package options;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Gameplay Settings';
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll',
			'If checked, notes go Down insted of Up, simple enough.',
			'downScroll', //Save data variable name
			BOOL); //Variable type
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			'If checked, you won\'t get misses from pressing keys while there are no notes able to be hit.',
			'ghostTapping',
			BOOL);
		addOption(option);
		
		var option:Option = new Option('Auto Pause',
			'If checked, the game automatically pauses if the screen isn\'t on focus.',
			'autoPause',
			BOOL);
		addOption(option);
		option.onChange = onChangeAutoPause;

		var option:Option = new Option('Disable Reset Button',
			'If checked, pressing Reset won\'t do anything.',
			'noReset',
			BOOL);
		addOption(option);

		var option:Option = new Option('Rating Offset',
			'Changes how late/early you have to hit for a Sick!! Higher values mean you have to hit later.',
			'ratingOffset',
			INT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option('Sick!! Hit Window',
			'Changes the amount of time you have for hitting a Sick!! in milliseconds.',
			'sickWindow',
			INT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option('Good! Hit Window',
			'Changes the amount of time you have for hitting a Good! in milliseconds.',
			'goodWindow',
			INT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option('Bad Hit Window',
			'Changes the amount of time you have for hitting a Bad in milliseconds.',
			'badWindow',
			INT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option('Safe Frames',
			'Changes how many frames you have for hitting a note earlier or late.',
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