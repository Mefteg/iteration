package Game.Objects
{
	import flash.geom.Point;
	import flash.text.engine.ElementFormat;
	import org.flixel.*;
	import Utils.MathUtils;
	
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author ...
	 */
	public class Meteor extends Element
	{
		//sprite d'explosion
		protected var m_explosion:Element;
		
		private var m_roamingDistance:Number;
		
		protected var m_fall:Boolean = false;
		protected var m_fallSpeed:Number = 1.0;
		
		private var m_crashTime:Number = 0.0;
		
		private var m_hasExploded:Boolean = false;
		private var m_giveLife:Boolean ;
		
		public function Meteor(sprite:Class,roamingDistance:Number,planet:Planet,glife:Boolean) 
		{
			super(0, roamingDistance * 2, planet);
			m_roamingDistance = roamingDistance;
			//Créer l'image
			loadGraphic(sprite, false, false, 67, 67);
			m_speed = 0.1;
			//dimensionner le météore par rapport a la planete
			this.scale.x = (0.1 * planet.getHeight())/width;
			this.scale.y = (0.1 * planet.getWidth()) / height;
			//créer l'explosion
			m_explosion = new Element(m_pos, planet.radius()+270, planet);
			m_explosion.loadGraphic(SpriteResources.ImgExplosionMeteor, true, false, 662, 709);
			m_explosion.addAnimation("explode", MathUtils.getArrayofNumbers(0, 13), 6, false);
			m_explosion.visible = false;
			m_giveLife = glife;
			
			m_state = "Incoming";
		}
		
		override public function update():void 
		{
			//trace(m_state);
			switch (m_state)
			{
				case "Incoming":
					//le faire tourner sur lui meme
					angle--;
					m_distance-= MathUtils.interpolate(6.0, 0.1, ((m_roamingDistance * 2) - m_distance) / m_roamingDistance);

					if ( m_distance <= m_roamingDistance )
					{
						m_state = "Roaming";
					}
					break;
				case "Roaming":
					//le faire tourner sur lui meme
					angle--;
					//si l'utilisateur clique sur le météore
					if (onClick()) 
					{
						//on fait tomber le météore
						m_state = "Crashing";
                        // mspeed = m_speed * 1.2;
					}
					break;
				case "Crashing":
					//le faire tourner sur lui meme
					angle--;
					//réduire la distance entre le météore et la planète
					m_distance -= MathUtils.interpolate(0.1, 6, m_crashTime);
					m_crashTime += 0.003;
					
					//si le météore atteint la planete :: il explose
					if (m_distance <= m_planet.radius()) {
						m_speed = 0;
						//placer l'explosion
						m_explosion.setPos(m_pos);
						m_explosion.place();
						m_explosion.rotateToPlanet();
						
						//rendre l'explosion visible
						m_explosion.visible = true;
						//jouer l'anim d'explosion
						m_explosion.play("explode");
						if (m_giveLife == true) 
						{
							m_crashTime = 0;
							m_state = "Digging"
						}
						else 
						{
							visible = false;
							m_state = "Exploding";
						}
						
					}
					break;
				case "Digging":
					// Creusement
					//réduire la distance entre le météore et la planète
					m_distance -= MathUtils.interpolate(6, 1.2, m_crashTime);
					m_crashTime += 0.004;
					
					if (m_explosion.finished)
					{
						m_explosion.visible = false;
					}
					if (m_distance < 0.1)
						m_state = "Exploding";
					break;
				case "Exploding":
					visible = false;
					if (m_explosion.finished){
						m_hasExploded = true;
					}
					break;
			}
			
			//faire tourner le météore en orbite
			m_pos += m_speed;
			
			//placer le météore
			place();
			
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
			if ( Math.abs(((m_explosion.getPos() + 180) % 360) - ((blobby.getPos() + 180) % 360)) < 30 )
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
			if ( Math.abs(((m_explosion.getPos() + 180) % 360) - ((tree.getPos() + 180) % 360)) < 30 )
			{
				return true;
			}
			return false;
		}
		
		public function getExplosion():Element {
			return m_explosion;
		}
		
		
		override public function destroy():void 
		{
			m_explosion.destroy();
			m_explosion = null;
			super.destroy();
		}
		
		public function hasExploded():Boolean
		{
			return m_hasExploded;
		}
		
		public function isExploding():Boolean {
			return m_state == "Exploding";
		}
		
		public function giveLife():Boolean {
			return m_giveLife;
		}
	}

}