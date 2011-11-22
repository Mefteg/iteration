package Game.States 
{
	import Game.Buttons.CreditButton;
	import Game.Buttons.PlayButton;
	import Game.Buttons.TutoButton;
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
		protected var m_tutobutton:TutoButton;
		
		
		public function MenuState() 
		{
			
		}
		
		override public function create():void {
			FlxG.mouse.show();
				
			m_background = new FlxSprite();
			m_background.loadGraphic2(SpriteResources.ImgMenuBackground, false, false, 1280, 720, true);
			add(m_background);
			
			m_tutobutton = new TutoButton((1280 / 4 - 186 / 2), ((720 / 5) * 4 - 91 / 2), null, function() { FlxG.switchState(new TutoState()); });
			add(m_tutobutton);
			
			m_playbutton = new PlayButton((1280 / 2 - 232 / 2), ((720 / 6) * 5 - 114 / 2), null, function() { FlxG.switchState(new PlayState()); } );
			add(m_playbutton);
			
			m_creditbutton = new CreditButton(((1280 / 4) * 3 - 194 / 2), ((720 / 5) * 4 - 95 / 2), null, function() { FlxG.switchState(new CreditState()); });
			add(m_creditbutton);
		}
		
		override public function update():void {
			super.update();
		}
		
	}

}