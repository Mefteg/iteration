package Game.States 
{
	import Game.Buttons.BackButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author Moi
	 */
	public class TutoState extends FlxState
	{
		protected var m_background:FlxSprite;
		protected var m_backbutton:BackButton;
		
		public function TutoState() 
		{
			
		}
		
		override public function create():void {
			FlxG.mouse.show();
			FlxG.mouse.load(SpriteResources.ImgMouseCursor);
			
			m_background = new FlxSprite();
			m_background.loadGraphic2(SpriteResources.ImgTuto, false, false, 1280, 720, true);
			add(m_background);
			
			m_backbutton = new BackButton(((1280 / 7) * 6.3 ), ((720 / 6) * 5 ), null, function() { FlxG.switchState(new MenuState()); } );
			add(m_backbutton);
		}
		
	}

}