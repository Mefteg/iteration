package Game.Objects 
{
	import flash.geom.Point;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
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
		static private var m_hasSelected:Boolean;
		
		private var m_cloudSprite:FlxSprite;
		private var m_rainSprite:FlxSprite;
		
		private var m_direction:uint;
		private var m_pos:Number;
		private var m_speed:Number;
		private var m_state:String;
		private var m_distance:Number;
		
		private var m_planet:Planet = null;
		
		public function Cloud(planet:Planet) 
		{
			m_planet = planet;
			m_distance = (FlxG.random() * GameParams.map.m_cloudsDistanceRandom) + GameParams.map.m_cloudsDistance;
			
			m_cloudSprite = new FlxSprite();
			if ( FlxG.random() < 0.5 )
			{
				m_cloudSprite.loadGraphic2(SpriteResources.ImgCloud, false, false, 552, 187);
				m_cloudSprite.addAnimation("rain", MathUtils.getArrayofNumbers(0, 16), 10, false);
				m_cloudSprite.addAnimation("birth", MathUtils.getArrayofNumbers(0, 16).reverse(), 10, false);
			}
			else
			{
				m_cloudSprite.loadGraphic2(SpriteResources.ImgCloud2, false, false, 592, 214);
				m_cloudSprite.addAnimation("rain", MathUtils.getArrayofNumbers(0, 16), 10, false);
				m_cloudSprite.addAnimation("birth", MathUtils.getArrayofNumbers(0, 17).reverse(), 10, false);
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
			m_speed = FlxG.random() / 16 + GameParams.map.cloudSpeed;	
			
			m_state = "Roaming";
			m_hasSelected = false;
			
			m_cloudSprite.play("birth");
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
						m_pos = 90 + (90 - ( -m_pos));
						m_pos -= 5;
					}
					else
					{
						m_pos += 0;
					}
					
					if (!FlxG.mouse.pressed()) 
					{
						//on fait tomber le météore
						m_state = "Raining";
						m_hasSelected = false;
						m_rainSprite.visible = true;
						m_cloudSprite.play("rain");
						m_rainSprite.play("rain");
						GameParams.playstate.rain(m_pos + 10);

						// mspeed = m_speed * 1.2;
					}
					break;
				case "Raining":
					var angle:Number = (Math.PI / 180) * m_pos ;
					m_rainSprite.x = m_planet.center().x + Math.cos(MathUtils.degToRan(m_pos)) * (m_distance-GameParams.map.rainDistance) * GameParams.map.zoom - m_rainSprite.width /2;
					m_rainSprite.y = m_planet.center().y - Math.sin(MathUtils.degToRan(m_pos)) * (m_distance-GameParams.map.rainDistance) * GameParams.map.zoom - m_rainSprite.height / 2;
					m_rainSprite.angle = -m_pos + 90;
					
					if ( m_cloudSprite.finished )
					{
						reinit();
					}
					
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
			if ( m_hasSelected && FlxG.mouse.pressed() || FlxG.mouse.justPressed() )
			{
				//si click de la souris
				var mouseX:int = FlxG.mouse.getWorldPosition(GameParams.camera).x;
				var mouseY:int = FlxG.mouse.getWorldPosition(GameParams.camera).y;
				
				if ( m_cloudSprite.pixelsOverlapPoint(new FlxPoint(mouseX, mouseY), 0xFF, GameParams.camera) )
				{
					if ( Point.distance(new Point(mouseX, mouseY), new Point(m_cloudSprite.x + m_cloudSprite.width / 2, m_cloudSprite.y + m_cloudSprite.height / 2)) < Math.min(m_cloudSprite.height,m_cloudSprite.width)/2 )
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function reinit():void
		{
			m_distance = (FlxG.random() * GameParams.map.m_cloudsDistanceRandom) + GameParams.map.m_cloudsDistance;
			
			m_cloudSprite.scale.x = (1 * FlxG.random() /	50 + 1) * GameParams.map.zoom;
			m_cloudSprite.scale.y = (1 * FlxG.random() / 50 + 1) * GameParams.map.zoom;
			
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
			m_speed = FlxG.random() / 16 + GameParams.map.cloudSpeed;
			
			m_cloudSprite.frame = 0;
			
			m_state = "Roaming";
			m_hasSelected = false;
			
			m_cloudSprite.play("birth");
		}
	}

}