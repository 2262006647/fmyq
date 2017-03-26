//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map {
    import flash.utils.*;
    import com.junlas.engine.map.resource.*;
    import flash.display.*;
    import flash.events.*;
    import junlas.loadqueue.*;

    public class GraphicsResource {

        private var _actionDict:Dictionary;

        public function GraphicsResource(){
            super();
            this._actionDict = new Dictionary();
            this._actionDict[MapCharacterAction.Stand] = new ActionResource(MapCharacterAction.Stand);
            this._actionDict[MapCharacterAction.Run] = new ActionResource(MapCharacterAction.Run);
        }
        public function getActionResource(characterActionType:String):ActionResource{
            return (this._actionDict[characterActionType]);
        }
        public function setName(n:String):void{
            var actionRes:ActionResource;
            for each (actionRes in this._actionDict) {
                actionRes.setName(n);
            };
        }
        public function addLoadResource(resPngPath:String, resXMLPath:String, action:String):void{
            var loader:* = null;
            var resPngPath:* = resPngPath;
            var resXMLPath:* = resXMLPath;
            var action:* = action;
            loader = new LoaderManager();
            loader.registerSinlgeLoader(resPngPath, "image", "resPng", null);
            loader.registerSinlgeLoader(resXMLPath, "xml", "resXml", null);
            loader.addEventListener(LoaderMsgEvent.EventName_Complete, function (e:Event):void{
                var imageFile:Bitmap = loader.getImageDataByResNameOrUrl("resPng");
                var xmlFile:XML = loader.getXMLDataByResNameOrUrl("resXml");
                addLoadResource2(imageFile.bitmapData, xmlFile, action);
                loader.destroyQueue(true, true);
            });
            loader.addEventListener(LoaderMsgEvent.EventName_Error, function (e:Event):void{
                trace("请确认加载路径:", resPngPath, resXMLPath);
            });
            loader.startLoad();
        }
        public function addLoadResource1(resPngPath:String, resXML:XML, action:String):void{
            var loader:* = null;
            var resPngPath:* = resPngPath;
            var resXML:* = resXML;
            var action:* = action;
            var ar:* = this._actionDict[action];
            ar.setResXml(resXML);
            loader = new LoaderManager();
            loader.registerSinlgeLoader(resPngPath, "image", "resPng", null);
            loader.addEventListener(LoaderMsgEvent.EventName_Complete, function (e:Event):void{
                var imageFile:Bitmap = loader.getImageDataByResNameOrUrl("resPng");
                addLoadResource2(imageFile.bitmapData, resXML, action);
                loader.destroyQueue(true, true);
            });
            loader.addEventListener(LoaderMsgEvent.EventName_Error, function (e:Event):void{
                trace("请确认加载路径:", resPngPath);
            });
            loader.startLoad();
        }
        public function addLoadResource2(resPng:BitmapData, resXML:XML, action:String):void{
            var asr:ActionStandResource;
            var arr:ActionRunResource;
            var ar:ActionResource = this._actionDict[action];
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
        }
        public function addLoadResource3(resPngPath:String, frames:int, action:String, fps:int=12):void{
        }
        public function addLoadResource4(resPng:BitmapData, frames:int, action:String, fps:int=12):void{
        }

    }
}//package com.junlas.engine.map 
