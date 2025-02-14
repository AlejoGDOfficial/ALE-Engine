package utils.scripting;

class ScriptTransition extends ScriptSubstate
{
	public static var finishCallback:Void -> Void;

	public var transIn:Bool;
	public var transOut:Bool;

	public static var instance:ScriptTransition = null;

	override public function new(transIn:Bool)
	{
		super(transIn ? CoolVars.transitionIn : CoolVars.transitionOut);

		this.transIn = transIn;
		this.transOut = !transIn;
	}

	override function create()
	{
		instance = this;

		super.create();

		setOnScripts('transIn', transIn);
		setOnScripts('transOut', transOut);
	}

	override function close()
	{
		instance = null;

		if (finishCallback != null)
		{
			if (transIn) finishCallback();
			finishCallback = null;
		}

		super.close();
	}
}