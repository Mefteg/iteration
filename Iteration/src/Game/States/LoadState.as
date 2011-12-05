package Game.States 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.events.Event;
	import flash.geom.Point;
	import Game.LoadObject;
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
		protected var m_timerLoad:FlxTimer;
		
		public static var m_loadObject:LoadObject = null;
		
		public function LoadState() 
		{
			m_images = new Array();
			m_timerMin = new FlxTimer();
			m_timerLoad = new FlxTimer();
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
			if (m_progress >= 100) 
			{
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
			m_timerMin.start(2.7);
			m_timerLoad.start(2);
			
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
			// Crack
			SpriteResources.ImgCrack = new FlxExtBitmap("img/crack.png");
			addImage(SpriteResources.ImgCrack);
			
			
			//loader l'image de l'arbre 
			SpriteResources.ImgTreeGrow = new FlxExtBitmap("img/tree_anim_grow.png");
			SpriteResources.ImgTreeGrow2 = new FlxExtBitmap("img/tree2_anim_grow.png");
			addImage(SpriteResources.ImgTreeGrow);
			addImage(SpriteResources.ImgTreeGrow2);
			//Mort arbre
			SpriteResources.ImgTreeDie = new FlxExtBitmap("img/tree_anim_dead.png");
			SpriteResources.ImgTreeDie2 = new FlxExtBitmap("img/tree2_anim_dead.png");
			addImage(SpriteResources.ImgTreeDie);
			addImage(SpriteResources.ImgTreeDie2);
			//Fruit
			SpriteResources.ImgFruit = new FlxExtBitmap("img/pop_fruit_40.png");
			addImage(SpriteResources.ImgFruit);
			//Racines
			SpriteResources.ImgTreeRoots = new FlxExtBitmap("img/roots.png");			
			addImage(SpriteResources.ImgTreeRoots);
			//loader l'image du blobby
			SpriteResources.ImgBlobby = new FlxExtBitmap("img/Blobby_Sprites.png");
			addImage(SpriteResources.ImgBlobby);
			SpriteResources.ImgBlobbyRunLeft = new FlxExtBitmap("img/Blobby_run_left.png");
			addImage(SpriteResources.ImgBlobbyRunLeft);
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
			//SpriteResources.ImgMouseCursor = new FlxExtBitmap("img/curseur.png");
			//addImage(SpriteResources.ImgMouseCursor);
			
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
			
			//tuto
			SpriteResources.ImgTuto1 = new FlxExtBitmap("img/1tuto.jpg");
			addImage(SpriteResources.ImgTuto1);
			SpriteResources.ImgTuto2 = new FlxExtBitmap("img/2tuto.jpg");
			addImage(SpriteResources.ImgTuto2);
			SpriteResources.ImgTuto3 = new FlxExtBitmap("img/3tuto.jpg");
			addImage(SpriteResources.ImgTuto3);
			SpriteResources.ImgTuto4 = new FlxExtBitmap("img/4tuto.jpg");
			addImage(SpriteResources.ImgTuto4);
			SpriteResources.ImgTuto5 = new FlxExtBitmap("img/5tuto.jpg");
			addImage(SpriteResources.ImgTuto5);
			SpriteResources.ImgMenuTutobutton = new FlxExtBitmap("img/TutoButton.png");
			addImage(SpriteResources.ImgMenuTutobutton);
			SpriteResources.ImgTutoLeftArrow = new FlxExtBitmap("img/leftarrow.png");
			addImage(SpriteResources.ImgTutoLeftArrow);
			SpriteResources.ImgTutoRightArrow = new FlxExtBitmap("img/rightarrow.png");
			addImage(SpriteResources.ImgTutoRightArrow);
			
			//parchemin
			SpriteResources.ImgScroll = new FlxExtBitmap("img/scroll.png");
			addImage(SpriteResources.ImgScroll);			
		}
		
		private function createSounds():void
		{
			GameParams.soundBank.load(SoundResources.backgroudMusic,true);
			GameParams.soundBank.load(SoundResources.backgroudLowRessMusic,true);
			GameParams.soundBank.load(SoundResources.backgroudHighRessMusic,true);
			GameParams.soundBank.load(SoundResources.crashSound,false);
			GameParams.soundBank.load(SoundResources.mlifeSound,false);
			GameParams.soundBank.load(SoundResources.ressBirthSound,false);
			GameParams.soundBank.load(SoundResources.mdeathSound,false);
			GameParams.soundBank.load(SoundResources.rainSound,false);
			GameParams.soundBank.load(SoundResources.ideaSound,false);
			GameParams.soundBank.load(SoundResources.windSound, true);
			GameParams.soundBank.load(SoundResources.talk1Sound, true);
			GameParams.soundBank.load(SoundResources.talk2Sound, true);
			GameParams.soundBank.load(SoundResources.crackSound, false);
			for (var i:String in SoundResources.soundIdeas) {
				GameParams.soundBank.load(SoundResources.soundIdeas[i], false);
			}
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
					if ( m_timerLoad.finished && m_loadObject == null )
					{
						m_loadObject = new LoadObject();
					}
					if (m_timerMin.finished) {
						FlxG.switchState(new MenuState());
						FlxG.stage.removeChild(movie);
					}
					break;
			}
		}
	}

}