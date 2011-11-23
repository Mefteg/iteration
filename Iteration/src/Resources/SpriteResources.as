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
		public static var ImgCrack:FlxExtBitmap;
		
		public static var ImgTreeGrow:FlxExtBitmap;
		public static var ImgTreeGrow2:FlxExtBitmap;
		public static var ImgTreeDie:FlxExtBitmap;
		public static var ImgTreeDie2:FlxExtBitmap;
		public static var ImgTreeRoots:FlxExtBitmap;
		public static var ImgFruit:FlxExtBitmap;
		
		public static var ImgBlobby:FlxExtBitmap;
		public static var ImgBlobbyRunLeft:FlxExtBitmap;
		
		public static var ImgMeteor:FlxExtBitmap;
		public static var ImgMeteorLife:FlxExtBitmap;
		public static var ImgExplosionMeteor:FlxExtBitmap;
		
		public static var ImgCloud:FlxExtBitmap;
		public static var ImgCloud2:FlxExtBitmap;
		public static var ImgRain:FlxExtBitmap;
		
		public static var ImgIdeaBubble:FlxExtBitmap;
		public static var ImgIdeas:FlxExtBitmap;
		
		public static var BufferTreeGrow:Tree;
		//background
		public static var ImgBackground:FlxExtBitmap;
		public static var ImgForeground:FlxExtBitmap;
		
		//image scroll
		public static var ImgScroll:FlxExtBitmap;
		
		// mouse cursor
		//public static var ImgMouseCursor:FlxExtBitmap;
		[Embed(source="../../bin/img/curseur_etat_normal.png")] public static var ImgMouseCursor:Class;
		[Embed(source = "../../bin/img/curseur_clic.png")] public static var ImgMouseCursorClic:Class;
		
		[Embed(source = "../../bin/img/HelveticaLTStd-Light.otf", fontFamily = "myFont", embedAsCFF = "false")] public var helv:String;
		
		// menu
		public static var ImgMenuBackground:FlxExtBitmap;
		public static var ImgMenuPlaybutton:FlxExtBitmap;
		public static var ImgMenuCreditbutton:FlxExtBitmap;
		public static var ImgMenuTutobutton:FlxExtBitmap;
		
		// credits
		public static var ImgCreditBackground:FlxExtBitmap;
		public static var ImgCreditBackbutton:FlxExtBitmap;
		
		public static var ImgTuto:FlxExtBitmap;
		
		//buffers
		public static var BufferPlanet:BitmapData;
		
		public static var animateIdea:Array = [ -2, 0, 2, 0];
		public static var arrayIdeas:Object = {
										religion:[0],
										paix:[1],
										medecine:[2],
										guerre:[4],
										fanatisme:[3],
										maladie:[5]
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