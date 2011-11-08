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
		private var m_roamingDistance:Number;
		
		protected var m_fall:Boolean = false;
		
		private var m_hasExploded:Boolean = false;
		
		public function Meteor(sprite:Class,roamingDistance:Number,planet:Planet) 
		{
			super(0, roamingDistance * 2, planet);
			m_roamingDistance = roamingDistance;
			//Créer l'image
			loadGraphic(sprite, false, false, 67, 67);
			m_speed = 0.3;
			//dimensionner le météore par rapport a la planete
			this.scale.x = (0.1 * planet.getHeight())/width;
			this.scale.y = (0.1 * planet.getWidth()) / height;
			
			m_state = "Incoming";
		}
		
		override public function update():void 
		{
			switch (m_state)
			{
				case "Incoming":
					m_distance-= 2;
					if ( m_distance <= m_roamingDistance )
					{
						m_state = "Roaming";
					}
					break;
				case "Roaming":
					//si l'utilisateur clique sur le météore
					//if (onClick()) 
					//{
						//on fait tomber le météore
						m_state = "Crashing";
					//}
					break;
				case "Crashing":
					//réduire la distance entre le météore et la planète
					m_distance -= (m_speed * (1 / m_distance * 250 ))*6;
					
					//si le météore atteint la planete :: il explose
					if (m_distance <= m_planet.radius())
						explode();
					break;
			}
			
			//faire tourner le météore en orbite
			m_pos += m_speed;
			
			//placer le météore
			place();
			
			//le faire tourner sur lui meme
			angle--;
			
			super.update();
		}
		
		public function explode():void {
			//vérifier la collision du météore avec les blobbies
			for each (var b:Blobby in m_planet.getBlobbies()) 
			{
				//les killer si c'est le cas
				if (FlxG.overlap(this, b))
					b.destroy();
			}
			//vérifier la collision du météore avec les arbres
			for each (var t:Tree in m_planet.getTrees()) 
			{
				//les killer si c'est le cas
				if (FlxG.overlap(this, t))
					t.destroy();
			}
			
			m_hasExploded = true;
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
		
		public function hasExploded():Boolean
		{
			return m_hasExploded;
		}
		
	}

}