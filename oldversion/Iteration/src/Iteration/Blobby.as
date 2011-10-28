package Iteration 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import mx.utils.NameUtil;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Moi
	 */
	public class Blobby extends Element
	{
		protected var timerMove:int = 0; //variable timer pour les déplacements
		protected var limitMove:int = 0; //temps limite pour le mouvement
		
		protected var speedX:Number;
		protected var speedY:Number;
		
		
		public function Blobby(_pos:Number,_distance:Number, _planet:Planet) 
		{
			super(_pos,_distance,_planet);
			
			graphics.beginFill(0xFFFF00, 1);
			graphics.drawCircle(0, 0,5);
			graphics.endFill();
			
			pos = _pos;
			
			var angle:Number = ( Math.PI / 180 ) * pos;
			
			x = planet.x + Math.cos(angle) * planet.radius;
			y = planet.y - Math.sin(angle) * planet.radius;
			//retrouver le vecteur blobby->planet
			var vecDir:Point = utils.getDirectionToPlanet(this, planet);
			
			//placer le blob eloigné de la planete sur ce vecteur
			x +=  ( -vecDir.x)  * utils.randRange(planet.radius/2, planet.radius);
			y +=  ( -vecDir.y)  * utils.randRange(planet.radius/2, planet.radius);
		}
		
		override public function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			speed = 5;
			addEventListener(Event.ENTER_FRAME, blobbyFall);
		}
		
				
		public function blobbyFall(e:Event):void 
		{			
			//si collision avec la planet
			if (!PixelCollisionUtil.getCollisionRect(this, planet, this, true).isEmpty() ) {
				explode();
				return;
			}
			//trouver le vecteur blobby->planet
			var vecDir:Point = utils.getDirectionToPlanet(this, planet);
			speedX = vecDir.x * speed;
			speedY = vecDir.y *speed;
			
			//déplacer le blobby
			x += speedX;
			y += speedY;
		}
		
		private function explode():void 
		{
			removeEventListener(Event.ENTER_FRAME, blobbyFall);
			speed = 0.2;
			addEventListener(Event.ENTER_FRAME, elementEnterFrame);
		}
		
		override public function elementEnterFrame(e:Event):void 
		{
			// positionner le blob sur la planet comme sur un cercle trigonométrique
			// de facon à pouvoir le faire tourner autour de la planete selon un angle pos
			place();
			
			//bouger aléatoirement le blobby
			changeDirection();
		}
		
		public function changeDirection():void 
		{
			//si le timer est toujours en cours
			if (timerMove <= limitMove) {
				//bouger le sprite
				switch(direction) {
					case 0: break;
					case 1: pos += speed; break;
					case 2: pos -= speed; break;
					default:break;
				}
				//incrémenter le timer
				timerMove ++;
				//s'arrêter là
				return;
			}
			
			//sinon on réinitialise le compteur avec une direction aléatoire
			var rand:Number = Math.random();
			
			if (rand < .5) {
				direction = 0;
			}else if (rand < .75) {
				direction = 1;
			}else {
				direction = 2;
			}
			
			timerMove = 0;//réinitialiser le compteur
			limitMove = utils.randRange(20, 100); //définir un temps aléatoire de déplacement de l'objet
		}
		
	}

}