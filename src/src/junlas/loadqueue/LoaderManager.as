//Created by Action Script Viewer - http://www.buraks.com/asv
package junlas.loadqueue {
    import com.greensock.loading.*;
    import flash.system.*;
    import flash.display.*;
    import com.greensock.events.*;
    import com.greensock.loading.core.*;
    import flash.events.*;

    public class LoaderManager extends EventDispatcher {

        private static var _instance:LoaderManager;

        private var queue:LoaderMax;

        public function LoaderManager(qname:String="mainQueue", maxConn:uint=2){
            super();
            this.queue = new LoaderMax({
                name:qname,
                maxConnections:maxConn,
                onProgress:this.progressHandler,
                onChildComplete:this.onOneComplete,
                onComplete:this.completeHandler,
                onError:this.errorHandler
            });
        }
        public function registerLoaderXML(loaderXML:XML):void{
            var item:XML;
            var name:String;
            var url:String;
            var type:String;
            var itemList:XMLList = loaderXML["item"];
            var i:int;
            while (i < itemList.length()) {
                item = itemList[i];
                name = item.@name;
                url = item.@url;
                type = item.@type;
                if (type == "xml"){
                    this.queue.append(new XMLLoader(url, {name:name}));
                } else {
                    if (type == "swf"){
                        this.queue.append(new SWFLoader(url, {name:name}));
                    } else {
                        if (type == "image"){
                            this.queue.append(new ImageLoader(url, {name:name}));
                        };
                    };
                };
                i++;
            };
        }
        public function registerSinlgeLoader(url:String, type:String, name:String=null, context:LoaderContext=null):void{
            var xmlLoader:XMLLoader;
            var swfLoader:SWFLoader;
            var imageLoader:ImageLoader;
            if (type == "xml"){
                if (name != null){
                    xmlLoader = new XMLLoader(url, {
                        name:name,
                        context:context
                    });
                } else {
                    xmlLoader = new XMLLoader(url, {context:context});
                };
                this.queue.append(xmlLoader);
            } else {
                if (type == "swf"){
                    if (name != null){
                        swfLoader = new SWFLoader(url, {
                            name:name,
                            context:context
                        });
                    } else {
                        swfLoader = new SWFLoader(url, {context:context});
                    };
                    this.queue.append(swfLoader);
                } else {
                    if (type == "image"){
                        if (name != null){
                            imageLoader = new ImageLoader(url, {
                                name:name,
                                context:context
                            });
                        } else {
                            imageLoader = new ImageLoader(url, {context:context});
                        };
                        this.queue.append(imageLoader);
                    };
                };
            };
        }
        public function setResPriorityByName(name:String):void{
            LoaderMax.prioritize(name);
        }
        public function startLoad():void{
            this.queue.load();
        }
        public function getSWFInstanceByResNameOrUrl(resNameOrUrl:String):DisplayObject{
            var loader:Object = this.queue.getLoader(resNameOrUrl);
            if ((loader is SWFLoader)){
                return (SWFLoader(loader).rawContent);
            };
            return (null);
        }
        public function getClassNameByResNameOrUrl(resNameOrUrl:String, className:String):Class{
            var loader:Object = this.queue.getLoader(resNameOrUrl);
            if ((loader is SWFLoader)){
                return (SWFLoader(loader).getClass(className));
            };
            return (null);
        }
        public function getXMLDataByResNameOrUrl(resNameOrUrl:String):XML{
            var loader:Object = this.queue.getLoader(resNameOrUrl);
            if ((loader is XMLLoader)){
                return (XMLLoader(loader).content);
            };
            return (null);
        }
        public function getImageDataByResNameOrUrl(resNameOrUrl:String):Bitmap{
            var loader:Object = this.queue.getLoader(resNameOrUrl);
            if ((loader is ImageLoader)){
                return (ImageLoader(loader).rawContent);
            };
            return (null);
        }
        public function destroyLoaderByResNameOrUrl(resNameOrUrl:String, isClearContent:Boolean=false):void{
            var loader:Object = this.queue.getLoader(resNameOrUrl);
            if ((loader is SWFLoader)){
                SWFLoader(loader).dispose(isClearContent);
            } else {
                if ((loader is XMLLoader)){
                    XMLLoader(loader).dispose(isClearContent);
                } else {
                    if ((loader is ImageLoader)){
                        ImageLoader(loader).dispose(isClearContent);
                    };
                };
            };
        }
        public function destroyQueue(isDispose:Boolean=false, isClearContent:Boolean=false):void{
            if (isDispose){
                ((isClearContent) && (this.queue.unload()));
                this.queue.dispose(isClearContent);
                this.queue = null;
            } else {
                if (isClearContent){
                    this.queue.unload();
                };
            };
        }
        private function progressHandler(event:LoaderEvent):void{
            dispatchEvent(new LoaderMsgEvent(LoaderMsgEvent.EventName_Progress, event.target.progress));
        }
        private function onOneComplete(event:LoaderEvent):void{
            var loaderItem:LoaderItem = (event.target as LoaderItem);
            dispatchEvent(new LoaderMsgEvent(LoaderMsgEvent.EventName_OneComplete, loaderItem));
        }
        private function completeHandler(event:LoaderEvent):void{
            dispatchEvent(new LoaderMsgEvent(LoaderMsgEvent.EventName_Complete, null));
        }
        private function errorHandler(event:LoaderEvent):void{
            trace(((("error occured with " + event.target) + ": ") + event.text));
            dispatchEvent(new LoaderMsgEvent(LoaderMsgEvent.EventName_Error, event.text));
        }

    }
}//package junlas.loadqueue 
