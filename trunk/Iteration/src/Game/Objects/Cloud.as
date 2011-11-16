package Game.Objects 
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	import Globals.GameParams;
	
	import Resources.SpriteResources;
	
	/**
	 * ...
	 * @author LittleWhite
	 */
	public class Cloud extends Element
	{		
		static var m_hasSelected:Boolean;
		
		public function Cloud(distance:Number, planet:Planet) 
		{
			super(0, (FlxG.random() * 50) + (distance + 380), planet);
			
			var cloud:FlxSprite;
			if ( FlxG.random() < 0.5 )
			{
				cloud = loadGraphic2(SpriteResources.ImgCloud, false, false, 417, 187);
			}
			else
			{
				cloud = loadGraphic2(SpriteResources.ImgCloud2, false, false, 461, 214);
			}

			cloud.scale.x = 1 * FlxG.random() /	50 + 1;
			cloud.scale.y = 1 * FlxG.random() / 50 + 1;
			
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
						m_state = "Roaming";
						m_hasSelected = false;
						// mspeed = m_speed * 1.2;
					}
					break;
				case "Raining":
					break;
			}

			this.place();
			this.rotateToPlanet();
		}
	
		public function clicDetection():Boolean 
		{
			if ( FlxG.mouse.pressed() )
			{
				//si click de la souris
				var mouseX:int = FlxG.mouse.x ;
				var mouseY:int = FlxG.mouse.y ;
				var screenXY:FlxPoint = getScreenXY(new FlxPoint(x, y), GameParams.camera);
				
				//et si la souris se trouve sur le sprite
				if ( ( mouseX < screenXY.x + width) && (mouseX > screenXY.x) ) {
					if ( (mouseY < screenXY.y + height/2) && (mouseY > screenXY.y) ) {
						return true;
					}
				}
			}
			return false;
		}
	}

}