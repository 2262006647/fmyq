package
{
	import com.junlas.engine.map.CharacterController;
	import com.junlas.engine.map.StaticClass;
	import com.junlas.engine.map.astar.Node;
	import com.junlas.engine.map.scene.MapCamera;
	import com.junlas.engine.map.scene.MapScene;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import junlas.math.mVector;
	
	import mx.utils.StringUtil;
	
	
	[SWF(backgroundColor="#000000", frameRate="60", quality="LOW", width="800", height="600")]
	public class MapDemo extends Sprite
	{
		[Embed(source="../skins/ShenXianDaoDemo_miniJPG.jpg")]
		public var ShenXianDaoDemo_miniJPG:Class;
		[Embed(source="../skins/ShenXianDaoDemo_ZumaClass.png")]
		public var ShenXianDaoDemo_ZumaClass:Class;
		
		public var bg:Bitmap;		
		public var urlLoader:URLLoader;
		public var mapscene:MapScene;
		private var mapCamera:MapCamera;
		
		private var currPos:mVector;
		private var clickPos:mVector;
		private var xDire:mVector;
		private var currPath:Array=[];
		private var currIndex:int;
		private var isWalk:Boolean = false;
		public var goPathStepSpeed:uint = 10;
		
		public function MapDemo()
		{
			currPos = new mVector();
			clickPos = new mVector();
			xDire = new mVector(1, 0);
			addEventListener(Event.ADDED_TO_STAGE, this.onInit);
			addEventListener(Event.ENTER_FRAME, this.enterFrameRun);
		}
		private function onInit(e:Event):void{
			StaticClass.stage = stage;
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, this.onLoaded);
			urlLoader.load(new URLRequest("../assets/map.css"));
			bg = new ShenXianDaoDemo_miniJPG;
			bg.width = 2500;
			bg.height = 650;				
		}
		private function enterFrameRun(e:Event):void{
			characterGo();
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
			mapscene = new MapScene(grid, 260);
			addChild(mapscene);
			mapscene.addMiniMapResource(bg);
			mapscene.addLoadMapResource("../assets/map.swf");
			mapCamera = new MapCamera(mapscene);
			mapscene.addEventListener(MouseEvent.CLICK, this.onClick);
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
		private function onClick(e:MouseEvent):void{
			mapscene.clickRealityPos(clickPos);
			mapscene.setStartNode(currPos);
			mapscene.setEndNode(clickPos);
			var findPath:Array = mapscene.getPath();
			if (findPath){
				currPath = findPath;
				currIndex = 1;
				isWalk = true;
				trace("path:",findPath);
			} else {
				trace("未找到可寻路径");
			};
		}		
		private function characterGo():void{
			if(!nextPos)return;
			var mv:mVector = nextPos.minus(currPos);
			mv.length = goPathStepSpeed;
			currPos.plusEquals(mv);
			(mapCamera)&&mapCamera.cameraFocus(currPos.x, currPos.y);
			
		}	
		public function get nextPos():mVector{
			var mv:mVector=new mVector;
			var nextNode:Node;
			var node:Node = currPath[currIndex];
			if (!(node)){
				isWalk = false;
				mv.copyFrom(currPos);
				return (null);
			};
			mv.setTo(((node.y + 0.5) * StaticClass.gridCellSize), ((node.x + 0.5) * StaticClass.gridCellSize));
			if (mv.minusEquals(currPos).length < goPathStepSpeed){
				currIndex++;
				if (currIndex >= currPath.length){
					isWalk = false;
					mv.copyFrom(currPos);
					return (null);
				};
				nextNode = currPath[currIndex];
				mv.setTo(((nextNode.y + 0.5) * StaticClass.gridCellSize), ((nextNode.x + 0.5) * StaticClass.gridCellSize));
			} else {
				mv.setTo(((node.y + 0.5) * StaticClass.gridCellSize), ((node.x + 0.5) * StaticClass.gridCellSize));
			};
			return (mv);
		}		
	}
}
/**
 * 
 * MapScene
 * MapCamera
 * CharacterController
 * CharacterObject
 * */