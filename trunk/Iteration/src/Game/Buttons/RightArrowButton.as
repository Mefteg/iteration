package Game.Buttons 
{
	import org.flixel.FlxButton;
	import Resources.SpriteResources;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class RightArrowButton extends FlxButton 
	{
		
		public function RightArrowButton(X:Number = 0, Y:Number = 0, Label:String = null, OnClick:Function = null) {
			super(X, Y, Label, OnClick);
			loadGraphic2(SpriteResources.ImgTutoRightArrow, false, false, 57, 73, true);
		}
		
	}

}