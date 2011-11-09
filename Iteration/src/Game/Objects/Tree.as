package Game.Objects
{
	import flash.display.MovieClip;
	import org.flixel.*;
	import flash.geom.Point;
	import Utils.MathUtils;
	
	import Resources.SpriteResources;
	
	/**
	 * Tree implementation
	 * @author Alexandre Laurent
	 */
	public class Tree extends Element
	{		
		private var m_roots:TreeRoot;
		
		/**
		 * @param	origin	The point where the root starts
		 * @param	planet where the tree will grow
		 */
		public function Tree(origin:Point,planet:Planet, trees:Array) 
		{
			super(0, planet.radius(), planet);
			
			// Loop to position randomly a tree enough distant to others
			var size:int = trees.length;
			if ( size > 0 )
			{
				var randomPos:Number = FlxG.random() * 360;
				
				var t:Tree; // nearest tree (the closer one)
				var distMin:Number = 1000; // distance of the nearest tree
				var dist:Number = 0;
				
				while ( dist < 25 )
				{
					randomPos = FlxG.random() * 360;
					distMin = 1000;
					
					for (var i:int = 0; i < size ; i++) 
					{
						//pour ce blobby
						t = trees[i];
							
						dist = MathUtils.calculateDistance(randomPos, t.m_pos);
						if ( dist < distMin )
						{
							distMin = dist;
						}		
					}
					
					dist = distMin;
				}
				this.m_pos = randomPos;
				m_distance += 155;
				loadGraphic(SpriteResources.ImgTree1, true, false, 405, 376);
				addAnimation("growTrunk", MathUtils.getArrayofNumbers(0,29), 6, false);
			}
			
			// m_roots = new TreeRoot(origin, 255, 255, 255, 0, 255, 0, planet.radius()-2);
			m_state = "growup";
		}
				
		override public function draw():void 
		{
			if (!visible) return;
			//m_roots.draw();
			/*if ( !m_roots.isGrowing() )
			{ */
				super.draw();
			//}
		}
		
		override public function update():void
		{
			if (!visible) return;
			super.update();		

			switch(m_state) {
				case("growup"):
					growup();
					break;
				case("growTrunk"):
					growTrunk();
					break;
				case("growTree"):
					break;
				case("feed"):
					break;
				case("die"):
					die();
					return;
					break;
				default:
					break;
			}
			
			// Place the tree
			this.place();
			this.rotateToPlanet();
		}
		
		private function growTrunk():void 
		{
			if (finished)
				setState("growTree");
		}
		
		private function growTree():void {
			
		}
		
		protected function growup():void 
		{
			setState("growTrunk");
		}
		
		override public function destroy():void 
		{
			m_planet.removeResources(300);
			super.destroy();
		}
		
		override public function setState(state:String):void {
			m_state = state; 
			play(m_state);
		}
		
		public function die():void 
		{
			this.destroy();
		}
	}

}