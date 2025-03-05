package core.config;

import Sys.sleep;
import lime.app.Application;
#if DISCORD_ALLOWED
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;
#end
class DiscordClient
{
	public static var isInitialized:Bool = false;
	private static var _defaultID:String;
	public static var clientID(default, set):String;
	private static var presence:#if DISCORD_ALLOWED DiscordRichPresence #else Dynamic #end = #if DISCORD_ALLOWED DiscordRichPresence.create() #else null #end;

	public static function check()
	{
		#if DISCORD_ALLOWED
		if(ClientPrefs.data.discordRPC) initialize();
		else if(isInitialized) shutdown();
		#end
	}
	
	public static function prepare()
	{
		#if DISCORD_ALLOWED
		if (!isInitialized && ClientPrefs.data.discordRPC)
			initialize();

		Application.current.window.onClose.add(function() {
			if(isInitialized) shutdown();
		});

		_defaultID = CoolVars.discordID;
		clientID = CoolVars.discordID;
		#end
	}

	public dynamic static function shutdown() {
		#if DISCORD_ALLOWED
		Discord.Shutdown();
		#end
		isInitialized = false;
	}
	
	#if DISCORD_ALLOWED
	private static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void {
		var requestPtr:cpp.Star<DiscordUser> = cpp.ConstPointer.fromRaw(request).ptr;

		if (Std.parseInt(cast(requestPtr.discriminator, String)) != 0) //New Discord IDs/Discriminator system
			trace('(Discord) Connected to User (${cast(requestPtr.username, String)}#${cast(requestPtr.discriminator, String)})');
		else //Old discriminators
			trace('(Discord) Connected to User (${cast(requestPtr.username, String)})');

		changePresence();
	}
	#end

	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void {
		#if DISCORD_ALLOWED
		trace('Discord: Error ($errorCode: ${cast(message, String)})');
		#end
	}

	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void {
		#if DISCORD_ALLOWED
		trace('Discord: Disconnected ($errorCode: ${cast(message, String)})');
		#end
	}

	public static function initialize()
	{
		#if DISCORD_ALLOWED
		var discordHandlers:DiscordEventHandlers = DiscordEventHandlers.create();
		discordHandlers.ready = cpp.Function.fromStaticFunction(onReady);
		discordHandlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		discordHandlers.errored = cpp.Function.fromStaticFunction(onError);
		Discord.Initialize(clientID, cpp.RawPointer.addressOf(discordHandlers), 1, null);

		if(!isInitialized) trace("Discord Client initialized");

		sys.thread.Thread.create(() ->
		{
			var localID:String = clientID;
			while (localID == clientID)
			{
				#if DISCORD_DISABLE_IO_THREAD
				Discord.UpdateConnection();
				#end
				Discord.RunCallbacks();

				// Wait 0.5 seconds until the next loop...
				Sys.sleep(0.5);
			}
		});
		isInitialized = true;
		#end
	}

	public static function changePresence(?details:String = 'In the Menus', ?state:Null<String>, ?smallImageKey : String, ?hasStartTimestamp : Bool, ?endTimestamp: Float)
	{
		#if DISCORD_ALLOWED
		var startTimestamp:Float = 0;
		if (hasStartTimestamp) startTimestamp = Date.now().getTime();
		if (endTimestamp > 0) endTimestamp = startTimestamp + endTimestamp;

		presence.details = details;
		presence.state = state;
		presence.largeImageKey = 'icon';
		presence.largeImageText = "Engine Version: " + CoolVars.engineVersion;
		presence.smallImageKey = smallImageKey;
		presence.startTimestamp = Std.int(startTimestamp / 1000);
		presence.endTimestamp = Std.int(endTimestamp / 1000);
		updatePresence();
		#end
	}

	public static function updatePresence()
	{
		#if DISCORD_ALLOWED 
		Discord.UpdatePresence(cpp.RawConstPointer.addressOf(presence)); 
		#end
	}
	
	public static function resetClientID()
	{
		#if DISCORD_ALLOWED 
		clientID = _defaultID; 
		#end
	}

	private static function set_clientID(newID:String)
	{
		#if DISCORD_ALLOWED
		var change:Bool = (clientID != newID);
		clientID = newID;

		if(change && isInitialized)
		{
			shutdown();
			initialize();
			updatePresence();
		}
		#end
		return newID;
	}

	public static function addLuaCallbacks(#if LUA_ALLOWED lua:State #else Dynamic #end) {
		#if (LUA_ALLOWED && DISCORD_ALLOWED) 
		Lua_helper.add_callback(lua, "changeDiscordPresence", function(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float) {
			changePresence(details, state, smallImageKey, hasStartTimestamp, endTimestamp);
		});
		#end
	}
}