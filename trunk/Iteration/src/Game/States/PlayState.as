package  Game.States
{
	import flash.utils.Timer;
	import flash.media.Sound;
	import Game.Camera;
	import Game.Background;
	import Game.DepthBuffer;
	import Game.Objects.Blobby;
	import Game.Objects.CloudGenerator;
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
			var m_sound:SoundEngine.Sound = new SoundEngine.Sound(SoundResources.backgroundMusic, true);
			m_soundBank.add(m_sound, "Background");
			//m_soundBank.get("Background").play();
			
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
			m_zbuffer.addBackground(meteor);
			m_zbuffer.addBackground(meteor.getExplosion());

			// On affiche la souris
			FlxG.mouse.show();		
		}
		
		override public function update():void 
		{			
			if (FlxG.keys.A) planet.removeResources(10000);
			
			//mettre a jour la camera
			m_camera.update();
			
			switch (m_state)
			{
				case "Creation":
					if ( meteor.hasExploded() )
					{		
						m_zbuffer.removeBackground(remove(meteor.getExplosion()));
						meteor.destroy();
						m_zbuffer.removeBackground(meteor);
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
							meteor = new Meteor( planet.radius() * 2, planet, false);
							
							add(meteor);
							add(meteor.getExplosion());
						}
					}
					//si le mechant meteor explose sur la planete
					if ( meteor != null && meteor.isExploding() && !meteor.giveLife() )
					{
						meteor.checkBlobbiesCollision();
						meteor.checkTreesCollision();
						if (meteor.hasExploded())
						{
							m_zbuffer.removeBackground(meteor.getExplosion());
							meteor.destroy();
							m_zbuffer.removeBackground(meteor);
							meteor = null;
						}
					}
					
					// Planet death condition
					if ( planet.isDead() || blobbies.length > 100 || (blobbies.length < 4 && m_iteration.getIterations() > 2))
					{
						FlxG.shake(0.01);
						FlxG.flash();
						// If we have a meteor roaming ... we delete it
						if ( meteor != null )
						{
							m_zbuffer.removeBackground(meteor.getExplosion());
							m_zbuffer.removeBackground(meteor);
							meteor.destroy();
						}
						
						// Create the birth meteor
						meteor = new Meteor(planet.radius() * 2, planet,true);
						add(meteor);
						add(meteor.getExplosion());
						
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
						var trees:Array = m_treeGenerator.trees();
						while ( trees.length != 0 )
						{
							var tree:Tree = trees.pop();
							m_zbuffer.removeTrees(tree);
							tree.destroy();
						}
						m_iteration.clear();
						planet.explosion();
						m_state = "Creation";
						initBlobies();
					}
					break;
			}
			
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
			var size:int = blobbies.length;
			for (var i:int = 0; i < size; i++) 

			{
				blobbies[i].visible = true;
			}
			
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
				blobbies.push(blob);
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
			if ( position < 0 )
			{
				position = 360 - position;
			}
			
			var trees:Array = m_treeGenerator.trees();
			for ( var i:uint = 0 ; i < trees.length ; i++ )
			{
				if ( trees[i] != null && trees[i].isVisible() == true && !trees[i].isGrowing() && !trees[i].isDead())
				{
					trace(Math.abs(trees[i].getPos() - position));
					if ( Math.abs( trees[i].getPos() - position) < 30 )
					{
						trace ("Tree !");
						trees[i].raining();
					}
				}
			}
		}
	}
}