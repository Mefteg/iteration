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
		
		
		public var zoom:Number;
		public var zoomMin:Number;
		public var zoomMax:Number;
		
		public var m_planetSize:Number;
		public var m_planetResources:int;
		
		public var m_blobbyLifetime:int;
		public var m_blobbySpeed:Number;
		public var m_blobbyInitNb:int;
		
		public var m_treeNumber:int;
		public var m_treeNbFruitMax:int;
		public var m_treeLifetime:int;
		
		public var cloudsNumber:uint;
		public var cloudsScale:Number;
		
		public var m_meteorNbByCycle:int;
		public var m_meteorSpeed:Number;
		
		public var m_ideaEffect:Object;
		public var m_paix:Array = new Array();
		public var m_guerre:Array = new Array();
		public var m_religion:Array = new Array();
		public var m_fanatisme:Array = new Array();
		public var m_maladie:Array = new Array();
		public var m_medecine:Array = new Array();
		
		
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
			
			zoomMin = m_xml.zoom.@min;
			zoomMax = m_xml.zoom.@max;
			zoom = m_xml.zoom.@actual;
			
			m_planetSize = m_xml.planet.@size;
			m_planetResources = m_xml.planet.@resources;
			
			m_blobbyLifetime = m_xml.blobby.@lifetime;
			m_blobbySpeed = m_xml.blobby.@speed;
			m_blobbyInitNb = m_xml.blobby.@initNb;
			
			m_treeNumber = m_xml.tree.@number;
			m_treeLifetime = m_xml.tree.@lifetime;
			m_treeNbFruitMax = m_xml.tree.@nbFruitMax;
			
			cloudsNumber = m_xml.cloud.@number;
			cloudsScale = m_xml.cloud.@scale;
			
			m_meteorNbByCycle = m_xml.meteor.@nbByCycle;
			m_meteorSpeed = m_xml.meteor.@speed;
			
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
			
			m_loaded = true;
		}
	}
}