package Game.Objects
{
	import flash.display.MovieClip;
	import org.flixel.*;
	import flash.geom.Point;
	
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
		public function Tree(origin:Point,planet:Planet) 
		{
			super(0, planet.radius(), planet);
			m_roots = new TreeRoot(origin, 255, 255, 255, 0, 255, 0, planet.radius()-2);
			//charger l'image de l'arbre
			loadGraphic(SpriteResources.ImgTree, true, false, 120, 130);
			//ajout de la taille de l'image pour coller au sol de la planete
			m_distance += height;
			//créerle tableau de frames pour les feuilles
			var growTab:Array= new Array();
			for (var i:int = 7; i < frames; i++) 
			{
				growTab.push(i);
			}
			
			addAnimation("GrowTrunk", [0, 1, 2, 3, 4, 5, 6], 2.4, false);
			addAnimation("GrowLeaves", growTab, 10, false);
			play("GrowTrunk");
			
			m_state = "growup";
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
				if (animIsFinished())
					//jouer l'anim des feuilles
					play("GrowLeaves");
			}
		}
		
		override public function update():void
		{
			super.update();			
			m_roots.update();

			switch(m_state) {
				case("growup"):
					growup();
					break;
				case("feed"):
					break;
				case("die"):
					break;
				default:
					break;
			}
		}
		
		protected function growup():void {
			//gérer l'animation
			animate();
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