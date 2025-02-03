package visuals.objects;

class AttachedSprite extends FlxSprite
{
	public var sprTracker:Dynamic;
	public var xAdd:Float = 0;
	public var yAdd:Float = 0;
	public var widthAdd:Float = 0;
	public var heightAdd:Float = 0;
	public var widthMultiplier:Float = 0;
	public var heightMultiplier:Float = 0;
	public var angleAdd:Float = 0;
	public var alphaMult:Float = 1;

	public var copyAngle:Bool = true;
	public var copyAlpha:Bool = true;
	public var copyVisible:Bool = false;
	public var copySize:Bool = false;

	public function new(?file:String = null, ?anim:String = null, ?library:String = null, ?loop:Bool = false, ?x:Float = 0, ?y:Float = 0)
	{
		super(x, y);

		if(anim != null) {
			frames = Paths.getSparrowAtlas(file, library);
			animation.addByPrefix('idle', anim, 24, loop);
			animation.play('idle');
		} else if (file != null) {
			loadGraphic(Paths.image(file));
		}
		antialiasing = ClientPrefs.data.antialiasing;
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null) {
			setPosition(sprTracker.x + xAdd, sprTracker.y + yAdd);
			scrollFactor.set(sprTracker.scrollFactor.x, sprTracker.scrollFactor.y);

			if(copyAngle)
				angle = sprTracker.angle + angleAdd;

			if(copyAlpha)
				alpha = sprTracker.alpha * alphaMult;

			if(copyVisible) 
				visible = sprTracker.visible;

			if(copySize)
			{
				width = sprTracker.width * widthMultiplier + widthAdd;
				height = sprTracker.height * heightMultiplier + heightAdd;
			}
		}
	}
}
