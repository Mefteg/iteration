package Game.Objects
{
	import flash.display.MovieClip;
	import Game.NewSprite;
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
		private var m_spriteTrunk:NewSprite;
		private var m_spriteTree:NewSprite;
		
		private var m_spriteCurrent:NewSprite;
		/**
		 * @param	origin	The point where the root starts
		 * @param	planet where the tree will grow
		 */
		public function Tree(origin:Point,planet:Planet) 
		{
			super(0, planet.radius(), planet);
			m_roots = new TreeRoot(origin, 255, 255, 255, 0, 255, 0, planet.radius()-2);
			m_state = "growup";
		}
		
		public function setAnimations(trunk:NewSprite,tree:NewSprite):void {
			m_spriteTrunk = trunk;
			m_spriteTree = tree;
			m_spriteCurrent = m_spriteTrunk;
			//tailles de l'arbre
			this.width = m_spriteCurrent.width; this.height = m_spriteCurrent.height;
			m_pos = Math.random()*360;
			m_distance += 155;
		}
		
		override public function draw():void 
		{
			//m_roots.draw();
			if ( !m_roots.isGrowing() )
			{ 
				//mettre a jour les propriétés du sprite courant
				m_spriteCurrent.x = x;
				m_spriteCurrent.y = y;
				m_spriteCurrent.angle = angle;
				m_spriteCurrent.scale = scale;
				m_spriteCurrent.color = color;
				//le dessiner
				m_spriteCurrent.draw();
			}
		}
		
		override public function update():void
		{
			super.update();			
			m_roots.update();
			m_spriteCurrent.update();

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
			if (m_spriteCurrent.animIsFinished())
				setState("growTree");
		}
		
		private function growTree():void {
			
		}
		
		protected function growup():void {
			
			if ( !m_roots.isGrowing() )
			{	
				setState("growTrunk");
			}
			
		}
		
		override public function destroy():void {
			m_planet.removeResources(300);
			super.destroy();
		}
		
		override public function setState(state:String):void {
			m_state = state;
			
			switch(m_state) {
				case("growup"):
					break;
				case("growTrunk"):
					m_spriteCurrent = m_spriteTrunk;
					break;
				case("growTree"):
					m_spriteCurrent = m_spriteTree;
					m_spriteTrunk = null;
					break;
				case("die"):
					break;
				default:
					break;
			}
			
			m_spriteCurrent.play(m_state);
		}
	}

}