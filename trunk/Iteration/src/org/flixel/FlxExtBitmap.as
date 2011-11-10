package org.flixel {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author jaywalker
	 */
	dynamic public class FlxExtBitmap {

		private var _loader:Loader;
		private var _path:String;
		private var _bitmap:Bitmap;
		private var _complete:Boolean;

		public function FlxExtBitmap(path:String = null):void {
			_path = path;
		}

		public function load():void {
			_loader = new Loader();
			_complete = false;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onBitmapLoadComplete);
			_loader.load(new URLRequest(_path));
		}

		public function getAdvancementInPercent():uint {
			if(_loader.contentLoaderInfo != null) {
				var result:Number = Number(_loader.contentLoaderInfo.bytesLoaded) / Number(_loader.contentLoaderInfo.bytesTotal);
				if(isNaN(result)) {
					return 0;
				} else {
					return uint(result * 100);
				}
			} else
				return 0;
		}

		public function loadComplete():Boolean {
			return _complete;
		}

		private function _onBitmapLoadComplete(event:Event):void {
			_bitmap = Bitmap(LoaderInfo(event.target).content);
			_complete = true;
		}

		public function get path():String {
			return _path;
		}

		public function get bitmap():Bitmap {
			return _bitmap;
		}

		public function set path(value:String):void {
			_path = value;
		}

	}
}