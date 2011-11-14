package  Game.States
{
	import flash.utils.Timer;
	import flash.media.Sound;
	import Game.Camera;
	import Game.Background;
	import Game.Objects.Blobby;
	import Game.Objects.Meteor;
	import Game.Objects.Planet;
	import Game.Objects.Tree;
	import Game.Objects.Cloud;
	import Game.Objects.TreeGenerator;
	import Globals.GameParams;
	import mx.core.FlexSprite;
	import org.flixel.*;
	import org.flixel.system.FlxAnim;
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
				
		//objets
		protected var planet:Planet;
		protected var blobbies:Array;
		protected var meteor:Meteor;
		protected var m_treeGenerator:TreeGenerator;
		protected var clouds:Array;
				
		//Background
		private var m_background:Background;
		
		//State
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
			
			//------CREER LA PLANETE-----------------
			planet = new Planet( FlxG.width / 2 , FlxG.height / 2, blobbies);
			
			m_treeGenerator = new TreeGenerator(planet, this);
			add(m_treeGenerator);
			
			planet.setTrees(m_treeGenerator.trees());
			
			//------CREER LE BACKGROUND--------------
			m_background = new Game.Background(new FlxPoint(0, 0), SpriteResources.ImgBackground, planet);
			add(m_background);
			
			
			m_state = "Creation";
						
			//----------CREER LES ARBRES------------
			//initTrees();
			
			// On affiche la planete apres le background
			add(planet);
			
			//-------CREER LES BLOBBIES--------------			
			initBlobies();
			
			//----------CREER LE METEOR-------------
			// poncepermis
			meteor = new Meteor(SpriteResources.ImgMeteor, planet.radius() * 2, planet,true);
			add(meteor);
			add(meteor.getExplosion());
			
			initClouds();
			
			// On affiche la souris
			FlxG.mouse.show();	

			//----------CREER LA CAMERA-------------
			m_camera = new Camera(planet.getMidpoint(), 0, 0, FlxG.width * 2, FlxG.height * 2, true);
			m_camera.setPosPlanet(planet.getMidpoint());
			
			
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
			
			//mettre a jour la camera
			m_camera.update();
			
			switch (m_state)
			{
				case "Creation":
					if ( meteor.hasExploded() )
					{
						remove(meteor.getExplosion());
						meteor.destroy();
						remove(meteor);
						meteor = null;
						
						createWorld();
						planet.live();
						
						//-------CREER LA CLASSE D'ITERATION-----
						m_iteration = new Iteration(this, planet);
						m_iteration.reInit();
						
						m_state = "Life";
					}
					break;
				case "Life":
					//mettre a jour l'itération*
					m_iteration.update();
					//update le texte
					updateFPS();
					m_text.text = m_iteration.getIterations() + " iterations \n" + planet.getResources() + " resources \n" + planet.getBlobbies().length + " blobbies \n" + m_FPS.toString() + " fps";
					if ( m_iteration.cycleFinished() )	// We must call this function
					{
						if ( meteor == null )	// But if we already have a meteor, we will not have two :p
						{
							meteor = new Meteor(SpriteResources.ImgMeteor, planet.radius() * 2, planet, false);
							
							add(meteor);
							add(meteor.getExplosion());
						}
					}
					//si le mechant meteor explose sur la planete
					if ( meteor != null && meteor.isExploding() && !meteor.giveLife() )
					{
						meteor.checkBlobbiesCollision();
						meteor.checkTreesCollision();
						if(meteor.hasExploded()){
							remove(meteor.getExplosion());
							meteor.destroy();
							remove(meteor);
							meteor = null;
						}
					}
					
					if ( planet.isDead() || blobbies.length > 100 || (blobbies.length < 4 && m_iteration.getIterations() > 2))
					{
						if ( meteor != null )
						{
							remove(meteor.getExplosion());
							remove(meteor);
							meteor.destroy();
						}
						meteor = new Meteor(SpriteResources.ImgMeteor, planet.radius() * 2, planet,true);
						add(meteor);
						add(meteor.getExplosion());
						
						while ( blobbies.length != 0 )
						{
							blobbies.pop().destroy();
						}
						
						m_treeGenerator.clear();
						
						planet.explosion();
						m_state = "Creation";
					}
					break;
			}
			
			super.update();	
		}
		
		public function getElements():Array {
			var elements:Array = new Array();
			elements = elements.concat(blobbies);
			elements = elements.concat(m_treeGenerator);
			elements = elements.concat(clouds);
			elements.push(planet);
			
			return elements;
		}
		
		public function createWorld():void
		{			
			var size:int = blobbies.length;
			for (var i:int = 0; i < size; i++) 

			{
				blobbies[i].visible = true;
			}
			
			initTrees();
			/*
			size = m_treeGenerator.trees().length;
			var trees:Array = m_treeGenerator.trees();
			for (var j:int = 0; j < size; j++) 
			{
				if ( trees[j] != null )
				{
					trees[j].visible = true;
				}
			}
			*/
		}
		
		public function initTrees():void
		{
			m_treeGenerator.regenerate();			
		}
		
		public function initBlobies():void
		{
			var blob:Blobby;
			//tableau de positions des blobbies à créer
			var tabBlobbiesPosition:Array = [ 2  , 90, 200, 21 ];
			var sizeBlob:uint = tabBlobbiesPosition.length; // optimisation
			
			for (var i:int = 0; i < sizeBlob ; i++) 
			{
				blob = new Blobby( tabBlobbiesPosition[i], planet.radius(), planet);
				blob.visible = false;
				blobbies.push(blob);
				add(blob);
			}
		}
		
		
		public function initClouds():void
		{
			var j:int = 0;
			var cloud:Cloud;
			
			for (j = 0 ; j < GameParams.nbClouds ; j++ )
			{
				cloud = new Cloud(planet.radius() +50, planet);
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