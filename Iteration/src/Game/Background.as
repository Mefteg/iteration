package Game 
{
	import Game.Objects.Planet;
	import Globals.GameParams;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Tom
	 */
	public class Background extends FlxSprite 
	{
		protected var m_planet:Planet;
		
		public function Background(pos:FlxPoint, sprite:Class, planet:Planet) {
			super(pos.x, pos.y, sprite);
			scale = new FlxPoint(GameParams.map.zoom+0.5, GameParams.map.zoom+0.5);
			m_planet = planet;
		}
		
		override public function update():void {
			super.update();
			scale = new FlxPoint(GameParams.map.zoom+0.5, GameParams.map.zoom+0.5);
			place();
		}
		
		protected function place():void {
			x = (m_planet.center().x - (this.width / 2));
			y = (m_planet.center().y - (this.height/ 2));
		}
		
	}

}