package Globals 
{
	import flash.media.Camera;
	import Game.Objects.Scroll;
	import Game.States.PlayState;
	import org.flixel.FlxCamera;
	import SoundEngine.SoundBank;
	/**
	 * ...
	 * @author LittleWhite
	 */
	public class GameParams 
	{
		static public var playstate:PlayState;
		static public var soundBank:SoundBank;
		static public var camera:FlxCamera;
		static public var map:Map;
		static public var scroll:Scroll;
		
		/* Can't move these, since it's used in the main */
		static public var width:uint = 1280;
		static public var height:uint = 720;
		
		static public var currentTutoSlide:int = 0;
	}

}