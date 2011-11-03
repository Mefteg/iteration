package  
{
	/**
	 * ...
	 * @author Moi
	 */
	
	import Game.Ideas.Idea;
	import Game.Objects.Blobby;
	import Game.Objects.Planet;
	import Game.States.PlayState;
	import org.flixel.*;
	 
	public class Iteration 
	{
		//Planet
		private var m_planet:Planet;
		//Game
		private var m_scene:PlayState;
		//idées
		protected var ideas:Array;
		protected var m_currentIdea:Idea;
		//Timers
		private var timer:FlxTimer ;
		private var timerDeath:FlxTimer;//timer pour la mort
		private var timerBirth:FlxTimer;//timer pour la naissance
		private var timerIdea:FlxTimer; //timer pour les idées
		
		private var iterTime:Number = 10;
		private var iterNumber:int = 0;
		
		//variables pour la gestion des événements
		private var nbDeaths:int;
		private var nbBirths:int;
		//variables comptant le nombre de D/B par itération
		private var countDeaths:int=0;
		private var countBirths:int = 0;
		//variables pour le taux de mortalité/natalité
		private var ratioDeath:Number = 0.25;
		private var ratioBirth:Number = 0.50;
		
		public function Iteration(state:PlayState, planet:Planet) 
		{
			m_planet = planet;
			m_scene = state;
			
			//instancier le timer
			timer = new FlxTimer();
			//et le démarrer immédiatement
			timer.start(iterTime);
			
			timerDeath = new FlxTimer();
			startDeathTimer();
			
			timerBirth = new FlxTimer();
			startBirthTimer();
			
			//IDEES
			ideas = new Array();
			var idea:Idea = new Idea(0, 0, 10, 0, planet);
			ideas.push(idea);
			timerIdea = new FlxTimer();
			startIdeaTimer();
			
			calcStats();
			
		}
		
		public function restart() : void {
			//mettre a jour le nbre de morts et naissances
			calcStats();
			countBirths = 0;
			countDeaths = 0;
			//redémarrer les timers
			startDeathTimer();
			startBirthTimer();
			startIdeaTimer();
								
			timer.start(iterTime);
		}
		
		public function createIdea():void {
			//
			m_currentIdea = ideas[0];
			m_planet.getBlobbies()[0].setIdea(m_currentIdea);
			m_scene.add(m_currentIdea);
		}
		
		//calcule le nombre de morts et de naissances
		private function calcStats():void {
			var rand:Number = Math.random();
			nbDeaths = m_planet.getBlobbies().length * ratioDeath; // 25% de morts
			nbBirths = m_planet.getBlobbies().length * ratioBirth; //50% de naissances
		}
		
		//calcule un temps aléatoire pour la prochaine mort
		//principe : on trouve l'intervalle de temps dans laquelle il y aura au moins une mort
		// par exemple si l'iteration dure une seconde et que l'on doit avoir 4 morts,
		//             on aura un intervalle de 1/4 : un mort pour chaque intervalle de 25 sec
		private function startDeathTimer() : void {
			timerDeath.start( Math.random() * (iterTime / nbDeaths) );
		}
		//calcule un temps aléatoire pour la prochaine naissance
		private function startBirthTimer():void {
			timerBirth.start( Math.random() * (iterTime / nbBirths) );
		}
		//calcule le temps aléatoire pour la prochaine idée
		private function startIdeaTimer():void {
			timerIdea.start(Math.random() * iterTime);
		}
		public function getElapsedTime():Number {
			return timer.time;
		}
		
		public function getIterations() :int{
			return iterNumber;
		}
		
		public function changeDeathRatio(val:Number):void {
			ratioDeath += val;
			if (ratioDeath > 1)
				ratioDeath = 1;
		}
		
		public function changeBirthRation(val:Number):void {
			ratioBirth += val;
			if (ratioBirth > 1)
				ratioBirth = 1;
		}
		
		public function update() :void {
			//si le timer principal de l'itération est terminé
			if (timer.finished) {
				//incrémenter le nombre d'itérations
				iterNumber++;
				//relancer le timer
				restart();
			}
			
			//GESTION MORTS
			//Si le timer de mort arrive a échéance
			if ( (timerDeath.finished) && (countDeaths < nbDeaths) ) {
				//supprimer un blobby
				m_planet.getBlobbies().pop().destroy();
				//incrémentere le compteur de morts
				countDeaths++;
				//redémarrer le timer pour les morts
				startDeathTimer();
			}
			
			//GESTION DES NAISSANCES
			//si le timer de naissances arrive a échéance
			if ( (timerBirth.finished) && (countBirths < nbBirths) ) {
				//créer un nouveau blobby
				var blobby:Blobby = new Blobby(Math.random() * 360, m_planet.radius(), m_planet);
				//ajouter le blobby a la liste
				m_planet.getBlobbies().push(blobby);
				//ajouter le blobby a la scene
				m_scene.add(blobby);
				
				countBirths++;
				startBirthTimer();
			}
			//GESTION DES IDEES
			if (timerIdea.finished)
				createIdea();
				
		}
		
	}

}