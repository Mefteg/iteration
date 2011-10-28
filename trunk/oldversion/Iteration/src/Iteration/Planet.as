package Iteration 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Moi
	 */
	public class Planet extends Sprite
	{
		public var radius:Number;
		
		public function Planet(cX:Number, cY:Number , _radius:Number) 
		{
			//dessiner la planete
			graphics.beginFill(0x0080FF, 1);
			graphics.drawCircle(0, 0, _radius);
			graphics.endFill();
			
			x = cX;
			y = cY;
			
			radius = _radius;
						
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
	}

}