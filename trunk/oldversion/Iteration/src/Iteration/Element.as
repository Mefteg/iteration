package Iteration 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Moi
	 */
	public class Element extends Sprite
	{	
		protected var pos: Number = 0; //position sur le cercle représentant la planète
		protected var direction:int = 0; //variable de mouvement; 0:stationnaire, 1:a droite; 2:a gauche
		protected var distance:Number = 0; //éloignement par rapport au centre de la planete
		
		public var utils:Utils = new Utils();
		public var speed:Number = 0.15;
		public var dead:Boolean = false;
				
		public var planet:Planet;
		
		// params : pos = angle par rapport au cerlcle de la planete 
		//			distance = distance par rapport au centre de la planete
		//			planet = ben... la reference vers la planete quoi
		public function Element(_pos:Number, _distance:Number, _planet:Planet ) 
		{			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			planet = _planet;
			distance = _distance;
		}
		
		public function place():void {
			
			//conversion en radians
			var angle:Number = ( Math.PI / 180 ) * pos;
			
			x = planet.x + Math.cos(angle) * distance;
			y = planet.y - Math.sin(angle) * distance;
		}
		
		public function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
						
			addEventListener(Event.ENTER_FRAME, elementEnterFrame);
		}
				
		public function elementEnterFrame(e:Event):void 
		{
					
		}
				
		public function destroy():void 
		{
			if (!dead) {
				dead = true;
				removeEventListener(Event.ENTER_FRAME, elementEnterFrame);
				//retirer l'objet de son parent
				this.parent.removeChild(this);
				
			}
		}
		
		
	}

}