package Utils 
{
	/**
	 * ...
	 * @author Alexandre Laurent
	 */
	public class MathUtils 
	{
		static public var pi:Number = 3.14159265;
		static public var pi180:Number = pi / 180.0;
		
		public static function interpolate(v1:uint, v2:uint, t:Number):uint
		{
			return v1 * (1 - t) + v2 * t;
		}
		
		public static function degToRan(angle:Number):Number
		{
            return angle * pi180;
		}
		
	}

}