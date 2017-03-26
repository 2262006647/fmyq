//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.loader {
    import flash.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class File {

        public static const limit:int = 3;

        private static var _temp:Dictionary = new Dictionary();
        private static var _id:int = 0;
        private static var _processes:Object = {};
        public static var onVersion:Function;

        private var _uri:String;
        private var _loader:Loader;
        private var _applicationDomain:ApplicationDomain;
        private var _useNewDomain:Boolean = false;
        private var _lastBytes:uint = 0;
        private var _speed:Number = 0;
        private var _urlRnd:int = 0;
        private var _timer:Timer;
        private var _reloadCount:int = 3;
        public var onProgress:Function;
        public var onComplete:Function;
        public var onError:Function;

        public function File(){
            super();
            this._loader = new Loader();
            this.addTemp();
            this._reloadCount = File.limit;
        }
        public static function loadList($list:Array, $callback:Function, $progress:Function=null, $oneCompleted:Function=null, $error:Function=null):int{
            var keyId:int = (_id + 1);
            _id = keyId;
            _processes[_id] = true;
            loadOne($list, 0, [], $callback, $progress, $oneCompleted, $error, _id);
            return (_id);
        }
        public static function stopLoadList(id:int):void{
            if (((id) && (_processes[id]))){
                _processes[id] = false;
            };
        }
        private static function loadOne($list:Array, $index:int, $temp:Array, $callback:Function, $progress:Function=null, $oneCompleted:Function=null, $error:Function=null, $id:int=0):void{
            var len:* = 0;
            var list:* = null;
            var index:* = 0;
            var temp:* = null;
            var callback:* = null;
            var progress:* = null;
            var oneCompleted:* = null;
            var error:* = null;
            var id:* = 0;
            var $list:* = $list;
            var $index:* = $index;
            var $temp:* = $temp;
            var $callback:* = $callback;
            var $progress = $progress;
            var $oneCompleted = $oneCompleted;
            var $error = $error;
            var $id:int = $id;
            list = $list;
            index = $index;
            temp = $temp;
            callback = $callback;
            progress = $progress;
            oneCompleted = $oneCompleted;
            error = $error;
            id = $id;
            var file:* = new (File)();
            temp.push(file);
            len = list.length;
            file.onComplete = function ():void{
                if (_processes[id] == false){
                    delete _processes[id];
                    return;
                };
                if ((index + 1) >= len){
                    delete _processes[id];
                    callback(temp);
                } else {
                    if ((oneCompleted is Function)){
                        oneCompleted(index);
                    };
                    loadOne(list, (index + 1), temp, callback, progress, oneCompleted, error, id);
                };
            };
            file.onProgress = function (bytesTotal:int, bytesLoaded:int, speedDesc:String):void{
                var rate:int;
                if ((progress is Function)){
                    rate = Math.floor(((bytesLoaded / bytesTotal) * 100));
                    rate = Math.min(100, rate);
                    if (progress.length == 4){
                        progress(len, index, rate, speedDesc);
                    } else {
                        if (progress.length == 3){
                            progress(index, rate, speedDesc);
                        } else {
                            progress(index, rate);
                        };
                    };
                };
            };
            file.onError = function ():void{
                if ((error is Function)){
                    error(index);
                };
            };
            file.load(list[index]);
        }

        private function addEvent():void{
            var loaderInfo:LoaderInfo = this._loader.contentLoaderInfo;
            loaderInfo.addEventListener(Event.COMPLETE, this.complete);
            loaderInfo.addEventListener(ProgressEvent.PROGRESS, this.progress);
            loaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatus);
            loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
        }
        private function removeEvent():void{
            var loaderInfo:LoaderInfo = this._loader.contentLoaderInfo;
            loaderInfo.removeEventListener(Event.COMPLETE, this.complete);
            loaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.progress);
            loaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatus);
            loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
        }
        public function load(uri:String):void{
            this._uri = uri;
            var v:String = "";
            if ((onVersion is Function)){
                v = onVersion(uri);
                if (v != ""){
                    v = ("?v=" + v);
                };
            };
            if (this._urlRnd){
                v = (v + (((v) ? "&" : "?" + "r=") + this._urlRnd));
            };
            var request:URLRequest = new URLRequest((this._uri + v));
            var context:LoaderContext = new LoaderContext();
            context.checkPolicyFile = true;
            context.applicationDomain = (this._useNewDomain) ? new ApplicationDomain() : new ApplicationDomain(ApplicationDomain.currentDomain);
            this.addEvent();
            this._loader.load(request, context);
        }
        private function complete(event:Event):void{
            this._applicationDomain = this._loader.contentLoaderInfo.applicationDomain;
            if ((this.onComplete is Function)){
                this.onComplete();
            };
            this.removeEvent();
            this.removeTemp();
        }
        private function progress(event:ProgressEvent):void{
            var prevSpeed:int;
            var lastSpeed:int;
            if ((this.onProgress is Function)){
                if (this.onProgress.length == 3){
                    if ((event.bytesLoaded - this._lastBytes) > 0){
                        this._speed = (event.bytesLoaded - this._lastBytes);
                        this._lastBytes = event.bytesLoaded;
                        prevSpeed = (this._speed / 0x0400);
                        lastSpeed = (this._speed % 0x0400);
                        this._speed = (prevSpeed + (Math.floor(((lastSpeed / 0x0400) * 10)) / 10));
                    };
                    this.onProgress(event.bytesTotal, event.bytesLoaded, (this._speed + "kb/s"));
                } else {
                    this.onProgress(event.bytesTotal, event.bytesLoaded);
                };
            };
        }
        private function httpStatus(event:HTTPStatusEvent):void{
        }
        private function securityErrorHandler(event:SecurityErrorEvent):void{
            trace("[File]\n======\n安全策略问题:", event, "\n======\n");
            this.delayToLoad();
        }
        private function ioErrorHandler(event:IOErrorEvent):void{
            trace("[File]\n======\n尝试重载文件:", this._uri, "\n======\n");
            this.delayToLoad();
        }
        private function addTemp():void{
            File._temp[this] = 1;
        }
        private function removeTemp():void{
            delete File._temp[this];
        }
        private function delayToLoad():void{
            this._loader.unload();
            if (this._reloadCount <= 0){
                this.stopLoad();
                this.removeEvent();
                this.removeTemp();
                if ((this.onError is Function)){
                    this.onError();
                };
                trace("[File]\n======\n找不到文件:", this._uri, "\n======\n");
                return;
            };
            var hasCount:int = (this._reloadCount - 1);
            this._reloadCount = hasCount;
            this._timer = new Timer(100, 1);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.startLoad);
            this._timer.start();
        }
        private function startLoad(event:TimerEvent):void{
            this.stopLoad();
            var url:int = (this._urlRnd + 1);
            this._urlRnd = url;
            if (this._urlRnd == 3){
                this._urlRnd = (Math.random() * 100);
            };
            this.load(this._uri);
        }
        private function stopLoad():void{
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.startLoad);
        }
        public function getClassByName(cName:String):Class{
            var className:* = null;
            var cName:* = cName;
            className = cName;
            return ((this._applicationDomain.getDefinition(className) as Class));
            var _slot1:* = e;
            throw (new Error(((((className + " not found in ") + _uri) + "\n") + _slot1)));
            return (null);
        }
        public function getClassObject(cName:String):Object{
            var nameClass:Class = (this.getClassByName(cName) as Class);
            return (new (nameClass)());
        }
        public function get loader():Loader{
            return (this._loader);
        }
        public function get applicationDomain():ApplicationDomain{
            return (this._applicationDomain);
        }
        public function set useNewDomain(param1:Boolean):void{
            this._useNewDomain = param1;
        }
        public function get bytes():ByteArray{
            return (this._loader.contentLoaderInfo.bytes);
        }
        public function get bitmap():Bitmap{
            return ((this._loader.content as Bitmap));
        }

    }
}//package com.junlas.engine.loader 
