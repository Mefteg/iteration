package Game.Objects 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import Utils.MathUtils;
	
	import Globals.GameParams;
	
	import Resources.SpriteResources;
	
	/**
	 * ...
	 * @author LittleWhite
	 */
	public class Cloud extends FlxGroup
	{				
		static var m_hasSelected:Boolean;
		
		private var m_cloudSprite:FlxSprite;
		private var m_rainSprite:FlxSprite;
		
		private var m_direction:uint;
		private var m_pos:Number;
		private var m_speed:Number;
		private var m_state:String;
		private var m_distance:Number;
		
		private var m_planet:Planet = null;
		
		public function Cloud(distance:Number, planet:Planet) 
		{
			m_planet = planet;
			m_distance = (FlxG.random() * 50) + (distance + 380);
			// super(0, (FlxG.random() * 50) + (distance + 380), planet);
			
			m_cloudSprite = new FlxSprite();
			if ( FlxG.random() < 0.5 )
			{
				m_cloudSprite.loadGraphic2(SpriteResources.ImgCloud, false, false, 417, 187);
			}
			else
			{
				m_cloudSprite.loadGraphic2(SpriteResources.ImgCloud2, false, false, 461, 214);
			}

			m_cloudSprite.scale.x = 1 * FlxG.random() /	50 + 1;
			m_cloudSprite.scale.y = 1 * FlxG.random() / 50 + 1;
			
			m_rainSprite = new FlxSprite();
			m_rainSprite.loadGraphic2(SpriteResources.ImgRain, false, false, 457, 503);
			m_rainSprite.addAnimation("rain", MathUtils.getArrayofNumbers(0, 13), 10, true);
			
			// GameParams.playstate.getDepthBuffer().addForeground(m_cloudSprite);
			
			add(m_rainSprite);
			add(m_cloudSprite);
			
			
			m_rainSprite.visible = false;
			m_cloudSprite.visible = true;
			
			if ( FlxG.random() < 0.5 )
			{
				m_direction = 1;
			}
			else
			{
				m_direction = 2;
			}
			m_pos = FlxG.random() * 360 - 180;
			m_speed = FlxG.random() / 16 + 0.02;	
			
			m_state = "Roaming";
			m_hasSelected = false;
		}	
		
		override public function update():void 
		{
			super.update();
			
			m_cloudSprite.scale = new FlxPoint(GameParams.map.zoom,GameParams.map.zoom);
			
			switch ( m_state )
			{
				case "Roaming":
					if ( m_direction == 1 )
					{
						m_pos+=m_speed;
					}
					else
					{
						m_pos-=m_speed;
					}
					
					if (clicDetection() && !m_hasSelected) 
					{
						//on fait tomber le météore
						m_state = "Attached";
						m_hasSelected = true;
						// mspeed = m_speed * 1.2;
					}
					break;
				case "Attached":
					m_pos = ( -180 / Math.PI) * Math.atan((FlxG.mouse.y - (FlxG.height / 2.)) / (FlxG.mouse.x - (FlxG.width / 2.)));
					if ( FlxG.mouse.x < FlxG.width / 2 )
					{
						m_pos = 90 + (90 - (-m_pos));
					}
					
					if (!FlxG.mouse.pressed()) 
					{
						//on fait tomber le météore
						m_state = "Raining";
						m_hasSelected = false;
						m_rainSprite.visible = true;
						m_rainSprite.play("rain");

						// mspeed = m_speed * 1.2;
					}
					break;
				case "Raining":
					var angle:Number = (Math.PI / 180) * m_pos ;
					m_rainSprite.x = m_planet.center().x + Math.cos(MathUtils.degToRan(m_pos)) * (m_distance-GameParams.map.rainDistance) * GameParams.map.zoom - m_rainSprite.width /2;
					m_rainSprite.y = m_planet.center().y - Math.sin(MathUtils.degToRan(m_pos)) * (m_distance-GameParams.map.rainDistance) * GameParams.map.zoom - m_rainSprite.height / 2;
					m_rainSprite.angle = -m_pos + 90;
					break;
			}

			
			m_cloudSprite.x = m_planet.center().x + Math.cos(MathUtils.degToRan(m_pos)) * (m_distance) * GameParams.map.zoom - m_cloudSprite.width /2;
			m_cloudSprite.y = m_planet.center().y - Math.sin(MathUtils.degToRan(m_pos)) * (m_distance) * GameParams.map.zoom - m_cloudSprite.height / 2;
			
			m_cloudSprite.angle = -m_pos + 90;
			
			m_rainSprite.scale = m_cloudSprite.scale;
		}
		
		override public function draw():void 
		{
			super.draw();
			
			switch (m_state)
			{
				case "Roaming":
					m_cloudSprite.draw();
					break;
				case "Attached":
					m_cloudSprite.draw();
					break;
				case "Raining":
					m_rainSprite.draw();
					break;
					
			}
		}
	
		public function clicDetection():Boolean 
		{
			if ( FlxG.mouse.pressed() )
			{
				//si click de la souris
				var mouseX:int = FlxG.mouse.x ;
				var mouseY:int = FlxG.mouse.y ;
				var screenXY:FlxPoint = m_cloudSprite.getScreenXY(new FlxPoint(m_cloudSprite.x, m_cloudSprite.y), GameParams.camera);
				
				//et si la souris se trouve sur le sprite
				if ( ( mouseX < screenXY.x + m_cloudSprite.width) && (mouseX > screenXY.x) ) {
					if ( (mouseY < screenXY.y + m_cloudSprite.height/2) && (mouseY > screenXY.y) ) {
						return true;
					}
				}
			}
			return false;
		}
	}

}