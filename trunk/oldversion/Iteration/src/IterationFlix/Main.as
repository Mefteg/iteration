package IterationFlix 
{
	import flixel.FlxGame;
	[SWF(width="640", height="480", backgroundColor="#000000")] //Set the size and color of the Flash file
	/**
	 * ...
	 * @author Moi
	 */
	public class Main extends FlxGame
	{
		
		public function Main() 
		{
				super(320, 240, PlayState,2);
		}
		
	}

}