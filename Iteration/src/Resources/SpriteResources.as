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
		public static var ImgHeartDeath:FlxExtBitmap;
		
		public static var ImgTreeGrow:FlxExtBitmap;
		public static var ImgTreeDie:FlxExtBitmap;
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
		
		public static var animateIdea:Array = [ -2, 0, 2, 0];
		public static var arrayIdeas:Object = {
										ecologie:[0],
										religion:[1],
										guerre:[1],
										paix:[2],
										medecine:[3],
										deforestation:[4],
										guerre:[5],
										fanatisme:[6],
										maladie:[7]
										};
		
	}

}