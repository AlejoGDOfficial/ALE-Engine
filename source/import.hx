#if !macro
import core.config.DiscordClient;

import core.music.Conductor;

import visuals.stages.BaseStage;

import core.backend.Controls;
import core.backend.MusicBeatState;
import core.backend.MusicBeatSubState;

import utils.save.ClientPrefs;

import game.states.PlayState;
import game.states.LoadingState;

import utils.helpers.Difficulty;
import utils.helpers.CoolUtil;
import utils.helpers.CoolVars;
import utils.helpers.Paths;

import core.backend.Mods;

import game.states.ScriptState;
import game.substates.ScriptSubState;

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

#if !cpp import lime.utils.Assets as FileSystem; #end

#if flxanimate
import flxanimate.*;
#end

#if mobile
import utils.helpers.StorageUtil;
#end

using StringTools;
#end
