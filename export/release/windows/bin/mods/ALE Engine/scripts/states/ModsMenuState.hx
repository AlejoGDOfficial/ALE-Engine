import backend.Mods;

function onCreate()
{
    Mods.pushGlobalMods();

    var destinationY:Int = 0;

    for (mod in Mods.globalMods)
    {
        var songText:Alphabet = new Alphabet(20, destinationY, mod, true);
        songText.snapToPosition();
        add(songText);
        destinationY += 100;
    }
}