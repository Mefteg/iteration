package Utils 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Alexandre Laurent
	 */
	public class ResourceLoader extends EventDispatcher
	{
		public static const LOADED:String = "RESOURCE_LOADED";
		
		private var m_resources:Array;
		
		public function load(fileName:String):void 
		{
			var request:URLRequest = new URLRequest(fileName);
			var loader:URLLoader = new URLLoader();
			
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load(request);
		}
		
		private function onComplete(e:Event):void 
		{
			m_resources.push(e.target.data);
			
			dispatchEvent(new Event(LOADED, true));
		}
		
		public function countAvailableResources():int
		{
			return m_resources.length;
		}
		
		public function clear():void
		{
			while ( m_resources.length != 0 )
			{
				m_resources.pop();
			}
		}
		
		public function getResources():Array
		{
			return m_resources;
		}
		
		public function pop():Object
		{
			if ( m_resources.length != 0 )
			{
				return m_resources.pop();
			}

			return null;
		}
	}

}