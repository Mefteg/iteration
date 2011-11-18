package Game.Objects
{
	import flash.display.MovieClip;
	import Game.States.PlayState;
	import org.flixel.*;
	import flash.geom.Point;
	import Utils.MathUtils;
	import Globals.GameParams;
	
	import Resources.SpriteResources;
	
	/**
	 * Generator of tree implementation
	 * @author Alexandre Laurent
	 */
	public class TreeGenerator extends Element
	{	
		private var m_trees:Array;
		private var m_treeTimer:Array;
		
		// private var treeSprite:FlxSprite;

		public function TreeGenerator(planet:Planet)
		{
			super(0, 0, planet);
			
			m_trees = new Array(GameParams.map.m_treeNumber);
			m_treeTimer = new Array(GameParams.map.m_treeNumber);
			
			for ( var i:uint = 0 ; i < GameParams.map.m_treeNumber ; i++ )
			{
				m_trees[i] = new Tree(m_planet.center(), m_planet , m_trees);
				m_trees[i].visible = false;
			}
		}
		
		override public function draw():void 
		{
			for ( var i:uint = 0 ; i < GameParams.map.m_treeNumber ; i++ )
			{
				if ( m_trees[i] != null )
				{
					m_trees[i].draw();
				}
			}
		}
		
		override public function update():void 
		{
			super.update();
			if (m_trees.length == 0) return;
			
			for ( var i:uint = 0 ; i < GameParams.map.m_treeNumber ; i++ )
			{
				if ( m_treeTimer[i] != null )
				{
					if ( m_treeTimer[i].finished )
					{
						m_trees[i].visible = true;
						// m_playState.add(m_trees[i]);
						m_treeTimer[i].destroy;
						m_treeTimer[i] = null;
					}
				}
				
				if ( m_trees[i] != null && m_trees[i].visible == true )
				{
					m_trees[i].update();
				}
			}
		}
		
		public function trees():Array
		{
			return m_trees;
		}
		
		public function clear():void
		{
			// Try to delete and remove elements
			var size:Number = m_trees.length;
			for ( var i:uint = 0 ; i < size ; i++ )
			{
				if ( m_trees[i] != null )
				{
					m_trees[i].visible = false;// destroy;
				}
			}
		}
		
		public function regenerate():void
		{
			this.clear();
			
			// Restart the process of generation of the trees
			for ( var i:uint = 0 ; i < GameParams.map.m_treeNumber ; i++ )
			{
				m_treeTimer[i] = new FlxTimer();
				m_treeTimer[i].start(GameParams.map.m_treeBirthTime + FlxG.random() * GameParams.map.m_treeBirthRandom);
				
				m_trees[i] = new Tree(m_planet.center(), m_planet , m_trees);
				m_trees[i].visible = false;
			}			
		}
	}
	
}