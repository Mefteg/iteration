package  
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
		private var m_origin:Point;
		private var m_baseColourR:uint;
		private var m_baseColourG:uint;
		private var m_baseColourB:uint;
		private var m_endColourR:uint;
		private var m_endColourG:uint;
		private var m_endColourB:uint;
		
		private var m_length:uint;
		private var m_lengthMax:uint;
		
		private var m_angle:int;
		
		private var m_actualPoint:Point;
		
		private var lastUpdate:uint;
		private var lastRandUpdate:uint;
		private var direction:Boolean;
		
		private var m_grow:Boolean;
		
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