package Game.Objects
{
	import flash.geom.Point;
	import org.flixel.*;
	/**
	 * ...
	 * @author ...
	 */
	public class Planet extends FlxGroup
	{		
		[Embed(source = "../../../bin/img/planete2.png")] private var ImgPlnt:Class;
		[Embed(source = "../../../bin/img/heart4.png")] private var ImgHeart:Class;
		
		private var m_planet:FlxSprite;
		private var m_heart:FlxSprite;
		
		private var m_elapsedTime:Number = 0;
		
		private var m_center:Point;//centre de la planete
		private var m_radius:Number; //son rayon
		
		public function Planet(x:Number,y:Number, offsetSurface:Number) 
		{
			m_planet = new FlxSprite(x, y, ImgPlnt);
			add(m_planet);
			
			m_heart = new FlxSprite(x+offsetSurface/2, y+offsetSurface/2, ImgHeart);
			add(m_heart);
			
			m_center = new Point(x + m_planet.width / 2, y + m_planet.height / 2);
			m_radius = (m_planet.height-offsetSurface)/2;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			var pulse:Number = (Math.sin(m_elapsedTime * 4) / 4) / (Math.sin(m_elapsedTime / 4) * 4) / 64;
			// var pulse:Number = (Math.sin(m_elapsedTime*4)/2)/(Math.cos(m_elapsedTime-4)*8);
			m_heart.scale.x = pulse + 1;
			m_heart.scale.y = pulse + 1;
			// Change the speed of the pulse
			m_elapsedTime += FlxG.elapsed * 8;
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
	}

}