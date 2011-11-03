package Game.Objects
{
	import flash.display.MovieClip;
	import org.flixel.*;
	import flash.geom.Point;
	
	/**
	 * Tree implementation
	 * @author Alexandre Laurent
	 */
	public class Tree extends Element
	{
		[Embed(source = "../../../bin/img/tree.png")] private var ImgTree:Class;
		
		private var m_roots:TreeRoot;
		
		/**
		 * @param	origin	The point where the root starts
		 * @param	planet where the tree will grow
		 */
		public function Tree(origin:Point,planet:Planet) 
		{
			super(0, planet.radius()*1.5, planet);
			m_roots = new TreeRoot(origin, 255, 255, 255, 0, 255, 0, planet.radius());
			//charger l'image de l'arbre
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
		public function animate() : void {
			//Si anim du tronc en cours
			if (this._curAnim.name == "GrowTrunk") {
				//et si l'anim est finie
				if (_curIndex == _curAnim.frames.length - 1)
					//jouer l'anim des feuilles
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
				// Place the tree
				m_pos = m_roots.endAngle();
				this.place();
				this.rotateToPlanet();				
			}
		}
		
		override public function destroy():void {
			m_planet.removeResources(300);
			super.destroy();
		}
		
	}

}