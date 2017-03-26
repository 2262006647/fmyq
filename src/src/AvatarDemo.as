package
{
	import com.junlas.engine.map.MapCharacterAction;
	import com.junlas.engine.map.data.BitmapDataSourceClone;
	import com.junlas.engine.map.resource.ActionResource;
	import com.junlas.engine.map.resource.ActionRunResource;
	import com.junlas.engine.map.resource.ActionStandResource;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	[SWF(backgroundColor="#000000", frameRate="60", quality="LOW", width="800", height="600")]
	public class AvatarDemo extends Sprite
	{
		[Embed(source="../assets/run.png")]
		public var Run:Class;
		[Embed(source="../assets/stand.png")]
		public var Stand:Class;
		public var run:Bitmap;
		public var stand:Bitmap;
		public var run_ar:ActionResource;
		public var stand_ar:ActionResource;
		public var charStandXml:XML = <data X="-28" Y="-129" dir="-1" Frame="10" Width="49" Height="133" Time="100" NameX="1" NameY="-133" shadowX="100" shadowY="100" hitWidth="50" hitHeight="40" action="0"/>;
		public var charRunXml:XML = <data X="-48" Y="-117" dir="1" Frame="14" Width="103" Height="124" Time="40" NameX="27" NameY="-126" shadowX="130" shadowY="130" hitWidth="50" hitHeight="40" action="0"/>;
		public var actDic:Dictionary;
		
		public var test_bmp:Bitmap;
		
		public function AvatarDemo()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, this.onInit);
			addEventListener(Event.ENTER_FRAME, this.enterFrameRun);
		}
		private function onInit(e:Event):void{
			run = new Run;
			stand = new Stand;
			actDic = new Dictionary;
			actDic[MapCharacterAction.Stand] = new ActionResource(MapCharacterAction.Stand);
			actDic[MapCharacterAction.Run] = new ActionResource(MapCharacterAction.Run);	
			parseAction(MapCharacterAction.Run,(run as Bitmap).bitmapData,charRunXml);
			parseAction(MapCharacterAction.Stand,(stand as Bitmap).bitmapData,charStandXml);
			run_ar = actDic[MapCharacterAction.Run];
			trace(run_ar.toDebug());
			stand_ar = actDic[MapCharacterAction.Stand];
			trace(stand_ar.toDebug());
			test_bmp = new Bitmap;
			addChild(test_bmp);
			return;
		}
		private function parseAction(action:String,resPng:BitmapData,resXML:XML):void{
			var asr:ActionStandResource;
			var arr:ActionRunResource;
			var ar:ActionResource = actDic[action];
			ar.setResXml(resXML);
			ar.setResPng(resPng);
			switch (action){
				case MapCharacterAction.Stand:
					asr = new ActionStandResource(resPng, resXML);
					ar.setCoreRes(asr);
					break;
				case MapCharacterAction.Run:
					arr = new ActionRunResource(resPng, resXML);
					ar.setCoreRes(arr);
					break;
				default:
					trace("action未找到:", action);
			};
			return;
		}
		private function enterFrameRun(e:Event):void{
			render(run_ar);
			return;
		}
		private function render(ar:ActionResource):void{
			var bmdSC:BitmapDataSourceClone;
			if (ar._coreRes){
				bmdSC = ar.run();
			};
			if (bmdSC != null){
				//				ar.bitmapData = bmdSC.srcBitmapData;
				test_bmp.bitmapData = bmdSC.srcBitmapData;
			};
			//		    this.characterGo();				
			return;
		}
	}
}
/**
 * ActionResource        FrameBitmapData   BitmapDataSourceClone    
 *      ActionRunResource  
 *      ActionStandResource 
 * 
 * 
 * */