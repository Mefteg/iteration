package  
{
	import Game.Objects.Element;
	import org.flixel.FlxExtBitmap;
	import org.flixel.FlxSprite;
	import org.flixel.system.FlxPreloader;
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author Moi
	 */
	public class Preloader extends FlxPreloader
	{
		protected var m_bitmapTreeGrow:FlxExtBitmap;
		
		public function Preloader() 
		{
			className = "Main";
						
			super();
			
			minDisplayTime = 10;
		}
		
		override protected function create():void {
			
			SpriteResources.ImgTree = new FlxExtBitmap("img/tree_anim_grow.png");
			SpriteResources.ImgTree.load();
			//Add stuff to the buffer...
			super.create();
		}
		
		override protected function update(Percent:Number):void {
			//Update the graphics...
			super.update(Percent);
		}
		
	}

}