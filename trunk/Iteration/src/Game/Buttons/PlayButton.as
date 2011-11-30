package Game.Buttons 
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import Resources.SpriteResources;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class PlayButton extends FlxButton 
	{
		private var rotateRight:Boolean = false;
		private var angleMax:Number = 5;
		
		public function PlayButton(X:Number = 0, Y:Number = 0, Label:String = null, OnClick:Function = null) {
			super(X, Y, Label, OnClick);
			loadGraphic2(SpriteResources.ImgMenuPlaybutton, false, false, 232, 114, true);
		}		
		
		override public function update():void {
			super.update();
			if (mouseOn())
				animate();
				//scale = new FlxPoint(1.05, 1.05);
			else
				angle = 0;
				//scale = new FlxPoint(1, 1);
				
		}
		
		private function animate():void 
		{
			if (rotateRight) {
				angle += 0.3;
				if (angle > angleMax)
					rotateRight = false;
			}else {
				angle-= 0.3;
				if (angle < -angleMax)
					rotateRight = true;
			}
		}
		
		public function mouseOn():Boolean {
			if ( (FlxG.mouse.x > x) && (FlxG.mouse.x < x+width))
				if ( (FlxG.mouse.y > y) && (FlxG.mouse.y < y+height))
					return true;
			return false;
		}
	}

}