package Game.Objects
{
	import flash.geom.Point;
	import org.flixel.*;
	
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author ...
	 */
	public class Meteor extends Element
	{
		
		
		protected var m_fall:Boolean = false;
		
		public function Meteor(sprite:Class,pos:Number,distance:Number,planet:Planet) 
		{
			super(pos, distance, planet);
			//Créer l'image
			loadRotatedGraphic(sprite, 360);
			m_speed = 0.3;
			//dimensionner le météore par rapport a la planete
			this.scale.x = (0.1 * planet.getHeight())/width;
			this.scale.y = (0.1 * planet.getWidth()) / height;
			
		}
		
		override public function update():void {
			//si l'utilisateur clique sur le météore
			if (onClick()) {
				//on fait tomber le météore
				m_fall = true;
			}
			//réduire la distance entre le météore et la planète
			if (m_fall)
				m_distance -= m_speed * (1 / m_distance * 250 );
			//faire tourner le météore en orbite
			m_pos += m_speed;
			//placer le météore
			place();
			//le faire tourner sur lui meme
			angle--;
			
			super.update();
			
			//si le météore atteint la planete :: il explose
			if (m_distance <= m_planet.radius())
				explode();
		}
		
		public function explode():void {
			//vérifier la collision du météore avec les blobbies
			for each (var b:Blobby in m_planet.getBlobbies()) {
				//les killer si c'est le cas
				if (FlxG.overlap(this, b))
					b.destroy();
			}
			//vérifier la collision du météore avec les arbres
			for each (var t:Tree in m_planet.getTrees()) {
				//les killer si c'est le cas
				if (FlxG.overlap(this, t))
					t.destroy();
			}
			//Detruire le météore
			destroy();
		}
		
		override public function destroy():void {
			super.destroy();
		}
		
	}

}