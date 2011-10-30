package  
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Element extends FlxSprite
	{
		protected var m_pos: Number = 0; //position sur le cercle représentant la planète
		protected var m_direction:int = 0; //variable de mouvement; 0:stationnaire, 1:a droite; 2:a gauche
		protected var m_distance:Number = 0; //éloignement par rapport au centre de la planete
		
		public var m_speed:Number = 0.15; // vitesse de déplacement
		public var m_dead:Boolean = false; // mort du sprite
		
		public var m_planet:Planet; // référence vers la planete pour diverses raisons
		
		// params : pos = angle par rapport au cerlcle de la planete 
		//			distance = distance par rapport au centre de la planete
		//			planet = ben... la reference vers la planete quoi
		public function Element(pos:Number, distance:Number , planet:Planet, Graphic:Class = null ) 
		{
			super(x, y, Graphic);
			
			m_planet = planet ;
			m_distance = distance;
			m_pos = pos;
		}
		
		//place un élément en calculant sa position par rapport a la planete
		public function place():void {
			
			//conversion en radians de l'angle de position sur le cercle(planete)
			var angle:Number = ( Math.PI / 180 ) * m_pos;
			
			x = m_planet.m_center.x + Math.cos(angle) * m_distance - this.width /2;
			y = m_planet.m_center.y - Math.sin(angle) * m_distance - this.height/2;
		}
		
	}

}