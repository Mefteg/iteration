package Resources 
{
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
		public static var ImgPlnt:FlxExtBitmap;
		public static var ImgHeart:FlxExtBitmap;
		public static var ImgHeartHalo:FlxExtBitmap;
		public static var ImgHeartBack:FlxExtBitmap;
		
		public static var ImgTreeGrow:FlxExtBitmap;
		public static var ImgTreeDie:FlxExtBitmap;
		public static var ImgBlobby:FlxExtBitmap;
		public static var ImgMeteor:FlxExtBitmap;
		public static var ImgMeteorLife:FlxExtBitmap;
		public static var ImgExplosionMeteor:FlxExtBitmap;
		
		public static var ImgCloud:FlxExtBitmap;
		public static var ImgCloud2:FlxExtBitmap;
		//public static var ImgIdeaWar:FlxExtBitmap;
		
		public static var BufferTreeGrow:Tree;
		//background
		[Embed(source = "../../bin/img/fond.jpg")] public static var ImgBackground:Class;
						
		
		[Embed(source = "../../bin/img/idee_guerre.png")] public static var ImgIdeaWar:Class;
		
		
	}

}