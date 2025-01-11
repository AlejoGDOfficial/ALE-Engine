package gameplay.camera;

class CustomFadeTransition extends utils.scripting.ScriptSubstate
{
	public static var finishCallback:Void -> Void;

	var transIn:Bool;

	override public function new(transIn:Bool)
	{
		super(CoolVars.scriptTransition);

		this.transIn = transIn;
	}

	override function create()
	{
		super.create();

		callOnScripts(transIn ? 'onTransitionIn' : 'onTransitionOut');
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