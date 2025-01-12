package utils.scripting;

class ScriptTransition extends ScriptSubstate
{
	public static var finishCallback:Void -> Void;

	public var transIn:Bool;

	public static var instance:ScriptTransition;

	override public function new(transIn:Bool)
	{
		super(CoolVars.scriptTransition);

		this.transIn = transIn;

		var jsonToLoad:String = Paths.modFolders('data.json');
		if(!FileSystem.exists(jsonToLoad)) jsonToLoad = Paths.getSharedPath('data.json');
		
		var jsonData = haxe.Json.parse(sys.io.File.getContent(jsonToLoad));

        CoolVars.scriptTransition = Reflect.hasField(jsonData, 'transition') ? jsonData.transition : 'fadeTransition';
	}

	override function create()
	{
		instance = this;

		super.create();
	}

	override function close()
	{
		super.close();

		if (finishCallback != null)
		{
			finishCallback();
			finishCallback = null;
		}
	}
}