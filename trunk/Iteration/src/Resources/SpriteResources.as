package Resources 
{
	import flash.display.BitmapData;
	import flash.text.engine.EastAsianJustifier;
	import Game.Objects.*;
	import org.flixel.FlxExtBitmap;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author LittleWhite
	 */
	public class SpriteResources 
	{
		public static var ImgPlnt:FlxExtBitmap ;
		public static var ImgHeart:FlxExtBitmap;
		public static var ImgHeartHalo:FlxExtBitmap;
		public static var ImgHeartBack:FlxExtBitmap;
		public static var ImgHeartDeath:FlxExtBitmap;
		
		public static var ImgTreeGrow:FlxExtBitmap;
		public static var ImgTreeDie:FlxExtBitmap;
		public static var ImgTreeRoots:FlxExtBitmap;
		public static var ImgFruit:FlxExtBitmap;
		
		public static var ImgBlobby:FlxExtBitmap;
		
		public static var ImgMeteor:FlxExtBitmap;
		public static var ImgMeteorLife:FlxExtBitmap;
		public static var ImgExplosionMeteor:FlxExtBitmap;
		
		public static var ImgCloud:FlxExtBitmap;
		public static var ImgCloud2:FlxExtBitmap;
		
		public static var ImgIdeaBubble:FlxExtBitmap;
		public static var ImgIdeas:FlxExtBitmap;
		
		public static var BufferTreeGrow:Tree;
		//background
		public static var ImgBackground:FlxExtBitmap;
		public static var ImgForeground:FlxExtBitmap;
		
		//buffers
		public static var BufferPlanet:BitmapData;
		
		public static var animateIdea:Array = [ -2, 0, 2, 0];
		public static var arrayIdeas:Object = {
										religion:[1],
										paix:[2],
										medecine:[3],
										guerre:[5],
										fanatisme:[6],
										maladie:[7]
										};
		public static var arrayIdeasColor:Object = {
										religion:0xff5b67,
										paix:0xFFFFFF,
										medecine:0xe93a3e,
										guerre:0xb0b0b0,
										fanatisme:0xff6f26,
										maladie:0xf1a71d
										};
		
	}

}