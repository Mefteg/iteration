package Game.States 
{
	import Game.Buttons.CreditButton;
	import Game.Buttons.PlayButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import Resources.SpriteResources;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class MenuState extends FlxState 
	{
		protected var m_background:FlxSprite;
		protected var m_playbutton:PlayButton;
		protected var m_creditbutton:CreditButton;
		
		public function MenuState() {
			
		}
		
		override public function create():void {
			FlxG.mouse.show();
			
			m_background = new FlxSprite();
			m_background.loadGraphic2(SpriteResources.ImgMenuBackground, false, false, 1280, 720, true);
			add(m_background);
			
			m_playbutton = new PlayButton((1280 / 3 - 190 / 2), ((720 / 5) * 4 - 94 / 2), null, function() { FlxG.switchState(new PlayState()); } );
			add(m_playbutton);
			
			m_creditbutton = new CreditButton(((1280 / 3) * 2 - 194 / 2), ((720 / 5) * 4 - 95 / 2), null, function() { FlxG.switchState(new CreditState()); });
			add(m_creditbutton);
		}
		
		override public function update():void {
			super.update();
		}
		
	}

}