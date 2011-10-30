package  
{
	import flash.geom.Point;
	import org.flixel.*;
	/**
	 * ...
	 * @author ...
	 */
	public class Planet extends FlxSprite
	{		
		[Embed(source = "../bin/img/planet.png")] private var ImgPlnt:Class;
		
		public var m_center:Point;//centre de la planete
		public var m_radius:Number; //son rayon
		
		public function Planet(x:Number,y:Number) 
		{
			super(x, y, ImgPlnt);
			m_center = new Point(x + this.width / 2, y + this.height / 2);
			m_radius = this.height/2;
		}
		
	}

}