//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.loading {
    import flash.system.*;
    import com.greensock.loading.core.*;
    import com.greensock.events.*;
    import flash.events.*;

    public class XMLLoader extends DataLoader {

        private static var _classActivated:Boolean = _activateClass("XMLLoader", XMLLoader, "xml,php,jsp,asp,cfm,cfml,aspx");
        protected static var _varTypes:Object = {
            skipFailed:true,
            skipPaused:true,
            paused:false,
            load:false,
            noCache:false,
            maxConnections:2,
            autoPlay:false,
            autoDispose:false,
            smoothing:false,
            estimatedBytes:1,
            x:1,
            y:1,
            width:1,
            height:1,
            scaleX:1,
            scaleY:1,
            rotation:1,
            alpha:1,
            visible:true,
            bgColor:0,
            bgAlpha:0,
            deblocking:1,
            repeat:1,
            checkPolicyFile:false,
            centerRegistration:false,
            bufferTime:5,
            volume:1,
            bufferMode:false,
            estimatedDuration:200,
            crop:false
        };

        protected var _loadingQueue:LoaderMax;
        protected var _parsed:LoaderMax;
        protected var _initted:Boolean;

        public function XMLLoader(urlOrRequest, vars:Object=null){
            super(urlOrRequest, vars);
            _preferEstimatedBytesInAudit = true;
            _type = "XMLLoader";
            _loader.dataFormat = "text";
        }
        protected static function _parseVars(xml:XML):Object{
            var s:String;
            var type:String;
            var value:String;
            var domain:ApplicationDomain;
            var attribute:XML;
            var v:Object = {};
            var list:XMLList = xml.attributes();
            for each (attribute in list) {
                s = attribute.name();
                value = attribute.toString();
                if (s == "url"){
                } else {
                    if (s == "domain"){
                        v.context = new LoaderContext(true, ((value)=="child") ? new ApplicationDomain(ApplicationDomain.currentDomain) : ((value)=="separate") ? new ApplicationDomain() : ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
                    } else {
                        type = typeof(_varTypes[s]);
                        if (type == "boolean"){
                            v[s] = Boolean((((value == "true")) || ((value == "1"))));
                        } else {
                            if (type == "number"){
                                v[s] = Number(value);
                            } else {
                                v[s] = value;
                            };
                        };
                    };
                };
            };
            return (v);
        }
        public static function parseLoaders(xml:XML, all:LoaderMax, toLoad:LoaderMax=null):void{
            var loader:LoaderCore;
            var queue:LoaderMax;
            var curName:String;
            var replaceText:Array;
            var loaderClass:Class;
            var node:XML;
            for each (node in xml.children()) {
                curName = node.name();
                if (curName == "LoaderMax"){
                    queue = (all.append(new LoaderMax(_parseVars(node))) as LoaderMax);
                    if (((!((toLoad == null))) && (queue.vars.load))){
                        toLoad.append(queue);
                    };
                    parseLoaders(node, queue, toLoad);
                    if (("replaceURLText" in queue.vars)){
                        replaceText = queue.vars.replaceURLText.split(",");
                        if (replaceText.length == 2){
                            queue.replaceURLText(replaceText[0], replaceText[1], false);
                        };
                    };
                    if (("prependURLs" in queue.vars)){
                        queue.prependURLs(queue.vars.prependURLs, false);
                    };
                } else {
                    if ((curName in _types)){
                        loaderClass = _types[curName];
                        loader = all.append(new loaderClass(node.@url, _parseVars(node)));
                        if (((!((toLoad == null))) && (loader.vars.load))){
                            toLoad.append(loader);
                        };
                    };
                    parseLoaders(node, all, toLoad);
                };
            };
        }

        override protected function _load():void{
            if (!(this._initted)){
                _prepRequest();
                _loader.load(_request);
            } else {
                if (this._loadingQueue != null){
                    this._changeQueueListeners(true);
                    this._loadingQueue.load(false);
                };
            };
        }
        protected function _changeQueueListeners(add:Boolean):void{
            var p:String;
            if (this._loadingQueue != null){
                if (((add) && (!((this.vars.integrateProgress == false))))){
                    this._loadingQueue.addEventListener(LoaderEvent.COMPLETE, this._completeHandler, false, 0, true);
                    this._loadingQueue.addEventListener(LoaderEvent.PROGRESS, this._progressHandler, false, 0, true);
                    this._loadingQueue.addEventListener(LoaderEvent.FAIL, _failHandler, false, 0, true);
                    for (p in _listenerTypes) {
                        if (((!((p == "onProgress"))) && (!((p == "onInit"))))){
                            this._loadingQueue.addEventListener(_listenerTypes[p], this._passThroughEvent, false, 0, true);
                        };
                    };
                } else {
                    this._loadingQueue.removeEventListener(LoaderEvent.COMPLETE, this._completeHandler);
                    this._loadingQueue.removeEventListener(LoaderEvent.PROGRESS, this._progressHandler);
                    this._loadingQueue.removeEventListener(LoaderEvent.FAIL, _failHandler);
                    for (p in _listenerTypes) {
                        if (((!((p == "onProgress"))) && (!((p == "onInit"))))){
                            this._loadingQueue.removeEventListener(_listenerTypes[p], this._passThroughEvent);
                        };
                    };
                };
            };
        }
        override protected function _dump(scrubLevel:int=0, newStatus:int=0, suppressEvents:Boolean=false):void{
            if (this._loadingQueue != null){
                this._changeQueueListeners(false);
                if (scrubLevel == 1){
                    this._loadingQueue.cancel();
                } else {
                    this._loadingQueue.dispose();
                    this._loadingQueue = null;
                };
            };
            if (scrubLevel >= 1){
                if (this._parsed != null){
                    this._parsed.dispose();
                    this._parsed = null;
                };
                this._initted = false;
            };
            _cacheIsDirty = true;
            var content:* = _content;
            super._dump(scrubLevel, newStatus, suppressEvents);
            if (scrubLevel == 0){
                _content = content;
            };
        }
        override protected function _calculateProgress():void{
            _cachedBytesLoaded = _loader.bytesLoaded;
            _cachedBytesTotal = _loader.bytesTotal;
            if ((((_cachedBytesTotal < _cachedBytesLoaded)) || (this._initted))){
                _cachedBytesTotal = _cachedBytesLoaded;
            };
            if (this.vars.integrateProgress == false){
            } else {
                if (((!((this._loadingQueue == null))) && (((!(("estimatedBytes" in this.vars))) || (this._loadingQueue.auditedSize))))){
                    if (this._loadingQueue.status <= LoaderStatus.COMPLETED){
                        _cachedBytesLoaded = (_cachedBytesLoaded + this._loadingQueue.bytesLoaded);
                        _cachedBytesTotal = (_cachedBytesTotal + this._loadingQueue.bytesTotal);
                    };
                } else {
                    if ((((uint(this.vars.estimatedBytes) > _cachedBytesLoaded)) && (((!(this._initted)) || (((((!((this._loadingQueue == null))) && ((this._loadingQueue.status <= LoaderStatus.COMPLETED)))) && (!(this._loadingQueue.auditedSize)))))))){
                        _cachedBytesTotal = uint(this.vars.estimatedBytes);
                    };
                };
            };
            if (((!(this._initted)) && ((_cachedBytesLoaded == _cachedBytesTotal)))){
                _cachedBytesLoaded = int((_cachedBytesLoaded * 0.99));
            };
            _cacheIsDirty = false;
        }
        public function getLoader(nameOrURL:String):LoaderCore{
            return (((this._parsed)!=null) ? this._parsed.getLoader(nameOrURL) : null);
        }
        public function getContent(nameOrURL:String){
            if ((((nameOrURL == this.name)) || ((nameOrURL == _url)))){
                return (_content);
            };
            var loader:LoaderCore = this.getLoader(nameOrURL);
            return (((loader)!=null) ? loader.content : null);
        }
        public function getChildren(includeNested:Boolean=false, omitLoaderMaxes:Boolean=false):Array{
            return (((this._parsed)!=null) ? this._parsed.getChildren(includeNested, omitLoaderMaxes) : []);
        }
        override protected function _progressHandler(event:Event):void{
            var bl:uint;
            var bt:uint;
            if (_dispatchProgress){
                bl = _cachedBytesLoaded;
                bt = _cachedBytesTotal;
                this._calculateProgress();
                if (((!((_cachedBytesLoaded == _cachedBytesTotal))) && (((!((bl == _cachedBytesLoaded))) || (!((bt == _cachedBytesTotal))))))){
                    dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS, this));
                };
            } else {
                _cacheIsDirty = true;
            };
        }
        override protected function _passThroughEvent(event:Event):void{
            if (event.target != this._loadingQueue){
                super._passThroughEvent(event);
            };
        }
        override protected function _receiveDataHandler(event:Event):void{
            var event:* = event;
            try {
                _content = new XML(_loader.data);
            } catch(error:Error) {
                _content = _loader.data;
                _failHandler(new LoaderEvent(LoaderEvent.ERROR, this, error.message));
                return;
            };
            this._initted = true;
            this._loadingQueue = new LoaderMax({name:(this.name + "_Queue")});
            this._parsed = new LoaderMax({
                name:(this.name + "_ParsedLoaders"),
                paused:true
            });
            parseLoaders((_content as XML), this._parsed, this._loadingQueue);
            if (this._parsed.numChildren == 0){
                this._parsed.dispose();
                this._parsed = null;
            } else {
                this._parsed.auditSize();
            };
            if (this._loadingQueue.getChildren(true, true).length == 0){
                this._loadingQueue.empty(false);
                this._loadingQueue.dispose();
                this._loadingQueue = null;
            } else {
                _cacheIsDirty = true;
                this._changeQueueListeners(true);
                this._loadingQueue.load(false);
            };
            dispatchEvent(new LoaderEvent(LoaderEvent.INIT, this));
            if ((((this._loadingQueue == null)) || ((this.vars.integrateProgress == false)))){
                this._completeHandler(event);
            };
        }
        override protected function _completeHandler(event:Event=null):void{
            this._calculateProgress();
            if (this.progress == 1){
                this._changeQueueListeners(false);
                super._completeHandler(event);
            };
        }
        override public function get progress():Number{
            return (((this.bytesTotal)!=0) ? (_cachedBytesLoaded / _cachedBytesTotal) : ((((_status == LoaderStatus.COMPLETED)) || (this._initted))) ? 1 : 0);
        }

    }
}//package com.greensock.loading 
