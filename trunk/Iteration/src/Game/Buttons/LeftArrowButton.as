package Game.Buttons 
{
	import org.flixel.FlxButton;
	import Resources.SpriteResources;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class LeftArrowButton extends FlxButton 
	{
		
		public function LeftArrowButton(X:Number = 0, Y:Number = 0, Label:String = null, OnClick:Function = null) {
			super(X, Y, Label, OnClick);
			loadGraphic2(SpriteResources.ImgTutoLeftArrow, false, false, 57, 73, true);
		}	
		
	}

}