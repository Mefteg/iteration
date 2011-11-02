package Graphics 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author LittleWhite
	 */
	public class TreeRoot extends FlxGroup 
	{
		private var m_origin:FlxPoint;
		private var m_baseColour:uint;
		private var m_endColour:uint;
		private var m_length;
		
		private var m_actualPoint:FlxPoint;
		
		public function TreeRoot(origine:FlxPoint, baseColour:uint, endColour:uint, length:int) 
		{
			super();
			
			m_origin = origin;
			m_baseColour = m_actualPoint = baseColour;
			m_endColour = endColour;
			m_length = length;
		}
		
		public function draw():void
		{
			
		}
		
		public function update():void
		{
			super.update();
			
			if ( m_actualPoint
			str.makeGraphic(2, 2, 0x00ffffff | transp);
			str.velocity.x = cosang * vel;
			str.velocity.y = sinang * vel;
			add(str);
		}
	}

}