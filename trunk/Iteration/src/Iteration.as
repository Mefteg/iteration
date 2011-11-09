package  
{
	/**
	 * ...
	 * @author Moi
	 */
	
	import Game.Ideas.Idea;
	import Game.Objects.Blobby;
	import Game.Objects.Meteor;
	import Game.Objects.Planet;
	import Game.States.PlayState;
	import org.flixel.*;
	 
	public class Iteration 
	{
		//Planet
		private var m_planet:Planet;
		//blobbies
		private var m_blobbies:Array;
		//meteor
		private var m_meteor:Meteor;
		//Game
		private var m_scene:PlayState;
		//idées
		protected var m_ideas:Array;
		protected var m_currentIdea:Idea;
		//Timers
		private var m_timer:FlxTimer ;
		private var m_timerDeath:FlxTimer;//timer pour la mort
		private var m_timerBirth:FlxTimer;//timer pour la naissance
		private var m_timerIdea:FlxTimer; //timer pour les idées
		
		private var m_iterTime:Number = 10;
		private var m_iterNumber:int = 0;
		
		//variables pour la gestion des événements
		private var m_nbDeaths:int;
		private var m_nbBirths:int;
		//variables comptant le nombre de D/B par itération
		private var m_countDeaths:int=0;
		private var m_countBirths:int = 0;
		//variables pour le taux de mortalité/natalité
		private var m_ratioDeath:Number = 0.25;
		private var m_ratioBirth:Number = 0.60;
		
		// Information on iteration for outside the class
		private var m_iterationTick:Boolean = false;
		
		public function Iteration(state:PlayState, planet:Planet) 
		{
			m_planet = planet;
			m_scene = state;
			m_blobbies = m_planet.getBlobbies();
			//instancier le timer
			m_timer = new FlxTimer();
			//et le démarrer immédiatement
			m_timer.start(m_iterTime);
			
			m_timerDeath = new FlxTimer();
			startDeathTimer();
			
			m_timerBirth = new FlxTimer();
			startBirthTimer();
			
			initIdeas();
			
			m_timerIdea = new FlxTimer();
			
			
			calcStats();
			
		}
		
		public function initIdeas():void
		{
			if ( m_ideas != null )
			{
				while (m_ideas.length != 0 )
				{
					m_ideas.pop().destroy();
				}
			}
			
			//IDEES
			m_ideas = new Array();
			var idea:Idea = new Idea(0, 0, 10, 0, m_planet);
			var idea2:Idea = new Idea(0, 0, 10, 0, m_planet);
			var idea3:Idea = new Idea(0, 0, 10, 0, m_planet);
			var idea4:Idea = new Idea(0, 0, 10, 0, m_planet);
			var idea5:Idea = new Idea(0, 0, 10, 0, m_planet);
			var idea6:Idea = new Idea(0, 0, 10, 0, m_planet);
			var idea7:Idea = new Idea(0, 0, 10, 0, m_planet);
			m_ideas.push(idea);
			m_ideas.push(idea2);
			m_ideas.push(idea3);
			m_ideas.push(idea4);
			m_ideas.push(idea5);
			m_ideas.push(idea6);
			m_ideas.push(idea7);
		}
		
		public function reInit():void
		{
			m_iterNumber = 0;
			m_ratioDeath = 0.25;
			m_ratioBirth = 0.50;
			
			initIdeas();
			
			m_timer.start(m_iterTime);
			startIdeaTimer();
			startDeathTimer();
			startBirthTimer();
		}
		
		public function restart() : void {
			//mettre a jour le nbre de morts et naissances
			calcStats();
			m_countBirths = 0;
			m_countDeaths = 0;
			
			//redémarrer les timers
			startDeathTimer();
			startBirthTimer();
			startIdeaTimer();
			//redémarrer le timer principal					
			m_timer.start(m_iterTime);
		}
		
		public function createIdea():void {
			if (m_ideas.length == 0) return;
	
			//prendrer une idée au hasard
			m_currentIdea = m_ideas[  FlxU.round(Math.random() * (m_ideas.length -1))];
			//pour savoir si une idée a été trouvée
			var gotIt:Boolean = false;
			
			while(!gotIt){
				//prendre un blobby au hasard
				var blob:Blobby = m_planet.getBlobbies()[FlxU.round(Math.random() * ( m_planet.getBlobbies().length -1 ) )];
				if ( ! blob.isBusy() )
				{
					blob.setIdea(m_currentIdea);
					m_scene.add(m_currentIdea);
					gotIt = true;
				}
			}
		}
		
		//calcule le nombre de morts et de naissances
		private function calcStats():void {
			var rand:Number = Math.random();
			m_nbDeaths = m_planet.getBlobbies().length * m_ratioDeath; // % de morts
			m_nbBirths = m_planet.getBlobbies().length * m_ratioBirth; // % de naissances
		}
		
		//calcule un temps aléatoire pour la prochaine mort
		//principe : on trouve l'intervalle de temps dans laquelle il y aura au moins une mort
		// par exemple si l'iteration dure une seconde et que l'on doit avoir 4 morts,
		//             on aura un intervalle de 1/4 : un mort pour chaque intervalle de 25 sec
		private function startDeathTimer() : void {
			m_timerDeath.start( Math.random() * (m_iterTime / m_nbDeaths) );
		}
		//calcule un temps aléatoire pour la prochaine naissance
		private function startBirthTimer():void {
			m_timerBirth.start( Math.random() * (m_iterTime / m_nbBirths) );
		}
		//calcule le temps aléatoire pour la prochaine idée
		private function startIdeaTimer():void {
			m_timerIdea.start(Math.random() * m_iterTime);
		}
		public function getElapsedTime():Number {
			return m_timer.time;
		}
		
		public function getIterations() :int{
			return m_iterNumber;
		}
		
		public function changeDeathRatio(val:Number):void {
			m_ratioDeath += val;
			if (m_ratioDeath > 1)
				m_ratioDeath = 1;
		}
		
		public function changeBirthRatio(val:Number):void {
			m_ratioBirth += val;
			if (m_ratioBirth > 1)
				m_ratioBirth = 1;
		}
		
		public function update() :void {
			//si le timer principal de l'itération est terminé
			if (m_timer.finished && !m_currentIdea) {
				//incrémenter le nombre d'itérations
				m_iterNumber++;
				
				m_iterationTick = true;
				//relancer le timer
				restart();
			}
			
			//GESTION MORTS
			//Si le timer de mort arrive a échéance
			if ( (m_timerDeath.finished) && (m_countDeaths < m_nbDeaths) ) {
				
				var gotBlobby:Boolean = false; // a true si on a trouvé un blobby a supprimer
				var indexDelete:int; //index du blobby a supprimer
				
				while(!gotBlobby){
					//choisir un blobby au hasard
					indexDelete = Math.random() * (m_planet.getBlobbies().length -1);
					//si le blobby n'est pas invincible
					if(! m_planet.getBlobbies()[indexDelete].isInvincible()){
						gotBlobby = true;
					}
				}
				//supprimer le blobby
				m_planet.removeBlobbyAt(indexDelete);
				//incrémentere le compteur de morts
				m_countDeaths++;
				//redémarrer le timer pour les morts
				startDeathTimer();
			}
			
			//GESTION DES NAISSANCES
			//si le timer de naissances arrive a échéance
			if ( (m_timerBirth.finished) && (m_countBirths < m_nbBirths) ) 
			{
				//créer un nouveau blobby
				var blobby:Blobby = new Blobby(Math.random() * 360, m_planet.radius(), m_planet);
				//le rendre invisible
				blobby.visible = false;
				
				//chercher un blobby inoccupé pour la mitose
				var gotBlob:Boolean = false; // a true si on a trouvé un blobby a supprimer
				var indexCreate:int;
				while(!gotBlob){
					//choisir un blobby au hasard
					indexCreate = Math.random() * (m_planet.getBlobbies().length -1);
					//si le blobby n'est pas occupé
					if(! m_planet.getBlobbies()[indexCreate].isBusy()){
						gotBlob = true;
					}
				}
				//allouer le blobby a créer au blobby source
				m_blobbies[indexCreate].setBlobbyBirth(blobby);
				//ajouter le blobby a la liste
				m_blobbies.push(blobby);
				//ajouter le blobby a la scene
				m_scene.add(blobby);
				//incrémenter le compteur de naissances
				m_countBirths++;
				//redémarrer le timer
				startBirthTimer();
			}
			
			//GESTION DES IDEES
			//si le timer à idée est terminé et qu'aucune idée n'est encore créée
			if (m_timerIdea.finished && !m_currentIdea)
				createIdea();//creer une idée
				
			//si une idée est en cours	
			if (m_currentIdea) {
				//et qu'elle a été diffusée
				if (m_currentIdea.getState() == "spread") {
					//on applique les changements sur l'environnement
					m_ratioBirth += m_currentIdea.getBirthEffect();
					m_ratioDeath += m_currentIdea.getDeathEffect();
					trace(m_ratioBirth, m_ratioDeath);
					//on la supprime de la liste
					m_ideas.splice(m_ideas.indexOf(m_currentIdea), 1);
					//on la supprime de la scene
					m_currentIdea.destroy();
					m_currentIdea = null;
					//mettre le timer en pause
					m_timerIdea.pause();
				}
			}
		}
		
		public function cycleFinished():Boolean
		{
			var m_TMPState:Boolean = m_iterationTick;
			m_iterationTick = false;
			return m_TMPState;
		}
		
	}

}