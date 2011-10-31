package States 
{
	import Graphics.TreeRoot;
	import org.flixel.FlxState;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Alexandre Laurent
	 */
	public class DemoTreeState extends FlxState 
	{
		private var tree:TreeRoot;
		
		public function DemoTreeState() 
		{
			tree = new TreeRoot(new FlxPoint(FlxG.width / 2, FlxG.height / 2), 255,0,0,0,255,0, 80);
			add(tree);
		}
		
		override public function update():void 
		{
			super.update();
			
			tree.update();
		}
		
	}

}