package backend;

class CoolVars
{
	public static var _developerMode:Bool = true;

	public static var initialState:String = '';
	public static var fromPlayStateIfStoryMode:String = '';
	public static var fromPlayStateIfFreeplay:String = '';
	public static var fromEditors:String = '';
	public static var fromOptions:String = '';

	public static var reconfigureData:Array<Dynamic> = [true, initialState];
	public static var scriptInitialConfig:Bool = true;
}