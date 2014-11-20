package  
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ...
	 */
	public class URLredirect 
	{
		static public const READY:String = "ready";
		public var myXML:XML;
		public var myLoader:URLLoader = new URLLoader();
		static public var link:String = "";
			
		public function URLredirect() 
		{			
			myLoader.load(new URLRequest("urlredirect.xml"));
			myLoader.addEventListener(Event.COMPLETE, processXML);
			trace("URL Loading");
		}
		
		private function processXML(e:Event):void 
		{
			try 
			{
				var myXML = new XML(e.target.data);
				//trace(myXML.URL);
				link = myXML.URL;
				trace("URL Loaded");
			}
			catch (err:Error) 
			{
				
			}
		}
		
		public function getLink():String
		{
			return link;
		}
		
	}

}