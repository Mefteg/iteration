package  Game.States
{
	import flash.utils.Timer;
	import flash.media.Sound;
	import Game.Camera;
	import Game.NewSprite;
	import Game.Objects.Blobby;
	import Game.Objects.Meteor;
	import Game.Objects.Planet;
	import Game.Objects.Tree;
	import Game.Objects.Cloud;
	import Globals.GameParams;
	import mx.core.FlexSprite;
	import org.flixel.*;
	import Resources.SpriteResources;
	import Resources.SoundResources;
	import SoundEngine.SoundBank;
	import SoundEngine.Sound;
	import Utils.MathUtils;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class PlayState extends FlxState
	{		
		private var m_camera:Camera;
		
		private var m_soundBank:SoundBank = new SoundBank();
		//animations pour blobby
		protected var nbAnimBlob:int = 4;
		protected var blobbyAnimWalk:Array;
		protected var blobbyAnimIdle:Array;
		protected var blobbyAnimDiscuss:Array;
				
		//objets
		protected var background:FlxSprite;
		protected var planet:Planet;
		protected var blobbies:Array;
		protected var meteor:Meteor;
		protected var trees:Array;
		protected var clouds:Array;
		
		private var m_state:String = "";
		
		//itération
		protected var m_iteration:Iteration;
		//variables caméra
		protected var m_text:FlxText;
		
		// FPS calculation
		private var m_lastTime:Number = 0;
		private var m_FPSCounter:Number = 0;
		private var m_FPS:Number = 0;
		
		
		public function PlayState() 
		{
			blobbies = new Array();
			blobbyAnimWalk = new Array();
			blobbyAnimIdle = new Array();
			blobbyAnimDiscuss = new Array();
			trees = new Array();
			clouds = new Array();
	
			//FPS
			m_text = new FlxText(10, 10, 500, FlxG.framerate.toString());
			m_text.scrollFactor = new FlxPoint(0, 0);
			m_text.size = 50;
			add(m_text);
			
			
			//SON
			var m_sound:SoundEngine.Sound = new SoundEngine.Sound(SoundResources.backgroundMusic, true);
			m_soundBank.add(m_sound, "Background");
			//m_soundBank.get("Background").play();
			
			// On affiche la souris
			FlxG.mouse.show();			
		}
		
		override public function create():void 
		{
			FlxG.bgColor =  0xff0a216b ;
			//FlxG.bgColor = 0xffecebb3;
			
			// On charge la map
			//var map1:Map = new Map("map/test.xml");
			
			//------CREER LA PLANETE-----------------
			planet = new Planet( FlxG.width/2 , FlxG.height/2, 64 ,blobbies,trees);
			add(planet);
			
			//-------CREER LA CLASSE D'ITERATION-----
			m_iteration = new Iteration(this,planet);
			
			var sprite:NewSprite;
			//talbeau d'animations de blobbies
			for (var k:int = 0; k < nbAnimBlob; k++) 
			{
				//animation de marche
				sprite = new NewSprite();
				sprite.loadGraphic(SpriteResources.ImgBlobbyWalk, true, false, 300, 300);
				sprite.addAnimation("walk", [0, 1, 2, 3, 4, 5, 6, 7], 2 + FlxG.random() * 2, true);
				sprite.addAnimation("search", [0, 1, 2, 3, 4, 5, 6, 7], 4 + FlxG.random() * 4, true);
				blobbyAnimWalk.push(sprite);
				//animation de idle
				sprite = new NewSprite();
				sprite.loadGraphic(SpriteResources.ImgBlobbyIdle, true, false, 300, 300);
				sprite.addAnimation("idle", [0, 1, 2, 3, 4, 5], 0.2+FlxG.random() * 2, true);
				blobbyAnimIdle.push(sprite);
				//animation de discussion
				sprite = new NewSprite();
				sprite.loadGraphic(SpriteResources.ImgBlobbyTalk, true, false, 300, 300);
				sprite.addAnimation("discuss", MathUtils.getArrayofNumbers(0, 19) , 5 +FlxG.random() * 2, true);
				//a supprimer plus tard
				sprite.addAnimation("validate", [0, 1, 2, 3, 4, 5], 5 +FlxG.random() * 2, true);
				blobbyAnimDiscuss.push(sprite);
				
			}
			m_state = "Creation";
						
			//----------CREER LE METEOR-------------
			// poncepermis
			meteor = new Meteor(SpriteResources.ImgMeteor, planet.radius() * 2, planet);
			add(meteor);
			
			initClouds();
			
			// On affiche la souris
			FlxG.mouse.show();	
			
			m_camera = new Camera(planet.getMidpoint(), 0, 0, FlxG.width * 2, FlxG.height * 2, true);
		}
		
		override public function update():void 
		{			
			// On regle le scale des elements en fonction du zoom de la camera
			var elements:Array = getElements();
			
			// Pour chaque element
			for (var i:int = 0; i < elements.length; i++) 
			{
				// On gere le scale/zoom
				//elements[i].setScale(new FlxPoint(GameParams.worldZoom, GameParams.worldZoom));
				//elements[i].setDistance(elements[i].getDistance() * m_zoom);
			}
			
			//update le texte
			updateFPS();
			m_text.text = m_iteration.getIterations() + " iterations \n" + planet.getResources()+" resources \n" + planet.getBlobbies().length + " blobbies \n" + m_FPS.toString()+" fps"
			//mettre a jour la camera
			m_camera.update();
			
			super.update();			
			
			switch (m_state)
			{
				case "Creation":
					if ( meteor.hasExploded() )
					{
						meteor.destroy();
						remove(meteor);
						meteor = null;
						
						createWorld();
						
						m_state = "Life";
					}
					break;
				case "Life":
					//mettre a jour l'itération
					m_iteration.update();
					break;
			}
		}
		
		public function getElements():Array {
			var elements:Array = new Array();
			elements = elements.concat(blobbies);
			elements = elements.concat(trees);
			elements = elements.concat(clouds);
			elements.push(planet);
			
			return elements;
		}
		//fonctions retournant une animation donnée pour un blob
		public function getAnimBlobWalk(): NewSprite
		{
			return blobbyAnimWalk[FlxU.round( Math.random() * (nbAnimBlob-1))];
		}
		public function getAnimBlobIdle(): NewSprite
		{
			return blobbyAnimIdle[FlxU.round( Math.random() * (nbAnimBlob-1))];
		}
		public function getAnimBlobDiscuss(): NewSprite
		{
			return blobbyAnimDiscuss[FlxU.round( Math.random() * (nbAnimBlob-1))];
		}
		
		public function initBlobies():void
		{
			var blob:Blobby;
			//tableau de positions des blobbies à créer
			var tabBlobbiesPosition:Array = [ 2 , 90, 200,21 ];
			var sizeBlob:uint = tabBlobbiesPosition.length; // optimisation
			
			for (var i:int = 0; i < sizeBlob ; i++) 
			{
				blob = new Blobby( tabBlobbiesPosition[i], planet.radius(), planet);
				blob.setAnimations(getAnimBlobWalk(), getAnimBlobIdle(),getAnimBlobDiscuss() );
				blobbies.push(blob);
				add(blob);
			}
		}
		
		public function createWorld():void
		{
			//-------CREER LES BLOBBIES--------------			
			initBlobies();
			
			//----------CREER LES ARBRES------------
			initTrees();
		}
		
		public function initTrees():void
		{
			var j:int = 0;
			var tree:Tree;
			
			for (j = 0; j < 4; j++) 
			{
				tree = new Tree(planet.center(), planet);
				trees.push(tree);
				add(tree);
			}			
		}
		
		public function initClouds():void
		{
			var j:int = 0;
			var cloud:Cloud;
			
			for (j = 0 ; j < GameParams.nbClouds ; j++ )
			{
				cloud = new Cloud(planet.radius() +10, planet);
				clouds.push(cloud);
				add(cloud);
			}
		}
		
		public function updateFPS():void
		{
			var now:Date = new Date();
			
			m_FPSCounter ++;
			if ( now.getTime() - m_lastTime > 1000  )
			{
				m_FPS = m_FPSCounter;
				m_FPSCounter = 0;
				m_lastTime = now.getTime();
			}
		}
	}

}