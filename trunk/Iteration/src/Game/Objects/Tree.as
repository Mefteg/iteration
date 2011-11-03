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
			loadGraphic(ImgTree, true, false, 120, 130);
			//créerle tableau de frames pour les feuilles
			var growTab:Array= new Array();
			for (var i:int = 7; i < frames; i++) 
			{
				growTab.push(i);
			}
			
			addAnimation("GrowTrunk", [0, 1, 2, 3, 4, 5, 6], 2.4, false);
			addAnimation("GrowLeaves", growTab, 10, false);
			play("GrowTrunk");
		}
		
		override public function draw():void 
		{
			m_roots.draw();
			if ( !m_roots.isGrowing() )
			{
				super.draw();
			}
		}
		
		//gère les enchainements d'animations
		public function animate() {
			if (this._curAnim.name == "GrowTrunk") {
				if (_curIndex ==_curAnim.frames.length - 1)
					play("GrowLeaves");
			}
		}
		
		override public function update():void
		{
			super.update();
			//gérer l'animation
			animate();
			
			
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