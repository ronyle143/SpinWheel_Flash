package 
{
	import fl.motion.Color;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat; 
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.utils.Timer;
	
	public class SpinWheel extends Sprite
	{
		public var STAGE_SIZE:Number = 614;
		public var wheel:Sprite = new SwWheel;
		public var Arrow:Sprite = new arr;
		public var Bits:SimpleButton = new bits;
		public var Shadow:Sprite = new shad;
		
		public var Result:TextField = new TextField;
		
		public var holder:Sprite = new Sprite();  
		public var holder1:Sprite = new Sprite(); 
		public var shadowholder:Sprite = new Sprite();
		public var mybtn:Sprite = new Sprite(); 
		
		public var PICKER:int = 1;
		
		public var rd:URLredirect = new URLredirect();
		public var proxy:WebServiceProxy = new WebServiceProxy();
		
		public var spinning:Boolean = false;
		public var spinTween:Tween;
		public var aniWin:Tween;
		public var startTime:Number;
		
		public function SpinWheel()
		{
			/*addChild(wheel);
			addChild(arw);
			addChild(btn_def);
			addChild(btn_alt);*/
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			
			proxy.initialize();
			proxy.addEventListener(WebServiceProxy.READY, generateUI);
			//generateUI();
		}

		private function loaderComplete(e:Event):void 
		{
			trace("LoaderComplete");
			var ping:TextField = new TextField;
			ping.text = "";
			ping.width = 614;
			var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
			
			Settings.USERNAME = paramObj.USERNAME;
			Settings.PASSWORD = paramObj.PASSWORD;
			Settings.API_URL = paramObj.API_URL;
			/*Settings.USERNAME = "spinuser";
			Settings.PASSWORD = "unetof66";
			Settings.API_URL = "https://secure.playersrewardscard.com/ws/spin";*/
			trace(Settings.USERNAME,Settings.PASSWORD,Settings.API_URL);
			ping.text = "UN: "+Settings.USERNAME + "\nPW:"+Settings.PASSWORD + "\nAU:"+Settings.API_URL; 
	//addChild(ping);
		}
		
		private function generateUI(e:Event):void 
		//private function generateUI():void 
		{
			trace("READY!");
			holder1.addChild(wheel);
			wheel.x= wheel.width/2;
			wheel.y= wheel.height/2;
			
			holder.addChild(holder1);
			
			mybtn.addChild(Bits);
			Bits.x = STAGE_SIZE/2;
			Bits.y = STAGE_SIZE/2;
			holder.addChild(mybtn);
			
			holder.addChild(Arrow);
			Arrow.x = STAGE_SIZE;
			Arrow.y = STAGE_SIZE/2;
			
			var dropshadow:BlurFilter = new BlurFilter();
			Shadow.filters = [dropshadow];
			Shadow.x = STAGE_SIZE/2;
			Shadow.y = STAGE_SIZE/2;
			Shadow.alpha=0.5;
			shadowholder.addChild(Shadow);
			shadowholder.addChild(Result);
			shadowholder.visible = false;
			
			holder.addChild(shadowholder);
			addChild(holder);
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 150;
			myFormat.color = 0xffffff
			myFormat.font = "Haettenschweiler"
			myFormat.bold = true;
			Result.defaultTextFormat = myFormat;
			Result.text = "+$500";
			Result.autoSize = TextFieldAutoSize.CENTER;
			Result.x = (STAGE_SIZE - Result.width) / 2;
			Result.y = (STAGE_SIZE - Result.height) / 2;//15,45,10,0.5, 10.0, 10.0,1.0
			Result.mouseEnabled = false;
			mybtn.addEventListener(MouseEvent.CLICK, readyspin);
		}
		
		private function readyspin (e:MouseEvent):void {
			if (!spinning) {
				spinning = true;
				proxy.getRandomNumber();
				proxy.addEventListener(WebServiceProxy.RANDOM_NUMBER_GENERATED, spinIt);
				//spinIt();
			}
		}
		
		//private function spinIt():void 
		private function spinIt(e:Event):void 
		{
			
			if(proxy.getrandomInt() != 0){
				PICKER = proxy.getrandomInt();
				trace(PICKER);
				
				var gap:Number = 150;// default to $5
				if (PICKER == 6 || PICKER == 12) {
					trace("$500");
					Result.text = "+$500";
					gap = 0;
				}else
				if (PICKER == 5 || PICKER == 11) {
					trace("$100");
					Result.text = "+$100";
					gap = 60;
				}else
				if (PICKER == 4 || PICKER == 10) {
					trace("$50");
					Result.text = "+$50";
					gap = 120;
				}else
				if (PICKER == 3 || PICKER == 9) {
					trace("$20");
					Result.text = "+$20";
					gap = 90;
				}else
				if (PICKER == 2 || PICKER == 8) {
					trace("$10");
					Result.text = "+$10";
					gap = 30;
				}else{
					trace("$5");
					Result.text = "+$5";
					gap = 150;
				}
				
				var spinTime:Number=7;
				var endRot:Number=360*5 + gap;
				spinTween = new Tween(wheel, "rotation", Regular.easeOut, wheel.rotation, endRot, spinTime, true);
				spinTween.addEventListener(TweenEvent.MOTION_FINISH, spinTween_finished);
			}
		}
		
		private function spinTween_finished(e:TweenEvent):void
		{
			trace("[!] - spinTween_finished()");
			shadowholder.visible = true;
			Shadow.alpha=0.75;
			shadowholder.alpha=0;
			aniWin = new Tween(shadowholder, "alpha", Regular.easeIn, 0, 1, 0.5, true);
			var myTimer:Timer = new Timer(1000, 4);
			myTimer.addEventListener(TimerEvent.TIMER, timerListener);
			var tm:int = 0;
			function timerListener (e:TimerEvent):void {
				//do nothing
				trace("mark");
			}
			myTimer.start();
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, estaato);
		}
		
		private function estaato(e:TimerEvent):void 
		{
			aniWin = new Tween(shadowholder, "alpha", Regular.easeIn, 1, 0, 0.5, true);
			aniWin.addEventListener(TweenEvent.MOTION_FINISH, 
				function clearScrn(e:TweenEvent):void 
				{
					shadowholder.visible = false;
					spinning = false;
					navigateToURL(new URLRequest(URLredirect.link), "_self");
					
				}
			);
		}
	}//END
}