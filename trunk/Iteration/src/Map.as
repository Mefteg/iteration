package  
{
	import flash.display.GraphicsStroke;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	/**
	 * ...
	 * @author ...
	 */
	public class Map extends EventDispatcher
	{
		public var m_xml:XML;
		public var m_planetSize:Number;
		
		public function Map(url:String) 
		{
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
		}
	}
}