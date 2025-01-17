import gameplay.states.game.PlayState;
import visuals.objects.Alphabet;
import flixel.util.FlxSpriteUtil;

function onCreate()
{
    FlxG.sound.music.pause();

    printError();
}

function printError()
{
    var rpadLenght = '';

    for (data in error.trace)
    {
        switch (data.length)
        {
            case 2:
                if (data[0].length > rpadLenght.length) rpadLenght = data[0];
        }
    }
    
    var errorRpadLenght = '';

    for (data in error.trace)
    {
        switch (data.length)
        {
            case 2:
                var daString = StringTools.replace(StringTools.rpad(data[0], ' ', rpadLenght.length + 3), 'CLS:', '') + data[1];
                if (daString.length > errorRpadLenght.length) errorRpadLenght = daString;
        }
    }

    createErrorText('ALE Engine (' + CoolVars.engineVersion + ') Crash Handler\n' + error.message);

    for (data in error.trace)
    {
        switch (data.length)
        {
            case 1:
                createErrorText(data[0]);
            case 2:
                createErrorText(StringTools.rpad(StringTools.replace(StringTools.rpad(data[0], ' ', rpadLenght.length + 3), 'CLS:', '') + data[1], ' ', errorRpadLenght.length));
            default:
                createErrorText(' ');
        }
    }

    var remainingLines = 12 - error.trace.length;
    
    if (remainingLines > 0)
    {
        for (_ in 0...remainingLines) createErrorText(' ');
    }

    createErrorText('');
    createErrorText('RUNTIME INFORMATION');

    createErrorText('TIME: ' + error.date.split(' ')[1] + '    DATE: ' + error.date.split(' ')[0]);
    createErrorText('MOD: ' + error.activeMod + '    Sys: ' + error.systemName);
}

var yPos = 100;

function createErrorText(string:String)
{
    var text = new FlxText(100, yPos, FlxG.width - 100, string);
    text.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, 'center');
    add(text);
    text.antialiasing = ClientPrefs.data.antialiasing;

    yPos += text.height + 5;
}