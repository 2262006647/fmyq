//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.geom.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import com.junlas.engine.map.*;
    import com.junlas.engine.map.scene.*;
    import mx.utils.*;

    public class ShenXianDaoDemo extends Sprite {

		[Embed(source="../skins/ShenXianDaoDemo_miniJPG.jpg")]
		public var ShenXianDaoDemo_miniJPG:Class;
		[Embed(source="../skins/ShenXianDaoDemo_ZumaClass.png")]
		public var ShenXianDaoDemo_ZumaClass:Class;
//		[Embed(source="../assets/ShenXianDaoDemo_ZumaClass.png")]
//		public var ShenXianDaoDemo_ZumaXML:Class;
        private var miniJPG:Class;
        private var _xml:XML;
        private var ZumaClass:Class;
        private var ZumaXML:Class;
        private var _solidRect:Rectangle;
        private var _bgBitmap:Bitmap;
        private var _urlLoader:URLLoader;
        private var _mapscene:MapScene;
        private var _mapCamera:MapCamera;

        public function ShenXianDaoDemo(){
            this.miniJPG = ShenXianDaoDemo_miniJPG;
            this._xml = <data X="-30" Y="-43" dir="1" Frame="90" Width="61" Height="50" Time="70"/>
            ;
//            this.ZumaClass = ShenXianDaoDemo_ZumaClass;
//            this.ZumaXML = ShenXianDaoDemo_ZumaXML;
            this._solidRect = new Rectangle(0, 0, 1250, 650);
            super();
            this.stage.scaleMode = StageScaleMode.NO_SCALE;
            this.stage.align = StageAlign.TOP_LEFT;
            addEventListener(Event.ADDED_TO_STAGE, this.onInit);
            this._bgBitmap = new this.miniJPG();
            this._bgBitmap.width = 2500;
            this._bgBitmap.height = 650;
        }
        private function onInit(e:Event):void{
            this._urlLoader = new URLLoader();
            this._urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
            this._urlLoader.addEventListener(Event.COMPLETE, this.onLoaded);
            this._urlLoader.load(new URLRequest("assets/map.css"));
        }
        protected function onLoaded(event:Event):void{
            var line:String;
            var cells:Array;
            StaticClass.stage = this.stage;
            this._urlLoader.removeEventListener(Event.COMPLETE, this.onLoaded);
            var grid:Array = [];
            var data:String = this._urlLoader.data;
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
            var charStandByPath:String = "assets/stand.png";
            var charWalkPath:String = "assets/walk.png";
            var charRunPath:String = "assets/run.png";
            var charStandXml:XML = <data X="-28" Y="-129" dir="-1" Frame="10" Width="49" Height="133" Time="100" NameX="1" NameY="-133" shadowX="100" shadowY="100" hitWidth="50" hitHeight="40" action="0"/>
            ;
            var charRunXml:XML = <data X="-48" Y="-117" dir="1" Frame="14" Width="103" Height="124" Time="40" NameX="27" NameY="-126" shadowX="130" shadowY="130" hitWidth="50" hitHeight="40" action="0"/>
            ;
            this._mapscene = new MapScene(grid, 260);
            this.addChild(this._mapscene);
            this._mapscene.addMiniMapResource(this._bgBitmap);
            this._mapscene.addLoadMapResource("assets/map.swf");
            this._mapCamera = new MapCamera(this._mapscene);
            var ch:CharacterController = new CharacterController(this._mapscene, MapRoleMethod.Mouse);
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
            this._mapscene.addObject(charObj);
            this._mapCamera.focus(charObj);
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
        protected function onResize(event:Event):void{
            var px:Number;
            var py:Number;
            if ((((this.stage.stageWidth > 0)) && ((this.stage.stageHeight > 0)))){
                px = ((this.stage.stageWidth - this._solidRect.width) / 2);
                py = ((this.stage.stageHeight - this._solidRect.height) / 2);
                this._solidRect.x = px;
                this._solidRect.y = py;
                this.scrollRect = this._solidRect;
                trace(this.x, this.y, this.width, this.height);
                trace(this._solidRect.x, this._solidRect.y, this._solidRect.width, this._solidRect.height);
            };
        }

    }
}//package 
