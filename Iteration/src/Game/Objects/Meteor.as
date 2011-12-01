package Game.Objects
{
	import flash.geom.Point;
	import Globals.GameParams;
	import flash.text.engine.ElementFormat;
	import org.flixel.*;
	import Resources.SoundResources;
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
		private var m_giveLife:Boolean;
		
		private var m_soundTimer:FlxTimer = new FlxTimer();
		
		public function Meteor(roamingDistance:Number,planet:Planet,glife:Boolean) 
		{
			super(0, roamingDistance * 2, planet);
			if ( !glife ) {
				m_distance = GameParams.map.m_meteorDistance * 2;
			}
			
			m_roamingDistance = roamingDistance;
			//Créer l'image
			if (glife)
			{
				loadGraphic2(SpriteResources.ImgMeteorLife, false, false, 166, 171);
				m_soundTimer.start(3);
			}
			else
			{
				m_roamingDistance = GameParams.map.m_meteorDistance;
				loadGraphic2(SpriteResources.ImgMeteor, false, false, 351, 333);
				m_soundTimer.start(3);
			}
			m_speed = GameParams.map.m_meteorSpeed;

			//dimensionner le météore par rapport a la planete
			this.scale.x = (0.1 * planet.getHeight())/width;
			this.scale.y = (0.1 * planet.getWidth()) / height;
			//créer l'explosion
			m_explosion = new Element(m_pos, planet.radius()+345, planet);
			m_explosion.loadGraphic2(SpriteResources.ImgExplosionMeteor, true, false, 900, 1000);
			m_explosion.addAnimation("explode", MathUtils.getArrayofNumbers(0, 15), 6, false);
			m_explosion.visible = false;
			m_giveLife = glife;
			
			m_state = "Incoming";
		}
		
		override public function update():void 
		{
			if ( m_soundTimer && m_soundTimer.finished )
			{
				m_soundTimer.destroy();
				m_soundTimer = null;
				if ( m_giveLife )
				{
					GameParams.soundBank.get(SoundResources.mlifeSound).play();
				}
				else
				{
					GameParams.soundBank.get(SoundResources.mdeathSound).play();
				}
			}
			
			switch (m_state)
			{
				case "Incoming":
					//le faire tourner sur lui meme
					angle--;
					m_distance-= MathUtils.interpolate(8.0, 0.5, ((m_roamingDistance * 2) - m_distance) / m_roamingDistance);

					if ( m_distance <= m_roamingDistance )
					{
						m_state = "Roaming";
						trace("Goes roaming");
					}
					/*
					if (onClick()) 
					{
						//on fait tomber le météore
						m_state = "Crashing";
                        // mspeed = m_speed * 1.2;
						
						if ( !m_giveLife )
						{
							//jouer le sons
							GameParams.soundBank.get(SoundResources.crashSound).play(GameParams.map.m_soundDeathMeteorVolume);
						}
						else
						{
							GameParams.soundBank.get(SoundResources.crashSound).play(GameParams.map.m_soundLifeMeteorVolume);
						}
					}*/
					
					break;
				case "Roaming":
					//le faire tourner sur lui meme
					angle--;
					//si l'utilisateur clique sur le météore
					if (onClick()) 
					{
						//on fait tomber le météore
						m_state = "Crashing";
						
						if ( !m_giveLife )
						{
							//jouer le sons
							GameParams.soundBank.get(SoundResources.crashSound).play(GameParams.map.m_soundDeathMeteorVolume);
						}
						else
						{
							GameParams.soundBank.get(SoundResources.crashSound).play(GameParams.map.m_soundLifeMeteorVolume);
						}
                        // mspeed = m_speed * 1.2;
					}
					break;
				case "Crashing":
					if(!m_giveLife && m_distance < m_planet.radius()+300)
						checkTargetedBlobbies();
					//le faire tourner sur lui meme
					angle--;
					//réduire la distance entre le météore et la planète
					m_distance -= MathUtils.interpolate(0.1, 6, m_crashTime);
					m_crashTime += 0.003;
					
					//si le météore atteint la planete :: il explose
					if (m_distance <= m_planet.radius()) 
					{
						m_speed = 0;
						//placer l'explosion
						m_explosion.setPos(m_pos-5);
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
					}else {
						m_explosion.place();
						m_explosion.rotateToPlanet();
					}
					if (m_distance < 0.1)
					{
						m_state = "Exploding";
					}
					break;
				case "Exploding":
					visible = false;
					m_explosion.place();
					m_explosion.rotateToPlanet();
					if (m_explosion.finished) {
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
				if (checkBlobbyCollision(blob) && !blob.isDying()) {
					blob.flip(false);
					blob.setState("comeBack");
				}
				
			}
		}
		
		private function checkTargetedBlobbies():void {
			var blobbies:Array = m_planet.getBlobbies();
			var size:int = blobbies.length;
			var blob:Blobby;
			for (var i:int = 0; i < size; i++) 
			{
				blob = blobbies[i];
				//si le blobby n'est pas occupé 
				if ( !blob.isNotSoBusy()) {
					//on calcule l'angle entre la météore et ce blobby
					var diff:Number = ((getPos() + 180) % 360) - ((blob.getPos() + 180) % 360);
					//si cet angle est suffisament petit on a une collision
					if (  Math.abs(diff) < GameParams.map.m_meteorZonePanic ) {
						//donner une direction d'échappatoire selon la position du blobby
						if (diff>-5) {
							blob.flip(false);
							blob.setDirection(2);
						}else {
							blob.flip(true);
							blob.setDirection(1);
						}
						// ce blobby a tout intérêt à paniquer
						blob.setState("goPanic");
					}
				}
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
				{
					tree.clearFruits();
					tree.setState("die");
				}
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