package Game.Objects 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	import Globals.GameParams;
	
	import Resources.SpriteResources;
	
	/**
	 * ...
	 * @author LittleWhite
	 */
	public class Cloud extends Element
	{		
		public function Cloud(distance:Number, planet:Planet) 
		{
			super(0, (FlxG.random() * 50) + (distance + 350), planet);
			
			var cloud:FlxSprite;
			if ( FlxG.random() < 0.5 )
			{
				cloud = loadGraphic(SpriteResources.ImgCloud, false, false, 417, 187);
			}
			else
			{
				cloud = loadGraphic(SpriteResources.ImgCloud2, false, false, 461, 214);
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
		}	
		
		override public function update():void 
		{
			super.update();

			if ( m_direction == 1 )
			{
				m_pos+=m_speed;
			}
			else
			{
				m_pos-=m_speed;
			}
			
			this.place();
			this.rotateToPlanet();
		}
	}

}