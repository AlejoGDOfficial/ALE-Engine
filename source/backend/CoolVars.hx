package backend;

import haxe.ds.StringMap;

class CoolVars
{
	public static var globalVars:StringMap<Dynamic> = new StringMap<Dynamic>();

	public static var fpsTextWasAdded:Bool = false;
}