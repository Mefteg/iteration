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
		private var m_heart2:FlxSprite;
		private var m_heart3:FlxSprite;
		
		protected var m_blobbies:Array;
		protected var m_trees:Array;
		
		private var m_elapsedTime:Number = 0;
		
		private var m_center:Point;//centre de la planete
		private var m_radius:Number; //son rayon
		
		private var m_resources:int; // ressources de la planete
		private var m_distance:Number = 0;
		
		public function Planet(x:Number, y:Number, blobbies:Array,trees:Array ) 
		{
			m_planet = new FlxSprite(x, y, SpriteResources.ImgPlnt);
			add(m_planet);
			
			m_center = new Point(x + m_planet.width / 2, y + m_planet.height / 2);
			m_radius = (m_planet.height) / 2;
			
			m_blobbies = blobbies;
			m_trees = trees;
			
			m_resources = 10000;
		}
		
		override public function update():void 
		{
			super.update();
			m_planet.scale = new FlxPoint(GameParams.worldZoom, GameParams.worldZoom);
			
			if ( m_heart != null && m_heart2 != null && m_heart3 != null )
			{
				m_heart2.angle-= 0.1;
				m_heart2.scale = new FlxPoint(GameParams.worldZoom, GameParams.worldZoom);
				m_heart3.angle += 0.1;
				m_heart3.scale = new FlxPoint(GameParams.worldZoom, GameParams.worldZoom);

							
				var pulse:Number = (Math.sin(m_elapsedTime * 4) / 4) / (Math.sin(m_elapsedTime / 4) * 4) / 64;
				// var pulse:Number = (Math.sin(m_elapsedTime*4)/2)/(Math.cos(m_elapsedTime-4)*8);
				m_heart.scale.x = (pulse + (m_resources/10000)*0.7096) * GameParams.worldZoom;
				m_heart.scale.y = (pulse + (m_resources/10000)*0.7096) * GameParams.worldZoom;
				// Change the speed of the pulse
				m_elapsedTime += FlxG.elapsed * 8;
				
				m_heart.x = center().x + Math.cos(m_heart.angle) * (m_distance)*GameParams.worldZoom - m_heart.width /2;
				m_heart.y = center().y - Math.sin(m_heart.angle) * (m_distance) * GameParams.worldZoom - m_heart.height / 2;
				m_heart2.x = center().x + Math.cos(m_heart2.angle) * (m_distance)*GameParams.worldZoom - m_heart2.width /2;
				m_heart2.y = center().y - Math.sin(m_heart2.angle) * (m_distance) * GameParams.worldZoom - m_heart2.height / 2;
				m_heart3.x = center().x + Math.cos(m_heart3.angle) * (m_distance)*GameParams.worldZoom - m_heart3.width /2;
				m_heart3.y = center().y - Math.sin(m_heart3.angle) * (m_distance) * GameParams.worldZoom - m_heart3.height / 2;
			}
		}
		
		public function center():Point
		{
			return m_center;
		}
		
		public function radius():Number
		{
			return m_radius;
		}
		
		public function getMidpoint():FlxPoint
		{
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
		
		public function setScale(value:FlxPoint):void {
			m_planet.scale = value;
		}
		
		public function getDistance():Number {
			return m_distance;
		}
		
		public function setDistance(value:Number):void {
			m_distance = value;
		}
		
		//supprime un blobby
		public function removeBlobby(blobby:Blobby):void {
			var index:int = m_blobbies.indexOf(blobby);
			m_blobbies[index].setState("die");
			m_blobbies.splice(index, 1);
		}
		public function removeBlobbyAt(index:int):void {
			m_blobbies[index].setState("die");
			m_blobbies.splice(index, 1);
		}
		public function isDead():Boolean
		{
			if ( m_resources < 0 )
			{
				return true;
			}
			return false;
		}
		
		public function live():void
		{
			m_resources = 10000;
			
			m_heart = new FlxSprite(m_planet.x, m_planet.y, SpriteResources.ImgHeart);
			m_heart2 = new FlxSprite(m_planet.x / 2, m_planet.y / 2, SpriteResources.ImgHeart2);
			m_heart2.scale.x = 0.4096;
			m_heart2.scale.y = 0.4096;
			m_heart3 = new FlxSprite(m_planet.x / 2, m_planet.y / 2, SpriteResources.ImgHeart3);
			m_heart3.scale.x = 0.4096;
			m_heart3.scale.y = 0.4096;
			
			add(m_heart2);
			add(m_heart3);
			add(m_heart);
		}
		
		public function explosion():void
		{
			remove(m_heart);
			remove(m_heart2);
			remove(m_heart3);
			
			m_heart.destroy();
			m_heart2.destroy();
			m_heart3.destroy();
			
			m_heart = null;
			m_heart2 = null;
			m_heart3 = null;
		}
	}

}