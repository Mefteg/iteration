package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class PlayState extends FlxState
	{
		
		protected var planet:Planet;
		protected var blobbies:Array;
		protected var meteor:Meteor;
		private var tree:Tree;
		
		public function PlayState() 
		{
			//------CREER LA PLANETE-----------------
			planet = new Planet( FlxG.width/3 , FlxG.height/3);
			
			add(planet);
			
			//-------CREER LES BLOBBIES--------------			
			blobbies = [];
			
			//tableau de positions des blobbies à créer
			var tabBlobbiesPosition:Array = [ 2 , 90, 200 ];
											
			var blob:Blobby;
			var sizeBlob:uint = tabBlobbiesPosition.length; // optimisation
			
			for (var i:int = 0; i < sizeBlob ; i++) 
			{
				blob = new Blobby( tabBlobbiesPosition[i],planet.radius(), planet);
				blobbies.push(blob);
				add(blob);
			}
			
			//----------CREER LE METEOR-------------
			meteor = new Meteor(0, planet.radius() * 2, planet, blobbies);
			add(meteor);
			
			tree = new Tree(planet.center(), planet.radius());
			add(tree);
		}
		
		override public function create():void {
			FlxG.bgColor = 0xffaaaaaa;
		}
		
	}

}