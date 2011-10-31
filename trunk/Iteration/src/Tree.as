package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Alexandre Laurent
	 */
	public class Tree extends FlxSprite
	{
		[Embed(source = "../bin/img/tree.png")] private var ImgTree:Class;
		
		private var m_roots:TreeRoot;
		
		public function Tree(origin:Point, length:Number) 
		{
			m_roots = new TreeRoot(origin, 0, 128, 0, 0, 255, 0, length);
			loadRotatedGraphic(ImgTree, 360);
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
				this.x = m_roots.endPoint().x - this.width / 2;
				this.y = m_roots.endPoint().y - this.height;
				this.angle = -m_roots.endAngle() + 90;
				
				this.x += this.width / 2;
				this.y += this.height / 2;
			}
		}
		
	}

}