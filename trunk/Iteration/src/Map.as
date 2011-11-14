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
		public var m_planetSize:Number;
		public var m_planetResources:int;
		public var m_blobbyLifetime:int;
		public var m_blobbySpeed:Number;
		public var m_blobbyInitNb:int;
		public var m_treeNbFruitMax:int;
		public var m_treeLifetime:int;
		public var m_meteorNbByCycle:int;
		public var m_meteorSpeed:Number;
		
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
			m_planetSize = m_xml.planet.@size;
			m_planetResources = m_xml.planet.@resources;
			m_blobbyLifetime = m_xml.blobby.@lifetime;
			m_blobbySpeed = m_xml.blobby.@speed;
			m_blobbyInitNb = m_xml.blobby.@initNb;
			m_treeLifetime = m_xml.tree.@lifetime;
			m_treeNbFruitMax = m_xml.tree.@nbFruitMax;
			m_meteorNbByCycle = m_xml.meteor.@nbByCycle;
			m_meteorSpeed = m_xml.meteor.@speed;
			
			m_loaded = true;
		}
	}
}