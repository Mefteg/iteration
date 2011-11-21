package Game.Objects
{
	import flash.geom.Point;
	import Globals.GameParams;
	import Resources.SoundResources;
	import Utils.MathUtils;
	import org.flixel.*;
	
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author ...
	 */
	public class Planet extends FlxGroup
	{				
		private var m_planet:FlxSprite;
		private var m_heart:FlxSprite;
		private var m_heartHalo:FlxSprite;
		private var m_heartBack:FlxSprite;
		private var m_heartDeath:FlxSprite;
		
		protected var m_blobbies:Array;
		protected var m_trees:Array;
		
		private var m_elapsedTime:Number = 0;
		
		private var m_center:Point;//centre de la planete
		private var m_radius:Number; //son rayon
		
		private var m_resources:int; // ressources de la planete
		private var m_distance:Number = 0;
		
		private var m_state:String = "Dead";
		private var m_animTime:Number = 0;
		
		/**
		 * if 1 low ressource
		 * if 2 middle ressource
		 * if 3 high ressource
		 */
		private var m_ressourceLevel = 0;
		
		private var nbFrame:uint = 0;
		
		public function Planet(x:Number, y:Number, blobbies:Array) 
		{
			m_planet = new FlxSprite(x, y);
			
			m_planet.loadGraphic2( SpriteResources.ImgPlnt,false,false,1400,1400);
			add(m_planet);
			
			m_center = new Point(x + m_planet.width / 2, y + m_planet.height / 2);
			m_radius = (m_planet.height) / 2;
			
			m_blobbies = blobbies;
			
			m_resources = GameParams.map.m_planetResources;
			
			m_heart = new FlxSprite(m_planet.x, m_planet.y);
			m_heart.loadGraphic2( SpriteResources.ImgHeart,false,false,1600,1600);
			m_heartHalo = new FlxSprite(m_planet.x / 2, m_planet.y / 2);
			m_heartHalo.loadGraphic2( SpriteResources.ImgHeartHalo,false,false,1600,1600);
			m_heartBack = new FlxSprite(m_planet.x / 2, m_planet.y / 2);
			m_heartBack.loadGraphic2( SpriteResources.ImgHeartBack, false, false, 1600, 1600);
			m_heartDeath = new FlxSprite(m_planet.x / 2, m_planet.y / 2);
			m_heartDeath.loadGraphic2( SpriteResources.ImgHeartDeath, false, false, 1600, 1600);

			m_heart.scale.x = 0.1;
			m_heart.scale.y = 0.1;
			m_heartHalo.scale.x = 0.1;
			m_heartHalo.scale.y = 0.1;
			m_heartBack.scale.x = 0.1;
			m_heartBack.scale.y = 0.1;
			m_heartDeath.scale.x = 0.1 * GameParams.map.zoom;
			m_heartDeath.scale.y = 0.1 * GameParams.map.zoom;
			
			m_heartDeath.x = center().x + Math.cos(m_heart.angle) * (m_distance)* GameParams.map.zoom - m_heart.width /2;
			m_heartDeath.y = center().y - Math.sin(m_heart.angle) * (m_distance) * GameParams.map.zoom - m_heart.height / 2; 
			
			m_heartBack.alpha = m_heartHalo.alpha = m_heart.alpha = 0;
			
			m_planet.visible = true;
			m_heartDeath.visible = true;
			m_heart.visible = false;
			m_heartHalo.visible = false;
			m_heartBack.visible = false;
			
			m_animTime = 0;
			
			m_ressourceLevel = 0;
		}
		
		override public function update():void 
		{
			super.update();
			m_planet.scale = new FlxPoint(GameParams.map.zoom, GameParams.map.zoom);
			
			m_elapsedTime += FlxG.elapsed * 8;
			var pulse:Number = (Math.sin(m_elapsedTime * 4) / 4) / (Math.sin(m_elapsedTime / 4) * 4) / 64;
			var pulseScale:Number = ((pulse + (m_resources / 10000) * 0.7096) + 0.1) * GameParams.map.zoom;
			
			m_animTime += 0.01;
			
			switch (m_state)
			{
				case "Birth_s1":					
					pulseScale = MathUtils.interpolate(0.1, 0.7096, m_animTime) * GameParams.map.zoom;
					
					m_heartDeath.scale.x = pulseScale;
					m_heartDeath.scale.y = pulseScale;
					
					if ( m_animTime > 1 )
					{
						m_animTime = 0;
						
						m_planet.visible = true;
						m_heartDeath.visible = true;
						m_heart.visible = true;
						m_heartHalo.visible = true;
						m_heartBack.visible = true;
						
						m_state = "Birth_s2";
					}
					break;
				case "Birth_s2":
					pulse = (Math.sin(m_elapsedTime * 4) / 4) / (Math.sin(m_elapsedTime / 4) * 4) / 64;
                    pulseScale = (pulse + (m_resources / 10000) * 0.7096) * GameParams.map.zoom;

					m_heartDeath.scale.x = pulseScale;
                    m_heartDeath.scale.y = pulseScale;

					if ( nbFrame > 25 )
					{
						m_heartBack.alpha = m_heartHalo.alpha = m_heart.alpha = MathUtils.interpolate(0.0, 1., m_animTime);
						m_heartDeath.alpha = MathUtils.interpolate(1.0, 0., m_animTime);
						nbFrame = 0;
					}
					nbFrame++;
					
					if ( m_animTime > 1 )
					{
						nbFrame = 0;
						m_animTime = 0;
						
						m_planet.visible = true;
						m_heartDeath.visible = false;
						m_heart.visible = true;
						m_heartHalo.visible = true;
						m_heartBack.visible = true;
						
						m_state = "Living";
						
						var size:int = m_blobbies.length;
						for (var i:int = 0; i < size; i++)
						{
							m_blobbies[i].visible = true;
						}
					}
					break;
				case "Living":
					m_heartHalo.angle-= 0.04;
					m_heartBack.angle += 0.04;
					break;
				case "Dead":
					m_heartDeath.scale.x = 0.1 * GameParams.map.zoom;
                    m_heartDeath.scale.y = 0.1 * GameParams.map.zoom;
					
					m_heartDeath.alpha = 1;

					
					pulseScale = 0.1 * GameParams.map.zoom;
					break;
				case "Dying":
					m_heartDeath.scale.x = 0.1 * GameParams.map.zoom;
                    m_heartDeath.scale.y = 0.1 * GameParams.map.zoom;
					
					m_heartDeath.alpha = 1;
					
					dying();
					break;
			}
			m_heartDeath.x = m_heartBack.x = m_heartHalo.x = m_heart.x = center().x + Math.cos(m_heart.angle) * (m_distance)* GameParams.map.zoom - m_heart.width /2;
			m_heartDeath.y = m_heartBack.y = m_heartHalo.y = m_heart.y = center().y - Math.sin(m_heart.angle) * (m_distance) * GameParams.map.zoom - m_heart.height / 2;
			
			m_heart.scale.x = pulseScale;
			m_heart.scale.y = pulseScale;
			m_heartHalo.scale.x = pulseScale;
			m_heartHalo.scale.y = pulseScale;
			m_heartBack.scale.x = pulseScale;
			m_heartBack.scale.y = pulseScale;
			
			/*
			m_heartDeath.scale.x = pulseScale;
			m_heartDeath.scale.y = pulseScale;
			*/
			
			if ( m_state == "Dead" || m_state == "Dying" )
			{
				GameParams.soundBank.get(SoundResources.backgroudLowRessMusic).stop();
				GameParams.soundBank.get(SoundResources.backgroudMusic).stop();
				GameParams.soundBank.get(SoundResources.backgroudHighRessMusic).stop();
				m_ressourceLevel = 0;
			}
			else
			{			
				if ( m_resources < GameParams.map.m_soundRessourcesLow && m_ressourceLevel != 1 )
				{
					GameParams.soundBank.get(SoundResources.backgroudLowRessMusic).fadeIn(GameParams.map.m_soundFadeInTime);
					GameParams.soundBank.get(SoundResources.backgroudMusic).fadeOut(GameParams.map.m_soundFadeOutTime);
					m_ressourceLevel = 1;
				}
				else if ( m_resources > GameParams.map.m_soundRessourcesHigh && m_ressourceLevel != 3)
				{
					GameParams.soundBank.get(SoundResources.backgroudHighRessMusic).fadeIn(GameParams.map.m_soundFadeInTime);
					GameParams.soundBank.get(SoundResources.backgroudMusic).fadeOut(GameParams.map.m_soundFadeOutTime);
					m_ressourceLevel = 3;
				}
				else if ( m_resources < GameParams.map.m_soundRessourcesHigh &&
						  m_resources > GameParams.map.m_soundRessourcesLow &&
						  m_ressourceLevel != 2)
				{
					GameParams.soundBank.get(SoundResources.backgroudLowRessMusic).fadeOut(GameParams.map.m_soundFadeOutTime);
					GameParams.soundBank.get(SoundResources.backgroudMusic).fadeIn(GameParams.map.m_soundFadeInTime);
					GameParams.soundBank.get(SoundResources.backgroudHighRessMusic).fadeOut(GameParams.map.m_soundFadeOutTime);
					m_ressourceLevel = 2;
				}
			}
		}
		
		public function center():Point
		{
			return m_center;
		}
		
		public function radius():Number
		{
			return m_radius;
		}
		
		public function getMidpoint():FlxPoint
		{
			return m_planet.getMidpoint();
		}
		
		public function getWidth():Number
		{
			return m_planet.width;
		}
		
		public function getHeight():Number
		{
			return m_planet.height;
		}
		
		public function getBlobbies():Array {
			return m_blobbies;
		}
		
		public function setTrees(trees:Array):void
		{
			m_trees = trees;
		}
		
		public function getTrees():Array {
			return m_trees;
		}
		
		public function getResources():int {
			return m_resources;
		}
		
		public function addResources(n:int):void {
			m_resources += n;
		}
		
		public function removeResources(n:int):void {
			m_resources -= n;
		}
		
		public function setScale(value:FlxPoint):void {
			m_planet.scale = value;
		}
		
		public function getDistance():Number {
			return m_distance;
		}
		
		public function setDistance(value:Number):void {
			m_distance = value;
		}
		
		public function addBlobby(blobby:Blobby):void {
			m_blobbies.push(blobby);
		}
		//supprime un blobby
		public function removeBlobby(blobby:Blobby):void 
		{
			var index:int = m_blobbies.indexOf(blobby);
			m_blobbies.splice(index, 1);
		}
		public function removeBlobbyAt(index:int):void {
			m_blobbies[index].setState("die");
			m_blobbies.splice(index, 1);
		}
		
		// tree deletion
		public function removeTree(tree:Tree):void {
			var index:int = m_trees.indexOf(tree);
			m_trees[index].setState("die");
			m_trees.splice(index, 1);
		}
		
		public function isDead():Boolean
		{
			if ( m_resources < 0 || m_blobbies.length < 3 )
			{
				return true;
			}
			return false;
		}
		
		public function live():void
		{	
			m_planet.visible = true;
			m_heartDeath.visible = true;
			m_heart.visible = false;
			m_heartHalo.visible = false;
			m_heartBack.visible = false;
			
			m_heartDeath.scale.x = 0.1 * GameParams.map.zoom;
			m_heartDeath.scale.y = 0.1 * GameParams.map.zoom;
			
			m_animTime = 0;
			
			m_resources = GameParams.map.m_planetResources;
			m_state = "Birth_s1";
			
			GameParams.soundBank.get(SoundResources.ressBirthSound).play();
			m_ressourceLevel = 0;
		}
		
		public function explosion():void
		{	
			m_planet.visible = true;
			m_heartDeath.visible = true;
			m_heart.visible = false;
			m_heartHalo.visible = false;
			m_heartBack.visible = false;
			m_state = "Dying";
			
			//jouer les anims de mort de tous les elements
			var size:int = m_blobbies.length;
			for (var i:int = 0; i < size; i++) 
			{
				if(! m_blobbies[i].isDying())
					m_blobbies[i].setState("comeBack")
			}	
			size = m_trees.length;
			for (var j:int = 0; j < size; j++) 
			{
				m_trees[j].setState("die");
			}
		}
		
		public function dying():void 
		{
			var hasTrees:Boolean = false;
			var nbTrees:uint = m_trees.length;
			for (var i:int = 0 ; i < nbTrees ; i++ )
			{
				if ( m_trees[i] && m_trees[i].visible )
				{
					hasTrees = true;
					break;
				}
			}
			
			if ( m_blobbies.length == 0 && hasTrees == false)
			{
				m_state = "Dead";
			}
		}
		public function getHeartSprite():FlxSprite
		{
			return m_heart;
		}
		
		public function getDeadHeartSprite():FlxSprite
		{
			return m_heartDeath;
		}
		
		public function getHaloHeartSprite():FlxSprite
		{
			return m_heartHalo;
		}
		
		public function getBackHeartSprite():FlxSprite
		{
			return m_heartBack;
		}
		
		public function isDying():Boolean {
			return m_state == "Dying";
		}
		
		public function getCenterScreenXY(Camera:FlxCamera=null):FlxPoint
		{
			var pt:FlxPoint = new FlxPoint();
			if(Camera == null)
				Camera = FlxG.camera;
			pt.x = center().x - int(Camera.scroll.x);
			pt.y = center().y - int(Camera.scroll.y);
			return pt;
		}
	}

}