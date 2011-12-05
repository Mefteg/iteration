package Game 
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author LittleWhite
	 */
	public class DepthBuffer extends FlxGroup
	{
		private var m_backGround:FlxGroup;
		private var m_blobbies:FlxGroup;
		private var m_trees:FlxGroup;
		private var m_fruits:FlxGroup;
		private var m_foreGround:FlxGroup;
		private var m_meteors:FlxGroup;
		
		public var m_scroll:FlxGroup;
			// var emitter:FlxEmitter = new FlxEmitter(100,100); //x and y of the emitter
		
		public function DepthBuffer()
		{
			m_scroll = new FlxGroup();
			m_backGround = new FlxGroup();
			m_blobbies = new FlxGroup();
			m_trees = new FlxGroup();
			m_fruits = new FlxGroup();
			m_foreGround = new FlxGroup();
			m_meteors = new FlxGroup();
			
			add(m_backGround);
			add(m_blobbies);
			add(m_trees);
			add(m_fruits);
			add(m_meteors);
			add(m_foreGround);
			add(m_scroll);
		}
		
		public function addBackground(element:FlxBasic):void
		{
			m_backGround.add(element);
		}
		
		public function addBlobbies(element:FlxBasic):void
		{
			m_blobbies.add(element);
		}
		
		public function addScroll(element:FlxBasic):void
		{
			m_scroll.add(element);
		}
		public function removeScroll(element:FlxBasic):void {
			m_scroll.remove(element);
		}
		
		public function addMeteor(element:FlxBasic):void
		{
			m_meteors.add(element);
		}
		public function removeMeteor(element:FlxBasic):void {
			m_meteors.remove(element);
		}
		public function addTrees(element:FlxBasic):void
		{
			m_trees.add(element);
		}
		
		public function addFruit(element:FlxBasic):void
		{
			m_fruits.add(element);
		}
		
		public function addForeground(element:FlxBasic):void
		{
			m_foreGround.add(element);
		}
		
		public function removeBackground(element:FlxBasic):void
		{
			m_backGround.remove(element);
		}
		
		public function removeBlobbies(element:FlxBasic):void
		{
			m_blobbies.remove(element);
		}
		
		public function removeTrees(element:FlxBasic):void
		{
			m_trees.remove(element);
		}
		
		public function removeFruit(element:FlxBasic):void
		{
			m_fruits.remove(element);
		}
		
		public function removeForeground(element:FlxBasic):void
		{
			m_foreGround.remove(element);
		}
	}

}