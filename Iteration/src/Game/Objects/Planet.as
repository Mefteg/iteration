package Game.Objects
{
	import flash.geom.Point;
	import Globals.GameParams;
	import org.flixel.*;
	
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author ...
	 */
	public class Planet extends FlxGroup
	{				
		private var m_planet:FlxSprite;
		private var m_heart:FlxSprite;
		
		protected var m_blobbies:Array;
		protected var m_trees:Array;
		
		private var m_elapsedTime:Number = 0;
		
		private var m_center:Point;//centre de la planete
		private var m_radius:Number; //son rayon
		
		private var m_resources:int; // ressources de la planete
		
		public function Planet(x:Number, y:Number, offsetSurface:Number, blobbies:Array,trees:Array ) 
		{
			m_planet = new FlxSprite(x, y, SpriteResources.ImgPlnt);
			m_planet.scale.x = GameParams.scale;
			m_planet.scale.y = GameParams.scale;
			add(m_planet);
			
			m_heart = new FlxSprite(m_planet.width / 2, m_planet.height / 2, SpriteResources.ImgHeart);
			m_heart.scale.x = GameParams.scale;
			m_heart.scale.y = GameParams.scale;
			add(m_heart);
			
			m_center = new Point(x + m_planet.width / 2, y + m_planet.height / 2);
			m_radius = (m_planet.height - offsetSurface) / 2;
			
			m_blobbies = blobbies;
			m_trees = trees;
			
			m_resources = 10000;
		}
		
		override public function update():void 
		{
			super.update();
						
			var pulse:Number = (Math.sin(m_elapsedTime * 4) / 4) / (Math.sin(m_elapsedTime / 4) * 4) / 64;
			// var pulse:Number = (Math.sin(m_elapsedTime*4)/2)/(Math.cos(m_elapsedTime-4)*8);
			m_heart.scale.x = pulse + (m_resources/10000)*1.18;
			m_heart.scale.y = pulse + (m_resources/10000)*1.18;
			// Change the speed of the pulse
			m_elapsedTime += FlxG.elapsed * 8;
		}
		
		public function center():Point
		{
			return m_center;
		}
		
		public function radius():Number
		{
			return m_radius * GameParams.scale;
		}
		
		public function getMidpoint():FlxPoint
		{
			var planetMid:FlxPoint = new FlxPoint();
			//planetMid.x = m_planet.x + (m_planet.width * GameParams.scale) / 2
			//planetMid.y = m_planet.y + (m_planet.height * GameParams.scale) / 2
			planetMid.x = m_planet.x;
			planetMid.x = m_planet.y;
			return m_planet.getMidpoint();
		}
		
		public function getWidth():Number
		{
			return m_planet.width;
		}
		
		public function getHeight():Number
		{
			return m_planet.height;
		}
		
		public function getBlobbies():Array {
			return m_blobbies;
		}
		
		public function getTrees():Array {
			return m_trees;
		}
		
		public function getResources():int {
			return m_resources;
		}
		
		public function addResources(n:int):void {
			m_resources += n;
		}
		
		public function removeResources(n:int):void {
			m_resources -= n;
		}
	}

}