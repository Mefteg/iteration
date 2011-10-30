package Utils 
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author LittleWhite
	 */
	public class VectorUtils 
	{
		public static function length(p1:FlxPoint, p2:FlxPoint):int
		{
			var point:FlxPoint = new FlxPoint(p2.x-p1.x, p2.y-p1.y);
			return (point.x * point.x + point.y * point.y);
		}
		
	}

}