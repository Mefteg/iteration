package  Game.States
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.media.Sound;
	import Game.Camera;
	import Game.Background;
	import Game.DepthBuffer;
	import Game.Objects.Blobby;
	import Game.Objects.CloudGenerator;
	import Game.Objects.Meteor;
	import Game.Objects.Planet;
	import Game.Objects.Scroll;
	import Game.Objects.Tree;
	import Game.Objects.Cloud;
	import Game.Objects.TreeGenerator;
	import Globals.GameParams;
	import mx.core.FlexSprite;
	import org.flixel.*;
	import org.flixel.system.FlxAnim;
	import Resources.SpriteResources;
	import SoundEngine.SoundBank;
	import Resources.SoundResources;
	import Utils.MathUtils;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class PlayState extends FlxState
	{		
		private var m_camera:Camera;
		
		//animations pour blobby
		protected var nbAnimBlob:int = 4;
				
		//objets
		protected var planet:Planet;
		protected var blobbies:Array;
		protected var meteor:Meteor;
		protected var m_treeGenerator:TreeGenerator;
		protected var m_cloudsGenerator:CloudGenerator;
				
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
		
		// Z Buffer
		private var m_zbuffer:DepthBuffer = new DepthBuffer();
		
		// compteur pour savoir combien de temps le clic est enfoncé
		private var m_mousecpt = 0;
		
		// Meteor sound timer
		private var m_meteorTimer:FlxTimer = new FlxTimer();
		
		public function PlayState() 
		{
			add(m_zbuffer);
			
			blobbies = new Array();			
	
			//FPS
			m_text = new FlxText(10, 10, 500, FlxG.framerate.toString());
			m_text.scrollFactor = new FlxPoint(0, 0);
			m_text.size = 50;
			m_zbuffer.addForeground(m_text);
			
			//SON
			
			//GameParams.soundBank.get(SoundResources.backgroudMusic).play();
			
			// On affiche la souris
			FlxG.mouse.show();
			//FlxG.mouse.load(SpriteResources.ImgMouseCursor);
		}
		
		override public function create():void 
		{
			GameParams.playstate = this;
			FlxG.bgColor =  0xff0a216b ;
			
			//------CREER LA PLANETE-----------------
			planet = new Planet( FlxG.width / 2 , FlxG.height / 2, blobbies);
			
			m_treeGenerator = new TreeGenerator(planet);
			m_zbuffer.addTrees(m_treeGenerator);
			
			planet.setTrees(m_treeGenerator.trees());
			
			//----------CREER LA CAMERA-------------
			m_camera = new Camera(planet.getMidpoint(), 0, 0, FlxG.width * 2, FlxG.height * 2, true);
			m_camera.setPosPlanet(planet.getMidpoint());
			
			//------CREER LE BACKGROUND--------------
			m_background = new Game.Background(m_camera);
			
			
			m_state = "Creation";
			
			// On affiche la planete apres le background
			
			m_zbuffer.addBackground(planet);
			m_zbuffer.addForeground(planet.getDeadHeartSprite());
			m_zbuffer.addForeground(planet.getHaloHeartSprite());
			m_zbuffer.addForeground(planet.getBackHeartSprite());
			m_zbuffer.addForeground(planet.getHeartSprite());
			
			//-------CREER LES BLOBBIES--------------	
			
			m_cloudsGenerator = new CloudGenerator(planet);
			m_zbuffer.addBackground(m_cloudsGenerator);
			m_cloudsGenerator.regenerate();
			
			initBlobies();
			
			//----------CREER LE METEOR-------------
			// poncepermis
			meteor = new Meteor( planet.radius() * 2, planet, true);
			meteor.setState("Crashing");
			m_meteorTimer.start(GameParams.map.m_soundMeteorTimer);
			

			m_zbuffer.addMeteor(meteor);
			m_zbuffer.addMeteor(meteor.getExplosion());

			// On affiche la souris
			FlxG.mouse.show();
			FlxG.mouse.load(SpriteResources.ImgMouseCursor);
			
			//______________SCROLL_____________________
			GameParams.scroll = new Scroll();
			add(GameParams.scroll);
			getDepthBuffer().addScroll(GameParams.scroll);
			
			GameParams.soundBank.get(SoundResources.windSound).play();
		}
		
		override public function update():void 
		{			
			
			if (FlxG.keys.A) planet.removeResources(10000);
			
			if ( m_meteorTimer != null && m_meteorTimer.finished )
			{
				GameParams.soundBank.get(SoundResources.crashSound).play(GameParams.map.m_soundLifeMeteorVolume);
				m_meteorTimer = null;
			}
			
			//mettre a jour la camera
			m_camera.update();
			
			switch (m_state)
			{
				case "Creation":
					if ( meteor.hasExploded() )
					{		
						m_zbuffer.removeMeteor(remove(meteor.getExplosion()));
						meteor.destroy();
						m_zbuffer.removeMeteor(meteor);
						meteor = null;
						
						createWorld();
						planet.live();
						
						//-------CREER LA CLASSE D'ITERATION-----
						m_iteration = new Iteration(this, planet);
						m_iteration.reInit();
						GameParams.scroll.setIteration(m_iteration);
						m_state = "Life";
						
						if ( GameParams.soundBank.get(SoundResources.windSound).isPlaying() )
						{
							GameParams.soundBank.get(SoundResources.windSound).fadeOut(3);
						}
					}
					break;
				case "Life":
					//mettre a jour l'itération*
					m_iteration.update();
					//update le texte
					updateFPS();
					//m_text.text = m_iteration.getIterations() + " iterations \n" + planet.getResources() + " resources \n" + planet.getLivingBlobbies() + " blobbies ("+planet.getBlobbies().length+")\n" + m_FPS.toString() + " fps";
					if ( m_iteration.cycleFinished() )	// We must call this function
					{
						if ( meteor == null )	// But if we already have a meteor, we will not have two :p
						{
							meteor = new Meteor( planet.radius() * 2, planet, false);
							
							//add(meteor);
							//add(meteor.getExplosion());
							
							m_zbuffer.addMeteor(meteor);
							m_zbuffer.addMeteor(meteor.getExplosion());
						}
					}
					//si le mechant meteor explose sur la planete
					if ( meteor != null && meteor.isExploding() && !meteor.giveLife() )
					{
						meteor.checkBlobbiesCollision();
						meteor.checkTreesCollision();
						if (meteor.hasExploded())
						{
							m_zbuffer.removeMeteor(meteor.getExplosion());
							meteor.destroy();
							m_zbuffer.removeMeteor(meteor);
							meteor = null;
						}
					}
					
					// Planet death condition
					if ( planet.isDead())
					{
						// If we have a meteor roaming ... we delete it
						if ( meteor != null )
						{
							m_zbuffer.removeMeteor(meteor.getExplosion());
							m_zbuffer.removeMeteor(meteor);
							meteor.destroy();
						}
						
						
						m_treeGenerator.clear();
						m_iteration.clear();
						planet.explosion();
						m_state = "Removal";
					}
					break;
				case "Removal":
					if (planet.isDying()) break;
					
					var blobDestroy:Blobby;
					// Delete all the elements
					while ( blobbies.length != 0 )
					{
						blobDestroy = blobbies.pop();
						getDepthBuffer().removeBlobbies(blobDestroy);
						remove(blobDestroy);
						blobDestroy.destroy();
					}
					blobDestroy = null;
										
					m_state = "Creation";
					initBlobies();
					
					// Create the birth meteor
					meteor = new Meteor(planet.radius() * 2, planet,true);
					//add(meteor);
					//add(meteor.getExplosion());
					m_zbuffer.addMeteor(meteor);
					m_zbuffer.addMeteor(meteor.getExplosion());
					
					FlxG.shake(0.01);
					FlxG.flash();
					
					GameParams.soundBank.get(SoundResources.windSound).play();
					
					break;
			}
			
			// update du curseur
			if ( FlxG.mouse.pressed() ) {
				if ( m_mousecpt > 8 ) {
					FlxG.mouse.load(SpriteResources.ImgMouseCursorClic);
				}
				else {
					m_mousecpt++;
				}
			}
			else {
				FlxG.mouse.load(SpriteResources.ImgMouseCursor);
				m_mousecpt = 0;
			}
			
			GameParams.soundBank.update();
			super.update();	
		}
		
		override public function draw():void 
		{
			m_background.drawBackground();
			
			super.draw();
			
			m_background.drawForeground();
		}
			
		public function createWorld():void
		{			
			initTrees();
		}
		
		public function initTrees():void
		{
			m_treeGenerator.regenerate();			
		}
		
		public function initBlobies():void
		{
			var blob:Blobby;
			
			for (var i:int = 0; i < GameParams.map.m_blobbyInitNb ; i++) 
			{
				blob = new Blobby( Math.random()*360, 0, planet);
				blob.visible = false;
				blob.setState("arise");
				planet.addBlobby(blob);
				m_zbuffer.addBlobbies(blob);
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
		
		public function getDepthBuffer():DepthBuffer {
			return m_zbuffer;
		}
		
		public function rain(position:Number):void
		{
			// Truncate angle between 0 - 360
			if ( position > 0 )
			{
				while ( position > 360 )
				{
					position -= 360;
				}
			}
			else
			{
				while ( position < -360 )
				{
					position += 360;
				}
			}
			
			if ( position < 0 )
			{
				position = 360 + position;
			}
			
			var trees:Array = m_treeGenerator.trees();
			for ( var i:uint = 0 ; i < trees.length ; i++ )
			{
				if ( trees[i] != null && trees[i].isVisible() == true && !trees[i].isGrowing() && !trees[i].isDead())
				{
					if ( Math.abs( trees[i].getPos() - (position-10)) < 20 )
					{
						trees[i].raining();
					}
				}
			}
		}
	}
}