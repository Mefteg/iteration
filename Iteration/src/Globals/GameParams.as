package Globals 
{
	import flash.media.Camera;
	import org.flixel.FlxCamera;
	/**
	 * ...
	 * @author LittleWhite
	 */
	public class GameParams 
	{
		static public var camera:FlxCamera;
		static public var width:uint = 1280;
		static public var height:uint = 720;
		static public var scale:Number = 0.4096;
		static public var scaleCloud:Number = 1;
		
		static public var nbTrees:uint = 10;
		static public var nbClouds:uint = 6;
		
		static public var planetRadius:uint = 350;
		
		static public var worldZoomMax:Number = 1;
		static public var worldZoomMin:Number = 0.4;
		static public var worldZoom:Number = worldZoomMin;

	}

}