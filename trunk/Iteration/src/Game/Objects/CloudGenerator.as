package Game.Objects 
{
	import Globals.GameParams;
	import org.flixel.FlxTimer;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author LittleWhite
	 */
	public class CloudGenerator extends Element
	{
		private var m_clouds:Array;
		private var m_cloudTimer:Array;
		
		public function CloudGenerator(planet:Planet) 
		{
			super(0, 0, planet);
			
			m_clouds = new Array(GameParams.map.cloudsNumber);
			m_cloudTimer = new Array(GameParams.map.cloudsNumber);
			
			for ( var i:uint = 0 ; i < GameParams.map.cloudsNumber ; i++ )
			{
				m_clouds[i] = new Cloud(m_planet);
				m_clouds[i].visible = false;
			}
		}
		
		override public function draw():void 
		{
			for ( var i:uint = 0 ; i < GameParams.map.cloudsNumber ; i++ )
			{
				if ( m_clouds[i] != null )
				{
					m_clouds[i].draw();
				}
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			for ( var i:uint = 0 ; i < GameParams.map.cloudsNumber ; i++ )
			{
				if ( m_cloudTimer[i] != null )
				{
					if ( m_cloudTimer[i].finished )
					{
						m_clouds[i].visible = true;
						// m_playState.add(m_trees[i]);
						m_cloudTimer[i].destroy;
						m_cloudTimer[i] = null;
					}
				}
				
				if ( m_clouds[i] != null && m_clouds[i].visible == true )
				{
					m_clouds[i].update();
				}
			}
		}
		
		public function clouds():Array
		{
			return m_clouds;
		}
		
		public function clear():void
		{
			// Try to delete and remove elements
			var size:Number = m_clouds.length;
			for ( var i:uint = 0 ; i < size ; i++ )
			{
				if ( m_clouds[i] != null )
				{
					m_clouds[i].visible = false;// destroy;
				}
			}
		}
		
		public function regenerate():void
		{
			this.clear();
			
			// Restart the process of generation of the trees
			for ( var i:uint = 0 ; i < GameParams.map.cloudsNumber ; i++ )
			{
				m_cloudTimer[i] = new FlxTimer();
				m_cloudTimer[i].start(GameParams.map.m_cloudsBirthTime + FlxG.random() * GameParams.map.m_cloudsBirthRandom);
			}
			
		}
		
	}

}