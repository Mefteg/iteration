package Utils 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Alexandre Laurent
	 */
	public class MathUtils 
	{
		static public var pi:Number = 3.14159265;
		static public var pi180:Number = pi / 180.0;
		
		public static function sign(n:Number):Number {
			if (n >= 0)
				return 1;
			else
				return -1;
		}
		public static function interpolate(v1:Number, v2:Number, t:Number):Number
		{
			return v1 * (1 - t) + v2 * t;
		}
		
		public static function degToRan(angle:Number):Number
		{
            return angle * pi180;
		}
		
		public static function det(v1:Point, v2:Point):Number {
			return v1.x * v2.y - v2.x * v1.y;
		}
		
		public static function getArrayofNumbers(init:int, n:int ):Array {
			var tab:Array = new Array();
			if(init<n){
				for (var i:int = init; i <= n ; i++) 
				{
					tab.push(i);
				}
			}else {
				for (var i:int = init; i >= n ; i--) 
				{
					tab.push(i);
				}
			}
			
			return tab;
		}
		
		public static function calculateDistance(angle1:Number, angle2:Number):Number
		{
			if ( angle1 > 360 || angle1 < 0 )
			{
				trace ("You are using this function wrongly");
			}
			else if ( angle2 > 360 || angle2 < 0 )
			{
				trace ("You are using this function wrongly");
			}
			
			var d1:Number = Math.abs(angle1 - angle2);
			var d2:Number;
			if ( angle1 < 180 && angle2 > 180 )
			{
				d2 = 360 - angle2 + angle1;
			}
			else if ( angle1 > 180 && angle2 < 180 )
			{
				d2 = 360 - angle1 + angle2;
			}
			else
			{
				return d1;
			}
			if ( d1 < d2 )
			{
				return d1;
			}
			else
			{
				return d2;
			}
		}
		
	}

}