package  Game.States
{
	import flash.utils.Timer;
	import flash.media.Sound;
	import Game.Camera;
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
	
	/**
	 * ...
	 * @author Tom
	 */
	public class PlayState extends FlxState
	{		
		private var m_camera:Camera;
		
		private var m_soundBank:SoundBank = new SoundBank();
				
		//objets
		protected var background:FlxSprite;
		protected var planet:Planet;
		protected var blobbies:Array;
		protected var meteor:Meteor;
		protected var trees:Array;
		protected var clouds:Array;
		
		//itération
		protected var m_iteration:Iteration;
		//variables caméra
		protected var text:FlxText;
		
		public function PlayState() 
		{
			// Background init
			background = new FlxSprite( -37, 147, SpriteResources.ImgBackground);	// HACK TODO FIX THIS
			background.scale.x = GameParams.scale;
			background.scale.y = GameParams.scale;
			add(background);
			
			//initialisations
			blobbies = new Array();
			trees = new Array();
			clouds = new Array();
			//FPS
			text = new FlxText(100, 100, 150, FlxG.framerate.toString());
			add(text);
			//------CREER LA PLANETE-----------------
			planet = new Planet( FlxG.width/2 , FlxG.height/2, 64 ,blobbies,trees);
			add(planet);
			//-------CREER LA CLASSE D'ITERATION-----
			m_iteration = new Iteration(this,planet);
			
			//-------CREER LES BLOBBIES--------------			
			
			//tableau de positions des blobbies à créer
			var tabBlobbiesPosition:Array = [ 2 , 90, 200,21 ];
											
			var blob:Blobby;
			var sizeBlob:uint = tabBlobbiesPosition.length; // optimisation
			
			for (var i:int = 0; i < sizeBlob ; i++) 
			{
				blob = new Blobby( tabBlobbiesPosition[i],planet.radius(), planet);
				blobbies.push(blob);
				add(blob);
			}
								
						
			//----------CREER LE METEOR-------------
			meteor = new Meteor(SpriteResources.ImgMeteor,0, planet.radius() * 2, planet);
			add(meteor);
			
			//SON
			var m_sound:SoundEngine.Sound = new SoundEngine.Sound(SoundResources.backgroundMusic, true);
			m_soundBank.add(m_sound, "Background");
			m_soundBank.get("Background").play();
			
			// On affiche la souris
			FlxG.mouse.show();			
		}
		
		override public function create():void {
			FlxG.bgColor =  0xff0a216b ;
			//FlxG.bgColor = 0xffecebb3;
			
			// On charge la map
			//var map1:Map = new Map("map/test.xml");

			m_camera = new Camera(planet.getMidpoint(), 0, 0, FlxG.width*2, FlxG.height*2, true);
			
			var j:int = 0;
			//----------CREER LES ARBRES------------
			var tree:Tree;
			for (j = 0; j < 4; j++) 
			{
				tree = new Tree(planet.center(), planet);
				trees.push(tree);
				add(tree);
			}
			
			// Clouds init
			var cloud:Cloud;
			for (j = 0 ; j < GameParams.nbTree ; j++ )
			{
				cloud = new Cloud(planet.radius() +10, planet);
				clouds.push(cloud);
				add(cloud);
			}
		}
		
		override public function update():void {
			//update le texte
			text.text = m_iteration.getIterations() + " iterations \n" + planet.getResources()+" resources \n" + planet.getBlobbies().length + " blobbies";
			//mettre a jour l'itération
			m_iteration.update();
			
			m_camera.update();
			
			super.update();
		}
	}

}