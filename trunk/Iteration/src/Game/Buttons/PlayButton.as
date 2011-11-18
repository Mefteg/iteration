package Game.Buttons 
{
	import org.flixel.FlxButton;
	import Resources.SpriteResources;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class PlayButton extends FlxButton 
	{
		public function PlayButton(X:Number = 0, Y:Number = 0, Label:String = null, OnClick:Function = null) {
			super(X, Y, Label, OnClick);
			loadGraphic2(SpriteResources.ImgMenuPlaybutton, false, false, 190, 94, true);
		}		
	}

}