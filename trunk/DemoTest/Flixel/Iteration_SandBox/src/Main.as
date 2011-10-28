package 
{
	/**
	 * @author Alexandre Laurent
	 */
	import org.flixel.FlxGame; 
	import States.HelloWorldState;
	import States.DemoParticleState;
	import States.DemoMusicState;

	public class Main extends FlxGame 
	{
		public function Main()
		{
			super(312, 152, DemoMusicState, 1);		
		}
	}
}