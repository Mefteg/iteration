package  
{
	import flash.events.Event;
	import Game.Objects.*;
	import Globals.GameParams;
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
			//loader la planete
			SpriteResources.ImgPlnt = new FlxExtBitmap("img/planet.png");
			SpriteResources.ImgPlnt.load();
			SpriteResources.ImgHeart = new FlxExtBitmap("img/heart.png");
			SpriteResources.ImgHeart.load();
			SpriteResources.ImgHeartHalo = new FlxExtBitmap("img/heartHalo.png");
			SpriteResources.ImgHeartHalo.load();
			SpriteResources.ImgHeartBack = new FlxExtBitmap("img/heartBack.png");
			SpriteResources.ImgHeartBack.load();
			SpriteResources.ImgHeartDeath= new FlxExtBitmap("img/heartDeath.png");
			SpriteResources.ImgHeartDeath.load();
			//loader l'image de l'arbre 
			SpriteResources.ImgTreeGrow = new FlxExtBitmap("img/tree_anim_grow.png");
			SpriteResources.ImgTreeGrow.load();
			SpriteResources.ImgTreeDie = new FlxExtBitmap("img/tree_anim_dead.png");
			SpriteResources.ImgTreeDie.load();
			SpriteResources.ImgTreeRoots = new FlxExtBitmap("img/roots.png");
			SpriteResources.ImgTreeRoots.load();
			//loader l'image du blobby
			SpriteResources.ImgBlobby = new FlxExtBitmap("img/Blobby_Sprites.png");
			SpriteResources.ImgBlobby.load();
			//loader l'image du meteor
			SpriteResources.ImgMeteor = new FlxExtBitmap("img/meteor.png");
			SpriteResources.ImgMeteor.load();
			//loader l'image du meteor de vie
			SpriteResources.ImgMeteorLife = new FlxExtBitmap("img/meteor_vie.png");
			SpriteResources.ImgMeteorLife.load();
			//loader l'image de l'explosion du meteor
			SpriteResources.ImgExplosionMeteor = new FlxExtBitmap("img/explosion_meteor.png");
			SpriteResources.ImgExplosionMeteor.load();
			//nuages
			SpriteResources.ImgCloud = new FlxExtBitmap("img/cloud1.png");
			SpriteResources.ImgCloud.load();
			SpriteResources.ImgCloud2 = new FlxExtBitmap("img/cloud2.png");
			SpriteResources.ImgCloud2.load();
			//idées
			SpriteResources.ImgIdeaBubble = new FlxExtBitmap("img/IdeaBubble.png");
			SpriteResources.ImgIdeaBubble.load();
			SpriteResources.ImgIdeas = new FlxExtBitmap("img/Ideas.png");
			SpriteResources.ImgIdeas.load();
			
			// fond
			SpriteResources.ImgBackground = new FlxExtBitmap("img/fond.jpg");
			SpriteResources.ImgBackground.load();
			SpriteResources.ImgForeground = new FlxExtBitmap("img/foreground.jpg");
			SpriteResources.ImgForeground.load();
			
			
			
			GameParams.map = new Map("xml/map1.xml");
			
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