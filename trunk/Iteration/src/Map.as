package  
{
	import flash.display.GraphicsStroke;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import Game.States.PlayState;
	import Globals.GameParams;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author ...
	 */
	public class Map extends EventDispatcher
	{
		public var m_xml:XML;
		
		public var iterationTime:Number;
		public var natalite:Number;
		public var mortalite:Number;
		public var convertRate:Number;
		
		public var scrollTime:Number;
		
		public var zoom:Number;
		public var zoomMin:Number;
		public var zoomMax:Number;
		public var zoomSpeed:Number;
		public var zoomSpeedUp:Number;
		
		public var m_planetSize:Number;
		public var m_planetResources:int;
		public var m_crackFadeOutTimer:int;
		public var m_crackShakeForce:Number;
		public var m_crackShakeDuration:Number;
		
		public var m_blobbyLifetime:int;
		public var m_blobbySpeed:Number;
		public var m_blobbyInitNb:int;
		public var m_blobbyDiscussTime:Number;
		public var m_blobbyPanicTime:Number;
		public var m_blobbyRecycledResources:int;
		public var m_convertTime:Number;
		
		public var m_treeNumber:int;
		public var m_treeBirthTime:int;
		public var m_treeBirthRandom:int;
		public var m_treeNbFruitMax:int;
		public var m_treeLifetime:int;
		public var m_treeFruitResources:Number;
		
		public var cloudsNumber:uint;
		public var m_cloudsBirthTime:int;
		public var m_cloudsBirthRandom:int;
		public var m_cloudsDistance:int;
		public var m_cloudsDistanceRandom:int;
		public var cloudsScale:Number;
		public var rainDistance:Number;
		public var cloudSpeed:Number;
		
		public var m_meteorNbByCycle:int;
		public var m_meteorSpeed:Number;
		public var m_meteorZone:Number;
		public var m_meteorZonePanic:Number;
		public var m_meteorDistance:Number;
		
		public var m_ideaEffect:Object;
		public var m_paix:Array = new Array();
		public var m_guerre:Array = new Array();
		public var m_religion:Array = new Array();
		public var m_fanatisme:Array = new Array();
		public var m_maladie:Array = new Array();
		public var m_medecine:Array = new Array();
		
		
		public var m_soundFadeInTime:Number;
		public var m_soundFadeOutTime:Number;
		public var m_soundRessourcesLow:Number;
		public var m_soundRessourcesHigh:Number;
		
		public var m_soundIdeaVolume:Number;
		public var m_soundDeathMeteorVolume:Number;
		public var m_soundLifeMeteorVolume:Number;
		public var m_soundMeteorTimer:Number;
		public var m_volumeMusic:Number;
		
		public var m_crackZone:Number;
		
		public var m_loaded:Boolean;
		
		public function Map(url:String) 
		{
			GameParams.map = this;
			m_loaded = false;
			loadXML(url);
		}
		
		private function loadXML(url:String):void 
		{
			var request:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load(request);
		}
		
		private function onComplete(e:Event):void
		{
			m_xml = new XML(e.target.data);
			
			iterationTime = m_xml.iteration.@time;
			mortalite = m_xml.iteration.@mortalite;
			natalite = m_xml.iteration.@natalite;
			convertRate = m_xml.iteration.@convertRate;
			
			scrollTime = m_xml.scroll.@time;
			
			zoomMin = m_xml.zoom.@min;
			zoomMax = m_xml.zoom.@max;
			zoom = m_xml.zoom.@actual;
			zoomSpeed = m_xml.zoom.@speed;
			zoomSpeedUp = m_xml.zoom.@speedUp;
			
			m_planetSize = m_xml.planet.@size;
			m_planetResources = m_xml.planet.@resources;
			m_crackFadeOutTimer = m_xml.planet.@crackTimeOut;
			m_crackShakeForce = m_xml.planet.@shakeForce;
			m_crackShakeDuration = m_xml.planet.@shakeDuration;
			m_crackZone = m_xml.planet.@crackZone; 
			
			m_blobbyLifetime = m_xml.blobby.@lifetime;
			m_blobbySpeed = m_xml.blobby.@speed;
			m_blobbyInitNb = m_xml.blobby.@initNb;
			m_blobbyDiscussTime = m_xml.blobby.@discussTime;
			m_blobbyPanicTime = m_xml.blobby.@panicTime;
			m_blobbyRecycledResources = m_xml.blobby.@recycledResources;
			m_convertTime = m_xml.blobby.@convertTime;
			
			m_treeNumber = m_xml.tree.@number;
			m_treeBirthTime = m_xml.tree.@birthTime;
			m_treeBirthRandom = m_xml.tree.@birthRandom;
			m_treeLifetime = m_xml.tree.@lifetime;
			m_treeNbFruitMax = m_xml.tree.@nbFruitMax;
			m_treeFruitResources = m_xml.tree.@fruitResources;
			
			cloudsNumber = m_xml.cloud.@number;
			m_cloudsBirthTime = m_xml.cloud.@birthTime;
			m_cloudsBirthRandom = m_xml.cloud.@birthRandom;
			m_cloudsDistance = m_xml.cloud.@distance;
			m_cloudsDistanceRandom = m_xml.cloud.@distanceRandom;
			cloudsScale = m_xml.cloud.@scale;
			rainDistance = m_xml.cloud.@rainDistance;
			cloudSpeed = m_xml.cloud.@speed;
			
			m_meteorNbByCycle = m_xml.meteor.@nbByCycle;
			m_meteorSpeed = m_xml.meteor.@speed;
			m_meteorZone = m_xml.meteor.@zone;
			m_meteorZonePanic = m_xml.meteor.@zonePanic;
			m_meteorDistance = m_xml.meteor.@distance;
			
			//idées
			m_paix.push(m_xml.idee.@paixMort); m_paix.push(m_xml.idee.@paixNat);
			m_guerre.push(m_xml.idee.@guerreMort); m_guerre.push(m_xml.idee.@guerreNat);
			m_religion.push(m_xml.idee.@religionMort); m_religion.push(m_xml.idee.@religionNat);
			m_fanatisme.push(m_xml.idee.@fanatismeMort); m_fanatisme.push(m_xml.idee.@fanatismeNat);
			m_medecine.push(m_xml.idee.@medecineMort); m_medecine.push(m_xml.idee.@medecineNat);
			m_maladie.push(m_xml.idee.@maladieMort); m_maladie.push(m_xml.idee.@maladieNat);
			
			m_ideaEffect = { 
							paix : m_paix,
							guerre : m_guerre,
							fanatisme : m_fanatisme,
							medecine : m_medecine,
							maladie : m_maladie,
							religion : m_religion
				
							};
							
			// Sound
			m_soundFadeInTime = m_xml.sound.@fadeInTime;
			m_soundFadeOutTime = m_xml.sound.@fadeOutTime;
			m_soundRessourcesLow = m_xml.sound.@ressourcesLow;
			m_soundRessourcesHigh = m_xml.sound.@ressourcesHigh;
			
			m_soundIdeaVolume = m_xml.sound.@volumeIdea;
			m_soundMeteorTimer = m_xml.sound.@meteorTimer;
			m_soundDeathMeteorVolume = m_xml.sound.@volumeDeathMeteor;
			m_soundLifeMeteorVolume = m_xml.sound.@volumeLifeMeteor;
			m_volumeMusic = m_xml.sound.@volumeMusic;
			
			m_loaded = true;
		}
	}
}