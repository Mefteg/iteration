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
			
			// Random angle at start (between -180 - 180)
			m_angle = FlxG.random() * 360 - 180;
			
			lastUpdate = 0;
			lastRandUpdate = 0;
			direction = true;
			
			m_grow = true;
		}
		
		override public function update():void
		{
			if ( m_grow )
			{
				// Calculates the distance from here to the center
				var distance:int = Point.distance(m_actualPoint, m_origin);
				
				// Calculates a interpolation factor for the colours grade
				var interpolation:Number = (distance * distance) / (m_lengthMax * m_lengthMax);
				
				// If still not reached the end
				if ( distance * distance < m_lengthMax * m_lengthMax )
				{
					// New little sprite (the root is a set of sprites)
					var str:FlxSprite = new FlxSprite();
					
					// Make the sprite colour / square
					str = str.makeGraphic(1, 1, FlxU.makeColor(MathUtils.interpolate(m_baseColourR, m_endColourR,interpolation),
												MathUtils.interpolate(m_baseColourG, m_endColourG,interpolation),
												MathUtils.interpolate(m_baseColourB, m_endColourB, interpolation)));
					
					// After some times, we change the direction
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
					
					// Update of the root position
					if ( direction )
					{
						m_angle ++;
						if ( m_angle > 180 ) // modulo of the angle
						{
							m_angle -= 360;
						}
					}
					else 
					{
						m_angle --;
						if ( m_angle < 180 ) // modulo of the angle
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
		
		/**
		 * Returns if the root still grow
		 * @return true if the root is growing
		 */
		public function isGrowing():Boolean
		{
			return m_grow;
		}
		
		/**
		 * Returns the point of the start of the root
		 * @return the start
		 */
		public function startPoint():Point
		{
			return m_origin;
		}
		
		/**
		 * Returns the end of the root (where it reached the surface)
		 * @return the end
		 */
		public function endPoint():Point
		{
			return m_actualPoint;
		}
		
		/**
		 * Returns the final angle that the root used
		 * @return the angle
		 */
		public function endAngle():Number
		{
			return m_angle;
		}
	}
}