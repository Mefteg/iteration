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
			super(0, (FlxG.random() * 50) + (distance+100), planet);
			var cloud:FlxSprite = loadGraphic(SpriteResources.ImgCloud, false, false, 417, 417);
			cloud.scale.x = GameParams.scale * GameParams.scaleCloud;
			cloud.scale.y = GameParams.scale * GameParams.scaleCloud;
			
			if ( FlxG.random() < 0.5 )
			{
				m_direction = 1;
			}
			else
			{
				m_direction = 2;
			}
			m_pos = FlxG.random() * 360 - 180;
			m_speed = FlxG.random() / 16;		
		}	
		
		override public function update():void 
		{
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