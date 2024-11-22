function onStepHit()
{
    if (curStep % 16 == 0 || curStep % 16 == 6 || curStep % 16 == 12)
    {
        camGame.zoom += 0.025;
        camHUD.zoom += 0.025;
    }
}