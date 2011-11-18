package Game.States 
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import Game.Objects.*;
	import Globals.GameParams;
	import org.flixel.FlxExtBitmap;
	import org.flixel.FlxG;
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTimer;
	import org.flixel.system.FlxPreloader;
	import Resources.SpriteResources;
	
	import SoundEngine.SoundBank;
	import SoundEngine.Sound;
	import Resources.SoundResources;
	/**
	 * ...
	 * @author Moi
	 */
	public class LoadState extends FlxState
	{		
		[Embed(source = '../../../bin/img/loading.swf')] private var Intro:Class;
		private var movie:MovieClip;
		
		protected var m_state:String;
		protected var m_images:Array;
		protected var m_imagesSize:int;
		
		protected var m_imagesLoaded:int = 0;
		protected var m_progress:int = 0;
		
		protected var m_timerMin:FlxTimer;
		
		public function LoadState() 
		{
			m_images = new Array();
			m_timerMin = new FlxTimer();
			GameParams.soundBank = new SoundBank();
		}
		
		public function getLoadImageProgress():Number {
			m_progress = 0;
			var allLoaded:Boolean = true;
			for (var i:int = 0; i < m_imagesSize; i++) 
			{
				m_progress += m_images[i].getAdvancementInPercent();
				allLoaded = allLoaded && m_images[i].loadComplete();
			}
			m_progress /= m_imagesSize;
			if (m_progress >= 100) {
				if (!allLoaded)
					return 99;
			}
			
			return m_progress;
			
		}
		
		public function getLoadGraphicProgress():Number {
			return 100;
		}
		
		//fonction pour charger une image et l'ajouter au tableau
		public function addImage(image:FlxExtBitmap):void {
			image.load();
			m_images.push(image);
		}
		
		public function loadGraphics():void {
			for (var i:int = 0; i < m_imagesSize; i++) 
			{
				FlxG.addBitmapFromObject(m_images[i]);
			}
			m_progress = 100;
			setState("Loaded");
		}
		
		public function setState(state:String):void {
			m_state = state;
		}
		override public function create():void 
		{
			createSprites();
			createSounds();
			
			//charger le xml
			GameParams.map = new Map("xml/map1.xml");
			
			//enregistrer la taille du tableau
			m_imagesSize = m_images.length;
			
			setState("Bitmap");
			m_timerMin.start(4);
			
			movie = new Intro();
			FlxG.stage.addChild(movie);
		}
		
		private function createSprites():void
		{
			//loader la planete
			SpriteResources.ImgPlnt = new FlxExtBitmap("img/planet.png");
			addImage(SpriteResources.ImgPlnt);
			//Coeur
			SpriteResources.ImgHeart = new FlxExtBitmap("img/heart.png");
			addImage(SpriteResources.ImgHeart);
			//Coeur Halo
			SpriteResources.ImgHeartHalo = new FlxExtBitmap("img/heartHalo.png");
			addImage(SpriteResources.ImgHeartHalo);
			//Coeur Back
			SpriteResources.ImgHeartBack = new FlxExtBitmap("img/heartBack.png");
			addImage(SpriteResources.ImgHeartBack);
			//Coeur Mort
			SpriteResources.ImgHeartDeath = new FlxExtBitmap("img/heartDeath.png");
			addImage(SpriteResources.ImgHeartDeath);
			//loader l'image de l'arbre 
			SpriteResources.ImgTreeGrow = new FlxExtBitmap("img/tree_anim_grow.png");
			addImage(SpriteResources.ImgTreeGrow);
			//Mort arbre
			SpriteResources.ImgTreeDie = new FlxExtBitmap("img/tree_anim_dead.png");
			addImage(SpriteResources.ImgTreeDie);
			//Fruit
			SpriteResources.ImgFruit = new FlxExtBitmap("img/pop_fruit_40.png");
			addImage(SpriteResources.ImgFruit);
			//Racines
			SpriteResources.ImgTreeRoots = new FlxExtBitmap("img/roots.png");			
			addImage(SpriteResources.ImgTreeRoots);
			//loader l'image du blobby
			SpriteResources.ImgBlobby = new FlxExtBitmap("img/Blobby_Sprites.png");
			addImage(SpriteResources.ImgBlobby);
			//loader l'image du meteor
			SpriteResources.ImgMeteor = new FlxExtBitmap("img/meteor.png");
			addImage(SpriteResources.ImgMeteor);
			//loader l'image du meteor de vie
			SpriteResources.ImgMeteorLife = new FlxExtBitmap("img/meteor_vie.png");
			addImage(SpriteResources.ImgMeteorLife);
			//loader l'image de l'explosion du meteor
			SpriteResources.ImgExplosionMeteor = new FlxExtBitmap("img/explosion_meteor.png");
			addImage(SpriteResources.ImgExplosionMeteor);
			//nuages
			SpriteResources.ImgCloud = new FlxExtBitmap("img/cloud1.png");
			SpriteResources.ImgCloud2 = new FlxExtBitmap("img/cloud2.png");
			SpriteResources.ImgRain = new FlxExtBitmap("img/rain.png");
			addImage(SpriteResources.ImgCloud);
			addImage(SpriteResources.ImgCloud2);
			addImage(SpriteResources.ImgRain);
			//idées
			SpriteResources.ImgIdeaBubble = new FlxExtBitmap("img/IdeaBubble.png");
			SpriteResources.ImgIdeas = new FlxExtBitmap("img/Ideas.png");
			addImage(SpriteResources.ImgIdeaBubble);
			addImage(SpriteResources.ImgIdeas);
			
			// fond
			SpriteResources.ImgBackground = new FlxExtBitmap("img/fond.png");
			SpriteResources.ImgForeground = new FlxExtBitmap("img/foreground.png");
			addImage(SpriteResources.ImgBackground);
			addImage(SpriteResources.ImgForeground);
			
			// mouse cursor
			SpriteResources.ImgMouseCursor = new FlxExtBitmap("img/curseur.png");
			addImage(SpriteResources.ImgMouseCursor);
			
			// menu
			SpriteResources.ImgMenuBackground = new FlxExtBitmap("img/MenuScreen.png");
			addImage(SpriteResources.ImgMenuBackground);
			SpriteResources.ImgMenuPlaybutton = new FlxExtBitmap("img/PlayButton.png");
			addImage(SpriteResources.ImgMenuPlaybutton);
			SpriteResources.ImgMenuCreditbutton = new FlxExtBitmap("img/CreditsButton.png");
			addImage(SpriteResources.ImgMenuCreditbutton);
			
			// menu
			SpriteResources.ImgCreditBackground = new FlxExtBitmap("img/CreditsScreen.png");
			addImage(SpriteResources.ImgCreditBackground);
			SpriteResources.ImgCreditBackbutton = new FlxExtBitmap("img/BackButton.png");
			addImage(SpriteResources.ImgCreditBackbutton);
		}
		
		private function createSounds():void
		{
			var m_sound:SoundEngine.Sound = new SoundEngine.Sound(SoundResources.backgroundMusic, true);
			GameParams.soundBank.add(m_sound, SoundResources.backgroudMusicName);
		}
		
		override public function update() :void{
			super.update();
			switch(m_state) {
				case "Bitmap":
					if (getLoadImageProgress() >= 100)
						setState("Graphic");
					break;
				case "Graphic":
					loadGraphics();
					break;
				case "Loaded":
					if (m_timerMin.finished) {
						//FlxG.switchState(new PlayState());
						FlxG.switchState(new MenuState());
						FlxG.stage.removeChild(movie);
					}
					break;
			}
		}
	}

}