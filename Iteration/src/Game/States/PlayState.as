package  Game.States
{
	import Game.Objects.Blobby;
	import Game.Objects.Meteor;
	import Game.Objects.Planet;
	import Game.Objects.Tree;
	import mx.core.FlexSprite;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class PlayState extends FlxState
	{		
		protected var planet:Planet;
		protected var blobbies:Array;
		protected var meteor:Meteor;
		protected var tree:Tree;
		
		
		protected var m_posCam:FlxPoint = new FlxPoint(0, 0);
		protected var m_speedCam:int = 2;
		protected var m_zoomCam:Number = 0.05;
		
		protected var text:FlxText;
		
		public function PlayState() 
		{
			//FPS
			text = new FlxText(100, 100, 150, FlxG.framerate.toString());
			add(text);
			//------CREER LA PLANETE-----------------
			planet = new Planet( FlxG.width/3 , FlxG.height/3, 100);
			
			add(planet);
			
			//-------CREER LES BLOBBIES--------------			
			blobbies = [];
			
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
			meteor = new Meteor(0, planet.radius() * 2, planet, blobbies);
			add(meteor);
			
			// On affiche la souris
			FlxG.mouse.show();
			// On positionne la caméra au centre de la planete
			var p:FlxPoint = planet.getMidpoint();
			// planet.getMidpoint(p);
			m_posCam.x = p.x;
			m_posCam.y = p.y;
		}
		
		override public function create():void {
			FlxG.bgColor = 0xff0a216b;
			// FlxG.bgColor = 0xffecebb3;
			
			// On charge la map
			//var map1:Map = new Map("map/test.xml");
			
			FlxG.camera.setBounds( -640, -480, 4 * 640, 4 * 480, true);
			
			tree = new Tree(planet.center(), planet.radius()-2,planet);
            add(tree);
		}
		
		override public function update():void {
			text.text = FlxG.framerate.toString()+" fps";
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