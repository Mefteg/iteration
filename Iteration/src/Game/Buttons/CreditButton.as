package Game.Buttons 
{
	import org.flixel.FlxButton;
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
	}

}