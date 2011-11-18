package Game.States 
{
	import Game.Buttons.BackButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import Resources.SpriteResources;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class CreditState extends FlxState 
	{
		protected var m_background:FlxSprite;
		protected var m_backbutton:BackButton;
		
		public function CreditState() {
			
		}
		
		override public function create():void {
			FlxG.mouse.show();
			
			m_background = new FlxSprite();
			m_background.loadGraphic2(SpriteResources.ImgCreditBackground, false, false, 1280, 720, true);
			add(m_background);
			
			m_backbutton = new BackButton(((1280 / 7) * 6 - 117 / 2), ((720 / 6) * 5 - 103 / 2), null, function() { FlxG.switchState(new MenuState()); } );
			add(m_backbutton);
		}
		
	}

}