package Game.Buttons 
{
	import org.flixel.FlxButton;
	import Resources.SpriteResources;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class BackButton extends FlxButton 
	{
		
		public function BackButton(X:Number = 0, Y:Number = 0, Label:String = null, OnClick:Function = null) {
			super(X, Y, Label, OnClick);
			loadGraphic2(SpriteResources.ImgCreditBackbutton, false, false, 117, 103, true);
		}
		
	}

}