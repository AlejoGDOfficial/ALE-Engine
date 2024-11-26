package substates;

import backend.Mods;

import objects.Alphabet;

import flixel.effects.FlxFlicker;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

class ModsMenuSubState extends MusicBeatSubstate
{
    var bg:FlxBackdrop;

    var texts:Array<Alphabet> = [];

    override public function create()
    {
        FlxG.camera.zoom = 1;

        bg = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, CoolUtil.colorFromString('443C4E'), CoolUtil.colorFromString('574E64')));
        add(bg);
        bg.scrollFactor.set(0.25, 0.25);
    
        var destinationX:Int = 100;
        var destinationY:Int = 285;
    
        Mods.pushGlobalMods();
    
        for (mod in Mods.getGlobalMods())
        {
            var text:Alphabet = new Alphabet(destinationX, destinationY, mod, true);
            text.snapToPosition();
            add(text);
            texts.push(text);
    
            destinationX += 25;
            destinationY += 100;
        }

        if (Mods.getGlobalMods().length < 1) close();
    
        changeShit();

        super.create();
    }
    
    var selInt:Int = 0;
    var canSelect:Bool = true;
    
    override public function update(elapsed:Float)
    {
        bg.y -= elapsed * 100;
        bg.x -= elapsed * 100;
        
        if (canSelect)
        {
            if (controls.UI_UP_P || controls.UI_DOWN_P || FlxG.mouse.wheel != 0)
            {
                if (controls.UI_UP_P || FlxG.mouse.wheel > 0)
                {
                    if (selInt > 0)
                    {
                        selInt -= 1;
                    } else if (selInt == 0) {
                        selInt = texts.length - 1;
                    }
                } else if (controls.UI_DOWN_P || FlxG.mouse.wheel < 0) {
                    if (selInt < texts.length - 1)
                    {
                        selInt += 1;
                    } else if (selInt == texts.length -1) {
                        selInt = 0;
                    }
                }
        
                changeShit();
            }
    
            if (controls.ACCEPT)
            {
                canSelect = false;
        
                FlxFlicker.flicker(texts[selInt], 0, 0.05);
        
                for (i in 0...texts.length)
                {
                    if (i != selInt)
                    {
                        FlxTween.tween(texts[i], {alpha: 0}, 120 / Conductor.bpm, {ease: FlxEase.cubeOut});
                    }
                }
        
                FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
        
                new FlxTimer().start(1, function(tmr:FlxTimer)
                {
                    Mods.currentModDirectory = texts[selInt].text;
                    ClientPrefs.data.currentModFolder = Mods.currentModDirectory;
                    ClientPrefs.saveSettings();
    
                    CoolUtil.resetEngine();
    
                    close();
                });
            }
    
            if (controls.BACK) close();
        }
    
        FlxG.camera.scroll.y = CoolUtil.fpsLerp(FlxG.camera.scroll.y, selInt * 100, 0.1);
        FlxG.camera.scroll.x = CoolUtil.fpsLerp(FlxG.camera.scroll.x, selInt * 25, 0.1);

        super.update(elapsed);
    }
    
    private function changeShit()
    {
        for (i in 0...texts.length)
        {
            if (i == selInt) texts[i].alpha = 1;
            else texts[i].alpha = 0.25;
        }
    
        if (Mods.getGlobalMods().length > 1) FlxG.sound.play(Paths.sound('scrollMenu'));
    }

    override public function beatHit()
    {
        if (curBeat % 2 == 1)
        {
            if (bg.angle >= 360) bg.angle = 0;
    
            FlxTween.tween(bg, {angle: bg.angle + 90}, 90 / Conductor.bpm, {ease:FlxEase.cubeOut});
        }

        super.beatHit();
    }
}
