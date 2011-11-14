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
		private var m_playState:PlayState
		
		// private var treeSprite:FlxSprite;

		public function TreeGenerator(planet:Planet,playState:PlayState)
		{
			m_trees = new Array(GameParams.nbTrees);
			m_treeTimer = new Array(GameParams.nbTrees);
			
			m_playState = playState;
			
			super(0, 0, planet);
		}
		
		override public function draw():void 
		{
			for ( var i:uint = 0 ; i < GameParams.nbTrees ; i++ )
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
			
			for ( var i:uint = 0 ; i < GameParams.nbTrees ; i++ )
			{
				if ( m_treeTimer[i] != null )
				{
					if ( m_treeTimer[i].finished )
					{
						m_trees[i] = new Tree(m_planet.center(), m_planet , m_trees);
						m_playState.add(m_trees[i]);
						m_treeTimer[i].destroy;
						m_treeTimer[i] = null;
					}
				}
				
				if ( m_trees[i] != null )
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
			var size:Number = m_trees.length;
			for ( var i:uint = 0 ; i < size ; i++ )
			{
				if ( m_trees[i] != null )
				{
					m_playState.remove(m_trees[i]);
					m_trees[i].destroy;
				}
			}
		}
		
		public function regenerate():void
		{
			this.clear();
			
			for ( var i:uint = 0 ; i < GameParams.nbTrees ; i++ )
			{
				m_treeTimer[i] = new FlxTimer();
				m_treeTimer[i].start(FlxG.random() * 20);
			}
			
		}
	}
	
}