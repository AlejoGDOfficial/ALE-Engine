import flixel.util.FlxGradient;

var transBlack:FlxSprite;
var transGradient:FlxSprite;

function onCreate()
{
	game.cameras = [FlxG.cameras.list[FlxG.cameras.list.length-1]];

	var width:Int = Std.int(FlxG.width / Math.max(camera.zoom, 0.001));
	var height:Int = Std.int(FlxG.height / Math.max(camera.zoom, 0.001));

	transGradient = FlxGradient.createGradientFlxSprite(1, height, (transOut ? [0x0, FlxColor.BLACK] : [FlxColor.BLACK, 0x0]));
	transGradient.scale.x = width;
	transGradient.updateHitbox();
	transGradient.scrollFactor.set();
	transGradient.screenCenter('x');
	add(transGradient);

	transBlack = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
	transBlack.scale.set(width, height + 400);
	transBlack.updateHitbox();
	transBlack.scrollFactor.set();
	transBlack.screenCenter('x');
	add(transBlack);

	if (transOut) transGradient.y = transBlack.y - transBlack.height;
	else transGradient.y = -transGradient.height;
}

function onUpdate(elapsed:Float)
{
	final height:Float = FlxG.height * Math.max(camera.zoom, 0.001);
	final targetPos:Float = transGradient.height + 50 * Math.max(camera.zoom, 0.001);
	
	transGradient.y += (height + targetPos) * elapsed / 0.6;

	if (transOut) transBlack.y = transGradient.y + transGradient.height;
	else transBlack.y = transGradient.y - transBlack.height;

	if (transGradient.y >= targetPos)
	{
		close();
	}
}