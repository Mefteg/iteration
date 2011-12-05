package Game 
{
	import Game.Objects.CloudGenerator;
	import Game.Objects.Meteor;
	import Game.Objects.Planet;
	import Game.Objects.TreeGenerator;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import Globals.GameParams;
	import Game.Objects.Scroll;
	/**
	 * ...
	 * @author LittleWhite
	 */
	public class LoadObject 
	{
		public var blobbies:Array;
		public var planet:Planet;
		public var m_treeGenerator:TreeGenerator;
		public var m_background:Background;
		public var m_cloudsGenerator:CloudGenerator;
		public var meteor:Meteor;
		
		public function LoadObject() 
		{
			blobbies = new Array();
			planet = new Planet( FlxG.width / 2 , FlxG.height / 2, blobbies);
 			m_treeGenerator = new TreeGenerator(planet);
			m_cloudsGenerator = new CloudGenerator(planet);
			meteor = new Meteor( planet.radius() * 2, planet, true);
			
			GameParams.scroll = new Scroll();
		}
		
	}

}