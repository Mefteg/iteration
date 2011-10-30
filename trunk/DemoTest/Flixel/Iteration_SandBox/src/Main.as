package 
{
	/**
	 * @author Alexandre Laurent
	 */
	import org.flixel.FlxGame; 
	import org.flixel.FlxG; 
	
	import States.HelloWorldState;
	import States.DemoParticleState;
	import States.DemoMusicState;
	import States.DemoTreeState;

	public class Main extends FlxGame 
	{
		public function Main()
		{
			var d:Date = new Date();
			FlxG.globalSeed = d.getTime();
			super(312, 152, DemoTreeState, 1);		
		}
	}
}