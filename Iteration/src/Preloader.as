package  
{
	import flash.events.Event;
	import Game.Objects.Element;
	import org.flixel.FlxExtBitmap;
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import org.flixel.system.FlxPreloader;
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author Moi
	 */
	public class Preloader extends FlxPreloader
	{		
		public function Preloader() 
		{
			className = "Main";
						
			super();
			
			minDisplayTime = 10;
		}
		
		override protected function create():void {
			//loader l'image de l'arbre 
			SpriteResources.ImgTreeGrow = new FlxExtBitmap("img/tree_anim_grow.png");
			SpriteResources.ImgTreeGrow.load();
			SpriteResources.ImgTreeDie = new FlxExtBitmap("img/tree_anim_dead.png");
			SpriteResources.ImgTreeDie.load();
			//loader l'image du blobby
			SpriteResources.ImgBlobby = new FlxExtBitmap("img/Blobby_Sprites.png");
			SpriteResources.ImgBlobby.load();
			
			//création des sprites
			//Add stuff to the buffer...
			super.create();
		}
		
		override protected function update(Percent:Number):void {
			//Update the graphics...
			super.update(Percent);		
		}
		
		
	}

}