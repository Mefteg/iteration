package Game.Objects
{
	import flash.geom.Point;
	import org.flixel.*;
	
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author ...
	 */
	public class Meteor extends Element
	{
		private var m_roamingDistance:Number;
		
		protected var m_fall:Boolean = false;
		
		private var m_hasExploded:Boolean = false;
		
		public function Meteor(sprite:Class,roamingDistance:Number,planet:Planet) 
		{
			super(0, roamingDistance * 2, planet);
			m_roamingDistance = roamingDistance;
			//Créer l'image
			loadGraphic(sprite, false, false, 67, 67);
			m_speed = 0.1;
			//dimensionner le météore par rapport a la planete
			this.scale.x = (0.1 * planet.getHeight())/width;
			this.scale.y = (0.1 * planet.getWidth()) / height;
			
			m_state = "Incoming";
		}
		
		override public function update():void 
		{
			//trace(m_state);
			switch (m_state)
			{
				case "Incoming":
					m_distance-= 4;
					if ( m_distance <= m_roamingDistance )
					{
						m_state = "Roaming";
					}
					break;
				case "Roaming":
					//si l'utilisateur clique sur le météore
					if (onClick()) 
					{
						//on fait tomber le météore
						m_state = "Crashing";
						m_speed = m_speed * 1.2;
					}
					break;
				case "Crashing":
					//réduire la distance entre le météore et la planète
					m_distance -= (m_speed * (1 / m_distance * 250 ))*150;
					
					//si le météore atteint la planete :: il explose
					if (m_distance <= m_planet.radius())
						m_hasExploded = true;
					break;
			}
			
			//faire tourner le météore en orbite
			m_pos += m_speed;
			
			//placer le météore
			place();
			
			//le faire tourner sur lui meme
			angle--;
			
			super.update();
		}
		
		public function checkBlobbiesCollision():void {
			var blobbies:Array = m_planet.getBlobbies();
			var size:int = blobbies.length;
			var blob:Blobby;
			for (var i:int = 0; i < size; i++) 
			{
				blob = blobbies[i];
				if (checkBlobbyCollision(blob))
					m_planet.removeBlobby(blob);
			}
		}
		
		private function checkBlobbyCollision(blobby:Blobby):Boolean {
			if (!blobby) return false;
			if ( Math.abs(((this.m_pos + 180) % 360) - ((blobby.getPos() + 180) % 360)) < 10 )
			{
				return true;
			}
			return false;
		}
		
		public function checkTreesCollision():void {
			var trees:Array = m_planet.getTrees();
			var size:int = trees.length;
			var tree:Tree;
			for (var i:int = 0; i < size; i++) 
			{
				tree = trees[i];
				if (checkTreeCollision(tree))
					m_planet.removeTree(tree);
			}
		}
		
		private function checkTreeCollision(tree:Tree):Boolean {
			if (!tree) return false;
			if ( Math.abs(((this.m_pos + 180) % 360) - ((tree.getPos() + 180) % 360)) < 10 )
			{
				return true;
			}
			return false;
		}
		
		
		override public function destroy():void 
		{
			super.destroy();
		}
		
		public function hasExploded():Boolean
		{
			return m_hasExploded;
		}
		
	}

}