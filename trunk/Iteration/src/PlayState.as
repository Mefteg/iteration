package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class PlayState extends FlxState
	{
		
		override public function create():void {
			FlxG.bgColor = 0xffaaaaaa;
			add(new FlxText(0,0,100,"Hello World!"));
		}
		
		override public function update():void {
			
		}
	}

}