package Game.Objects 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Moi
	 */
	public class Scroll extends FlxGroup
	{
		protected var m_state:String;
		protected var m_scrollTop:FlxSprite;
		protected var m_scrollBottom:FlxSprite;
		
		public function Scroll() 
		{
			//créer le bas du parchemin
			m_scrollBottom = new FlxSprite(0, 0);
			m_scrollBottom.makeGraphic(300, 300);
			add(m_scrollBottom);
			m_scrollBottom.scrollFactor = new FlxPoint(0, 0);
			//créer le haut du parchemin
			m_scrollTop = new FlxSprite(0, 0);
			add(m_scrollTop);
			m_scrollTop.scrollFactor = new FlxPoint(0, 0);
		}
		
		override public function update():void {
			super.update();
		}
	}

}