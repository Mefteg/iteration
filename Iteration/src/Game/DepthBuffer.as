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
		
			var emitter:FlxEmitter = new FlxEmitter(100,100); //x and y of the emitter
		
		public function DepthBuffer()
		{
			m_backGround = new FlxGroup();
			m_blobbies = new FlxGroup();
			m_trees = new FlxGroup();
			m_fruits = new FlxGroup();
			m_foreGround = new FlxGroup();
			
			add(m_backGround);
			add(m_blobbies);
			add(m_trees);
			add(m_fruits);
			add(m_foreGround);
		}
		
		public function addBackground(element:FlxBasic):void
		{
			m_backGround.add(element);
		}
		
		public function addBlobbies(element:FlxBasic):void
		{
			m_blobbies.add(element);
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