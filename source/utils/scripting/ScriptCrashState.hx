package utils.scripting;

import haxe.CallStack.StackItem;
import flixel.util.typeLimit.OneOfTwo;

class ScriptCrashState extends ScriptState 
{
    var EMessage:String;
    var callstack:OneOfTwo<Array<StackItem>,String>;
    var isCritical:Bool;
        
    var error:CrashData;

    public function new(EMessage:String, callstack:OneOfTwo<Array<StackItem>,String>)
    {
        this.EMessage = EMessage;
        this.callstack = callstack;
        isCritical = Std.isOfType(callstack, Array);

        super(CoolVars.scriptCrashState);
    }

    override function create()
    {
        if (Std.isOfType(callstack,Array))
        {
            error = collectErrorData();
        } else {
            var message = cast (callstack,String);
            var tbl = new Array<Array<String>>();

            for (x in message.split("\n"))
            {
                tbl.push([x]);
            }
            
            error = {
                logToFile: false,
                extendedTrace: [],
                trace: tbl,
                message: EMessage,
                date: Date.now().toString(),
                systemName: #if android 'Android' #elseif linux 'Linux' #elseif mac 'macOS' #elseif windows 'Windows' #else 'iOS' #end,
                activeMod: utils.mods.Mods.currentModDirectory
            };
        }

        super.create();
        
        setOnScripts('error', error);
        setOnScripts('EMessage', EMessage);
        setOnScripts('callstack', callstack);
        setOnScripts('isCritical', isCritical);

        setOnScripts('collectErrorData', collectErrorData);
    }

    function collectErrorData():CrashData
    {
        var errorMessage = EMessage;

        var callStack:Array<StackItem> = callstack;
        var errMsg = new Array<Array<String>>();
        var errExtended = new Array<String>();

        for (stackItem in callStack)
        {
            switch (stackItem)
            {
                case FilePos(s, file, pos_line, column):
                    var line = new Array<String>();
                    switch (s)
                    {
                        case Module(m):
                            line.push("MD:" + m);
                        case CFunction:
                            line.push("Native function");
                        case Method(classname, method):
                            var regex = ~/(([A-Z]+[A-z]*)\.?)+/g;
                            regex.match(classname);
                            line.push("CLS:" + regex.matched(0)+":"+method+"()");
                        default:
                            Sys.println(stackItem);
                    }
                    line.push("Line:" + pos_line);
                    errMsg.push(line);
                    errExtended.push('In file ${file}: ${line.join("  ")}');
                default:
                    Sys.println(stackItem);
            }
        }

        return {
            logToFile: true,
            message: errorMessage,
            trace: errMsg,
            extendedTrace: errExtended,
            date: Date.now().toString(),
            systemName: #if android 'Android' #elseif linux 'Linux' #elseif mac 'macOS' #elseif windows 'Windows' #else 'iOS' #end,
            activeMod: utils.mods.Mods.currentModDirectory
        }
    }

	override public function resetScriptState(?doTransition:Bool = false)
	{
		FlxTransitionableState.skipNextTransIn = !doTransition;
		FlxTransitionableState.skipNextTransOut = !doTransition;
		MusicBeatState.switchState(new ScriptCrashState(EMessage, callstack));
	}
}

typedef CrashData =
{
    logToFile:Bool,
    message:String,
    trace:Array<Array<String>>,
    extendedTrace:Array<String>,
    date:String,
    systemName:String,
    activeMod:String
}