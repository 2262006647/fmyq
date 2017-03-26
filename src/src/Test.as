package
{
	import com.junlas.engine.map.CharacterController;
	import com.junlas.engine.map.CharacterObject;
	import com.junlas.engine.map.GraphicsResource;
	import com.junlas.engine.map.MapCharacterAction;
	import com.junlas.engine.map.RenderCharacter;
	import com.junlas.engine.map.StaticClass;
	import com.junlas.engine.map.scene.MapCamera;
	import com.junlas.engine.map.scene.MapRoleMethod;
	import com.junlas.engine.map.scene.MapScene;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import mx.utils.StringUtil;

	
	[SWF(backgroundColor="#000000", frameRate="60", quality="LOW", width="800", height="600")]
	public class Test extends Sprite
	{
		[Embed(source="../skins/ShenXianDaoDemo_miniJPG.jpg")]
		public var ShenXianDaoDemo_miniJPG:Class;
		[Embed(source="../skins/ShenXianDaoDemo_ZumaClass.png")]
		public var ShenXianDaoDemo_ZumaClass:Class;
		
		public var bg:Bitmap;
		private var urlLoader:URLLoader;
		private var mapscene:MapScene;
		private var mapCamera:MapCamera;
		public function Test()
		{
			super();
			bg = new ShenXianDaoDemo_miniJPG;
			this.addChild(bg);
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			bg.width = 2500;
			bg.height = 650;	
			addEventListener(Event.ADDED_TO_STAGE, this.onInit);
		}
		private function onInit(evt:Event):void{
			StaticClass.stage = this.stage;
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, this.onLoaded);
			urlLoader.load(new URLRequest("../assets/map.css"));			
			return;
		}
		protected function onLoaded(event:Event):void{
			var line:String;
			var cells:Array;
			urlLoader.removeEventListener(Event.COMPLETE, this.onLoaded);
			var grid:Array = [];
			var data:String = urlLoader.data;
			var lines:Array = data.split("\n");
			var i:int;
			while (i < lines.length) {
				line = lines[i];
				if (this.isDefinition(line)){
					this.parseDefinition(line);
				} else {
					if (((!(this.lineIsEmpty(line))) && (!(this.isComment(line))))){
						cells = line.split(" ");
						grid.push(cells);
					};
				};
				i++;
			};
			mapscene = new MapScene(grid, 160);
			addChild(mapscene);
			mapscene.addMiniMapResource(bg);
			mapscene.addLoadMapResource("../assets/map.swf");
			mapCamera = new MapCamera(mapscene);	
			
			var charStandByPath:String = "../assets/stand.png";
			var charWalkPath:String = "../assets/walk.png";
			var charRunPath:String = "../assets/run.png";
			var charStandXml:XML = <data X="-28" Y="-129" dir="-1" Frame="10" Width="49" Height="133" Time="100" NameX="1" NameY="-133" shadowX="100" shadowY="100" hitWidth="50" hitHeight="40" action="0"/>;
			var charRunXml:XML = <data X="-48" Y="-117" dir="1" Frame="14" Width="103" Height="124" Time="40" NameX="27" NameY="-126" shadowX="130" shadowY="130" hitWidth="50" hitHeight="40" action="0"/>;
			var ch:CharacterController = new CharacterController(this.mapscene, MapRoleMethod.Mouse);
			var charObj:CharacterObject = new CharacterObject(ch);
			var gr:GraphicsResource = new GraphicsResource();
			gr.addLoadResource1(charStandByPath, charStandXml, MapCharacterAction.Stand);
			gr.addLoadResource1(charRunPath, charRunXml, MapCharacterAction.Run);
			charObj.grahpicsRes = gr;
			charObj.render = new RenderCharacter();
			charObj.setPos(500, 226);
			charObj.setName("junlas");
			charObj.setSpeed(10);
			charObj.directionNum = charObj.Default_Direction.StandBy;
			mapscene.addObject(charObj);
			mapCamera.focus(charObj);			
			return;
		}
		private function parseDefinition(line:String):void{
			var key:String;
			var val:String;
			var tokens:Array = line.split(" ");
			tokens.shift();
			var symbol:String = (tokens.shift() as String);
			var definition:Object = new Object();
			var i:int;
			while (i < tokens.length) {
				key = tokens[i].split(":")[0];
				val = tokens[i].split(":")[1];
				definition[key] = val;
				i++;
			};
			this.setTileType(symbol, definition);
		}
		public function setTileType(symbol:String, definition:Object):void{
		}
		private function isDefinition(line:String):Boolean{
			return ((line.indexOf("#") == 0));
		}
		private function lineIsEmpty(line:String):Boolean{
			var newLine:String = StringUtil.trim(line);
			if (newLine != ""){
				return (false);
			};
			return (true);
		}
		private function isComment(line:String):Boolean{
			return ((line.indexOf("//") == 0));
		}
		private function onComplete(e:Event):void{
			trace("==完成了==");
		}		
	}
}