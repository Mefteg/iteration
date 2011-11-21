package Game.Buttons 
{
	import org.flixel.FlxButton;
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author Moi
	 */
	public class TutoButton extends FlxButton
	{
		
		public function TutoButton(X:Number = 0, Y:Number = 0, Label:String = null, OnClick:Function = null) 
		{
			super(X, Y, Label, OnClick);
			loadGraphic2(SpriteResources.ImgMenuTutobutton, false, false, 232, 114, true);
		}
		
	}

}