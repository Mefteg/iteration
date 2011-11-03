package  Game.States
{
	import flash.utils.Timer;
	import flash.media.Sound;
	import Game.Objects.Blobby;
	import Game.Objects.Meteor;
	import Game.Objects.Planet;
	import Game.Objects.Tree;
	import mx.core.FlexSprite;
	import org.flixel.*;
	import Resources.SoundResources;
	import SoundEngine.SoundBank;
	import SoundEngine.Sound;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class PlayState extends FlxState
	{		
		
		private var m_soundBank:SoundBank = new SoundBank();
		
		//objets
		protected var planet:Planet;
		protected var blobbies:Array;
		protected var meteor:Meteor;
		protected var trees:Array;
		
		protected var m_iteration:Iteration;
		
		protected var m_posCam:FlxPoint = new FlxPoint(0, 0);
		protected var m_speedCam:int = 2;
		protected var m_zoomCam:Number = 0.05;
		
		protected var text:FlxText;
		
		public function PlayState() 
		{
			//initialisations
			blobbies = new Array();
			trees = new Array();
			//FPS
			text = new FlxText(100, 100, 150, FlxG.framerate.toString());
			add(text);
			//------CREER LA PLANETE-----------------
			planet = new Planet( FlxG.width/3 , FlxG.height/3, 100 ,blobbies,trees);
			add(planet);
			//-------CREER LA CLASSE D'ITERATION-----
			m_iteration = new Iteration(this,planet);
			
			//-------CREER LES BLOBBIES--------------			
			
			//tableau de positions des blobbies à créer
			var tabBlobbiesPosition:Array = [ 2 , 90, 200,21,300,44,88,145 ];
											
			var blob:Blobby;
			var sizeBlob:uint = tabBlobbiesPosition.length; // optimisation
			
			for (var i:int = 0; i < sizeBlob ; i++) 
			{
				blob = new Blobby( tabBlobbiesPosition[i],planet.radius(), planet);
				blobbies.push(blob);
				add(blob);
			}
								
						
			//----------CREER LE METEOR-------------
			meteor = new Meteor(0, planet.radius() * 2, planet);
			add(meteor);
			
			//SON
			var m_sound:SoundEngine.Sound = new SoundEngine.Sound(SoundResources.backgroundMusic, true);
			m_soundBank.add(m_sound, "Background");
			m_soundBank.get("Background").play();
			
			// On affiche la souris
			FlxG.mouse.show();
			// On positionne la caméra au centre de la planete
			var p:FlxPoint = planet.getMidpoint();
			// planet.getMidpoint(p);
			m_posCam.x = p.x;
			m_posCam.y = p.y;
			
		}
		
		override public function create():void {
			FlxG.bgColor =  0xff0a216b ;
			//FlxG.bgColor = 0xffecebb3;
			
			// On charge la map
			//var map1:Map = new Map("map/test.xml");
			
			FlxG.camera.setBounds( -640, -480, 4 * 640, 4 * 480, true);
			
			//----------CREER LES ARBRES------------
			var tree:Tree;
			for (var j:int = 0; j < 4; j++) 
			{
				tree = new Tree(planet.center(), planet);
				trees.push(tree);
				add(tree);
			}
		}
		
		override public function update():void {
			//update le texte
			text.text = m_iteration.getIterations() + " iterations \n" + planet.getResources()+" resources \n" + planet.getBlobbies().length + " blobbies";
			//mettre a jour l'itération
			m_iteration.update();
			
			// On replace la caméra
			if ( FlxG.mouse.screenX*FlxG.camera.zoom < 30 ) {
				m_posCam.x -= m_speedCam;
			}
			if ( FlxG.mouse.screenX*FlxG.camera.zoom > FlxG.width - 30 ) {
				m_posCam.x += m_speedCam;
			}
			if ( FlxG.mouse.screenY*FlxG.camera.zoom < 30 ) {
				m_posCam.y -= m_speedCam;
			}
			if ( FlxG.mouse.screenY*FlxG.camera.zoom > FlxG.height - 30 ) {
				m_posCam.y += m_speedCam;
			}
			FlxG.camera.focusOn(m_posCam);
			// On gère le zoom
			if ( FlxG.keys.Z && FlxG.camera.zoom < 3 ) {
				FlxG.camera.zoom += m_zoomCam;				
			}
			if ( FlxG.keys.S && FlxG.camera.zoom > 1 ) {
				FlxG.camera.zoom -= m_zoomCam;
			}
			// On replace la caméra au centre de la planete
			if ( FlxG.keys.SPACE ) {
				FlxG.camera.zoom = 1;
				m_posCam = planet.getMidpoint();
			}
			
			super.update();
		}
	}

}