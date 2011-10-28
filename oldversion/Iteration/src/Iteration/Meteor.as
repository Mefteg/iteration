package Iteration 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.engine.ElementFormat;
	
	/**
	 * ...
	 * @author Moi
	 */
	public class Meteor extends Element
	{
		protected var speedX:Number;
		protected var speedY:Number;
		
		protected var blobbies:Array;
		
		public function Meteor(_pos:Number,_distance:Number,_planet:Planet,_blobby:Array ) 
		{
			super(_pos,_distance,_planet);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			graphics.beginFill(0xFF0000, 1);
			graphics.drawCircle(0, 0,15);
			graphics.endFill();
						
			speed = 1;
			
			blobbies = _blobby;
		}
		
		override public function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.ENTER_FRAME, orbit);
			addEventListener(MouseEvent.CLICK, triggerFalling);
		}
		
		private function triggerFalling(e:MouseEvent):void 
		{
			removeEventListener(MouseEvent.CLICK, triggerFalling);
			addEventListener(Event.ENTER_FRAME, elementEnterFrame);
		}
		
		private function orbit(e:Event):void 
		{
			place();
			pos += speed;
			
		}
		
		
		override public function elementEnterFrame(e:Event):void 
		{
			//removeEventListener(Event.ENTER_FRAME, orbit);
			
			//sortir si la météorite est déjà morte
			if (dead) return;
			if (!PixelCollisionUtil.getCollisionRect(this, planet, this, true).isEmpty() ) {
				explode();
				return;
			}
			
			distance-= speed;
			place();
			
			/*//diriger la météorite vers la planet
			var ax:Number = (planet.x - x);//variation en x
			var ay:Number = (planet.y - y);//variation en y
			var magn:Number = Math.sqrt( ax * ax + ay * ay );//longueur du vecteur meteor->planet
			//normaliser ce vecteur
			speedX =  ax/magn * speed; 
			speedY =  ay / magn * speed;
			//déplacer le météore
			x += speedX;
			y += speedY;*/
		}
		
		private function explode():void 
		{
			//avant l'explosion, tester la collision de la météorite avec les blobbies
			for (var i:int = 0; i < blobbies.length ; i++) 
			{
				if (this.hitTestObject(blobbies[i])) {
					blobbies[i].destroy();
				}
			}
			
			this.destroy();
		}
		
	}

}