#if !macro
import core.config.ClientPrefs;
import core.config.Discord;
import core.gameplay.Conductor;
import core.backend.BaseStage;
import core.backend.Controls;
import core.backend.MusicBeatState;
import core.backend.MusicBeatSubstate;

import gameplay.states.game.PlayState;
import gameplay.states.game.LoadingState;
import gameplay.camera.CustomFadeTransition;

import utils.helpers.CoolUtil;
import utils.helpers.CoolVars;
import utils.helpers.Paths;
import utils.helpers.Difficulty;
import utils.mods.Mods;
import utils.scripting.ScriptState;
import utils.scripting.ScriptSubstate;

import visuals.objects.Alphabet;
import visuals.objects.BGSprite;

import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;

#if LUA_ALLOWED
import llua.*;
import llua.Lua;
#end

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

#if flxanimate
import flxanimate.*;
#end

#if mobile
import utils.helpers.StorageUtil;
#end

using StringTools;
#end
