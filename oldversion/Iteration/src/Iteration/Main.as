package Iteration 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Moi
	 */
	
	 
	public class Main extends Sprite
	{
		public var planet:Planet;
		public var blobbies:Array;
		
		//timer incrémentant les itérations
		public var timer:Timer = new Timer(5000);
		public var iterations:int = 0;
		var iterationText:TextField = new TextField();
		
		public function Main() 
		{
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
				
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//créer la planete
			planet = new Planet(300, 300, 150);
			addChild(planet);
			
			//-------CREER LES BLOBBIES--------------			
			blobbies = [];
			
			//tableau de positions des blobbies à créer
			var tabBlobbiesPosition:Array = [ 2 , 90, 200 ];
											
			var blob:Blobby;
			var sizeBlob:uint = tabBlobbiesPosition.length; // optimisation
			
			for (var i:int = 0; i < sizeBlob ; i++) 
			{
				blob = new Blobby( tabBlobbiesPosition[i],planet.radius, planet);
				blobbies.push(blob);
				addChild(blob);
			}
			
			//créer une météorite
			var meteor:Meteor = new Meteor(0, planet.radius * 1.5,planet,blobbies);
			addChild(meteor);
			
			// création du champ de texte
			iterationText.textColor = 0xFFFFFF;
			this.addChild(iterationText);
			
			//Ajouter un event listener sur le timer et le démarrer
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, iterationUpdate);
		}
		
		//*******Actions à effectuer pour chaque itération********
		private function iterationUpdate(e:TimerEvent):void 
		{
			iterations ++;
			iterationText.text = "Iterations = " + iterations;
		}
		
	}

}