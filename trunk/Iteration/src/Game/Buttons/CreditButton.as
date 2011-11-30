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
	public class CreditButton extends FlxButton 
	{
		public function CreditButton(X:Number = 0, Y:Number = 0, Label:String = null, OnClick:Function = null) {
			super(X, Y, Label, OnClick);
			loadGraphic2(SpriteResources.ImgMenuCreditbutton, false, false, 194, 95, true);
		}
		
		override public function update():void {
			super.update();
			if (mouseOn())
				scale = new FlxPoint(1.05, 1.05);
			else
				scale = new FlxPoint(1, 1);
		}
		
		public function mouseOn():Boolean {
			if ( (FlxG.mouse.x > x) && (FlxG.mouse.x < x+width))
				if ( (FlxG.mouse.y > y) && (FlxG.mouse.y < y+height))
					return true;
			return false;
		}
	}

}