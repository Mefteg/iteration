package  
{
	import flash.geom.Point;
	import org.flixel.*;
	/**
	 * ...
	 * @author ...
	 */
	public class Meteor extends Element
	{
		[Embed(source = "../bin/img/meteor.gif")] private var ImgMeteor:Class;
		protected var m_blobbies:Array;
		protected var m_fall:Boolean = false;
		
		public function Meteor(pos:Number,distance:Number,planet:Planet,blobbies:Array) 
		{
			super(pos, distance, planet);
			loadRotatedGraphic(ImgMeteor);
			//dimensionner le météore par rapport a la planete
			this.scale.x = (0.2 * planet.getHeight())/width;
			this.scale.y = (0.2 * planet.getWidth())/height;
			
			m_blobbies = blobbies;
		}
		
		override public function update():void {
			//si l'utilisateur clique sur le météore
			if (FlxG.mouse.justPressed()) {
				//on fait tomber le météore
				m_fall = true;
			}
			//réduire la distance entre le météore et la planète
			if (m_fall)
				m_distance -= m_speed;
			//faire tourner le météore en orbite
			m_pos += m_speed;
			//placer le météore
			place();
			super.update();
		}
		
	}

}