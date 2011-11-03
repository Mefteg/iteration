package Game.Objects
{
	import flash.display.MovieClip;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Alexandre Laurent
	 */
	public class Tree extends Element
	{
		[Embed(source = "../../../bin/img/tree.png")] private var ImgTree:Class;
		
		private var m_roots:TreeRoot;
		
		public function Tree(origin:Point, length:Number,planet:Planet) 
		{
			super(0, length*1.5, planet);
			m_roots = new TreeRoot(origin, 255, 255, 255, 0, 255, 0, length);
			loadGraphic(ImgTree,true,false,100,100);
			addAnimation("Grow", [0, 1, 2, 3, 4], 1.5, false);
			play("Grow");
		}
		
		override public function draw():void 
		{
			if ( !m_roots.isGrowing() )
			{
				super.draw();
			}
			m_roots.draw();
		}
		
		override public function update():void
		{
			super.update();
			
			
			m_roots.update();
			if ( !m_roots.isGrowing() )
			{
				m_pos = m_roots.endAngle();
				this.place();
				this.rotateToPlanet();				
			}
		}
		
	}

}