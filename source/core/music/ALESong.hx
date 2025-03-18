package core.music;

typedef ALESong =
{
    var song:String;
    var needsVoices:Bool;
    
    var bpm:Float;
    var beats:Int;
    var steps:Int;
    
    var sections:Array<ALESection>;
    var events:Array<Dynamic>;
    var speed:Float;

    var characters:Array<String>;
    var extras:Array<String>;
    var stage:String;

    var format:String;
	
	@:optional var disableNoteRGB:Bool;

	@:optional var arrowSkin:String;
	@:optional var splashSkin:String;

	@:optional var metadata:Dynamic;
	@:optional var gameOverScript:String;
	@:optional var pauseScript:String;
}

typedef ALESection = {
    var notes:Array<Array<Float>>;

    var mustHitSection:Bool;
}