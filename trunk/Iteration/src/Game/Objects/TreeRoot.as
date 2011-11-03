package Game.Objects
{
	import flash.geom.Point;
	
	import Utils.MathUtils;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author LittleWhite
	 */
	public class TreeRoot extends FlxGroup 
	{
		// Center of the planet (where to start)
		private var m_origin:Point;
		
		// Colour at the start of the root
		private var m_baseColourR:uint;
		private var m_baseColourG:uint;
		private var m_baseColourB:uint;
		
		// Colour at the end of the root (near the tree)
		private var m_endColourR:uint;
		private var m_endColourG:uint;
		private var m_endColourB:uint;
		
		// Length of the root
		private var m_length:uint;
		private var m_lengthMax:uint; // Length where the root will stop to grow
		
		// Angle (to position the point in the planet)
		private var m_angle:int;
		
		// Actual point of the root's growth
		private var m_actualPoint:Point;
		
		// Time for the direction update (curve growth)
		private var lastUpdate:uint;
		private var lastRandUpdate:uint;
		private var direction:Boolean;
		
		// true if the root is still growing
		private var m_grow:Boolean;
		
		/**
		 * 
		 * @param	origin	Normally, the center of the planet
		 * @param	baseColourR	Red component for the start of the root
		 * @param	baseColourG Green component for the start of the root
		 * @param	baseColourB Blue component for the start of the root
		 * @param	endColourR Red component for the end of the root
		 * @param	endColourG Green component for the end of the root
		 * @param	endColourB Blue component for the end of the root
		 * @param	length length of the root
		 */
		public function TreeRoot(origin:Point, baseColourR:uint, baseColourG:uint, baseColourB:uint, 
											   endColourR:uint,endColourG:uint,endColourB:uint, length:int) 
		{
			super();
			
			m_origin = new Point(origin.x,origin.y);
			m_actualPoint = new Point(origin.x,origin.y);
			
			m_baseColourR = baseColourR;
			m_baseColourG = baseColourG;
			m_baseColourB = baseColourB;
			m_endColourR = endColourR;
			m_endColourG = endColourG;
			m_endColourB = endColourB;
			
			m_length = 0;
			m_lengthMax = length;
			
			m_angle = FlxG.random() * 180 - 360;
			
			lastUpdate = 0;
			lastRandUpdate = 0;
			direction = true;
			
			m_grow = true;
		}
		
		override public function update():void
		{
			if ( m_grow )
			{
				// super.update();
				var distance:int = Point.distance(m_actualPoint, m_origin);
				var interpolation:Number = (distance * distance) / (m_lengthMax * m_lengthMax);
				if ( distance * distance < m_lengthMax * m_lengthMax )
				{
					var str:FlxSprite = new FlxSprite();
					str = str.makeGraphic(1, 1, FlxU.makeColor(MathUtils.interpolate(m_baseColourR, m_endColourR,interpolation),
												MathUtils.interpolate(m_baseColourG, m_endColourG,interpolation),
												MathUtils.interpolate(m_baseColourB, m_endColourB, interpolation)));
					
					if ( lastUpdate - lastRandUpdate > FlxG.random() * 30 )
					{
						if ( FlxG.random() < 0.5 )
						{
							direction = true;
						}
						else
						{
							direction = false;
						}
						
						lastRandUpdate = lastUpdate;
					}
					
					if ( direction )
					{
						m_angle ++;
						if ( m_angle > 180 )
						{
							m_angle -= 360;
						}
					}
					else 
					{
						m_angle --;
						if ( m_angle < 180 )
						{
							m_angle += 360;
						}
					}
					
					m_actualPoint.x = m_origin.x + Math.cos(MathUtils.degToRan(m_angle)) * m_length;
					m_actualPoint.y = m_origin.y - Math.sin(MathUtils.degToRan(m_angle)) * m_length;
					
					m_length++;
												
					str.x = m_actualPoint.x;
					str.y = m_actualPoint.y;
					
					add(str);
					
					lastUpdate++;
				}
				else
				{
					m_grow = false;
				}
			}
		}
		
		public function isGrowing():Boolean
		{
			return m_grow;
		}
		
		public function startPoint():Point
		{
			return m_origin;
		}
		
		public function endPoint():Point
		{
			return m_actualPoint;
		}
		
		public function endAngle():Number
		{
			return m_angle;
		}
	}
}