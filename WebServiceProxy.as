package {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.rpc.soap.*;
	import mx.rpc.events.*;
	import mx.rpc.AbstractOperation;
	
	
	/**
	 * ...
	 * @author tantanix
	 */
	public class WebServiceProxy extends EventDispatcher {
		static public const RANDOM_NUMBER_GENERATED:String = "randomNumberGenerated";
		
		
		static public const READY:String = "ready";
		
		
		private var _ws:WebService;
		
		
		private var _so:AbstractOperation;
		
		
		private var _randomInt:int;
		
		
		private var _isReady:Boolean = false;
		
		
		public function WebServiceProxy() {
			_ws = new WebService();
		}
		
		
		public function initialize():void {
			_ws.loadWSDL(Settings.API_URL + "?WSDL");
			_ws.addEventListener(LoadEvent.LOAD, ws_load);
			trace("Loading WSDL");
		}
		
		
		public function getRandomNumber():void {
			try{
				if (_isReady) {
					_so.send(Settings.USERNAME, Settings.PASSWORD);
				} else {
					throw new Error("Web service is not yet ready");
				}
			}
			catch (err:Error) 
			{
				
			}
		}
		
		
		public function dispose():void {
			_so.removeEventListener(FaultEvent.FAULT, so_fault);
			_so.removeEventListener(ResultEvent.RESULT, so_result);
		}
		
		
		private function ws_load(e:LoadEvent):void {
			_ws.removeEventListener(LoadEvent.LOAD, ws_load);
			
			trace("WSDL Load successful");
			_isReady = true;
			
			_so = _ws.getOperation("GetRandomNumber");
			_so.addEventListener(FaultEvent.FAULT, so_fault);
			_so.addEventListener(ResultEvent.RESULT, so_result);
			
			this.dispatchEvent(new Event(WebServiceProxy.READY));
		}
		
		
		private function so_result(e:ResultEvent):void {
			trace("result: " + e.result);
			_randomInt = int(e.result);
			this.dispatchEvent(new Event(WebServiceProxy.RANDOM_NUMBER_GENERATED));
		}
		
		
		private function so_fault(e:FaultEvent):void {
			throw new Error(e.fault);
		}
		
		
		public function getrandomInt():int {
			return _randomInt;
		}
		
		
		public function get isReady():Boolean {
			return _isReady;
		}
	
	}

}