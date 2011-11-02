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
			//Créer l'image
			loadGraphic(ImgMeteor, false, false, 67, 67);
			//dimensionner le météore par rapport a la planete
			this.scale.x = (0.2 * planet.getHeight())/width;
			this.scale.y = (0.2 * planet.getWidth())/height;
			
			m_blobbies = blobbies;
		}
		
		override public function update():void {
			//si l'utilisateur clique sur le météore
			if (onClick()) {
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
			//le faire tourner
			angle--;
			super.update();
			
			//si le météore atteint la planete ::
			if (m_distance <= m_planet.radius())
				explode();
		}
		
		public function explode():void {
			//vérifier la collision du météore avec les blobbies
			for each (var b:Blobby in m_blobbies) {
				//les killer si c'est le cas
				if (FlxG.overlap(this, b))
					b.destroy();
			}
			//Detruire le météore
			destroy();
		}
		
		override public function destroy():void {
			super.destroy();
			m_blobbies = null;
		}
		
	}

}