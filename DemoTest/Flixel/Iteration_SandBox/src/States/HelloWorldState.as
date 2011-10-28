package States 
{
	/**
	 * ...
	 * @author Alexandre Laurent
	 */

	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class HelloWorldState extends FlxState 
	{
		override public function create():void
		{
			add(new FlxText(0, 0, 100, "Hello, World!"));
		}
	}
}