package Game.Objects
{
	import org.flixel.*;
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
		
		protected var m_state:String; // Etat de l'élément
		
		// params : pos = angle par rapport au cerlcle de la planete 
		//			distance = distance par rapport au centre de la planete
		//			planet = ben... la reference vers la planete quoi
		public function Element(pos:Number, distance:Number , planet:Planet ) 
		{
			super(x, y);
			m_planet = planet ;
			m_distance = distance;
			m_pos = pos;
		}
				
		//place un élément en calculant sa position par rapport a la planete
		public function place():void {
			
			//conversion en radians de l'angle de position sur le cercle(planete)
			var angle:Number = ( Math.PI / 180 ) * m_pos;
			
			x = m_planet.center().x + Math.cos(angle) * m_distance - this.width /2;
			y = m_planet.center().y - Math.sin(angle) * m_distance - this.height/2;
		}
		//effectue une rotation pour placer le bas du sprite sur la surface de la planete
		public function rotateToPlanet() :void{
			this.angle = -m_pos + 90;
		}
		
		public function onClick():Boolean {
			//si click de la souris
			if (FlxG.mouse.justPressed()) {
				var mouseX:int = FlxG.mouse.x;
				var mouseY:int = FlxG.mouse.y;
				//et si la souris se trouve sur le sprite
				if ( ( mouseX < x + width) && (mouseX > x) ) {
					if ( (mouseY < y + height) && (mouseY > y) ) {
						return true;
					}
				}
			}
			return false;
		}
		
		override public function destroy():void {
			super.destroy();
			m_planet = null;
			m_dead = true;
			this.kill();
		}
		
		public function setPos(pos:Number):void {
			m_pos = pos;
		}
		
		public function setDistance(distance:Number) :void{
			m_distance = distance;
		}
		
	}

}