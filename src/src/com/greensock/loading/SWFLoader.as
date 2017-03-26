//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.loading {
    import com.greensock.events.*;
    import flash.display.*;
    import com.greensock.loading.core.*;
    import flash.utils.*;
    import flash.events.*;
    import flash.media.*;

    public class SWFLoader extends DisplayObjectLoader {

        private static var _classActivated:Boolean = _activateClass("SWFLoader", SWFLoader, "swf");

        protected var _queue:LoaderMax;
        protected var _hasRSL:Boolean;
        protected var _rslAddedCount:uint;

        public function SWFLoader(urlOrRequest, vars:Object=null){
            super(urlOrRequest, vars);
            _preferEstimatedBytesInAudit = true;
            _type = "SWFLoader";
        }
        override protected function _load():void{
            if (_stealthMode){
                _stealthMode = false;
            } else {
                if (!(_initted)){
                    super._load();
                } else {
                    if (this._queue != null){
                        this._changeQueueListeners(true);
                        this._queue.load(false);
                    };
                };
            };
        }
        protected function _changeQueueListeners(add:Boolean):void{
            var p:String;
            if (this._queue != null){
                if (((add) && (!((this.vars.integrateProgress == false))))){
                    this._queue.addEventListener(LoaderEvent.COMPLETE, this._completeHandler, false, 0, true);
                    this._queue.addEventListener(LoaderEvent.PROGRESS, this._progressHandler, false, 0, true);
                    this._queue.addEventListener(LoaderEvent.FAIL, _failHandler, false, 0, true);
                    for (p in _listenerTypes) {
                        if (((!((p == "onProgress"))) && (!((p == "onInit"))))){
                            this._queue.addEventListener(_listenerTypes[p], this._passThroughEvent, false, 0, true);
                        };
                    };
                } else {
                    this._queue.removeEventListener(LoaderEvent.COMPLETE, this._completeHandler);
                    this._queue.removeEventListener(LoaderEvent.PROGRESS, this._progressHandler);
                    this._queue.removeEventListener(LoaderEvent.FAIL, _failHandler);
                    for (p in _listenerTypes) {
                        if (((!((p == "onProgress"))) && (!((p == "onInit"))))){
                            this._queue.removeEventListener(_listenerTypes[p], this._passThroughEvent);
                        };
                    };
                };
            };
        }
        override protected function _dump(scrubLevel:int=0, newStatus:int=0, suppressEvents:Boolean=false):void{
            var content:*;
            if ((((_status == LoaderStatus.LOADING)) && (!(_initted)))){
                _stealthMode = true;
                super._dump(scrubLevel, newStatus, suppressEvents);
                return;
            };
            if (((((_initted) && (!(_scriptAccessDenied)))) && (!((scrubLevel == 2))))){
                this._stopMovieClips(_loader.content);
                if ((_loader.content in _rootLookup)){
                    this._queue = LoaderMax(_rootLookup[_loader.content]);
                    this._changeQueueListeners(false);
                    if (scrubLevel == 1){
                        this._queue.cancel();
                    } else {
                        if (scrubLevel == 1){
                            this._queue.unload();
                        };
                        this._queue.dispose();
                    };
                };
            };
            _stealthMode = (this._hasRSL = false);
            _cacheIsDirty = true;
            if (scrubLevel >= 1){
                this._queue = null;
                _initted = false;
                super._dump(scrubLevel, newStatus, suppressEvents);
            } else {
                content = _content;
                super._dump(scrubLevel, newStatus, suppressEvents);
                _content = content;
            };
        }
        protected function _stopMovieClips(obj:DisplayObject):void{
            var mc:MovieClip = (obj as MovieClip);
            if (mc == null){
                return;
            };
            mc.stop();
            var i:int = mc.numChildren;
            while (--i > -1) {
                this._stopMovieClips(mc.getChildAt(i));
            };
        }
        override protected function _determineScriptAccess():void{
            var mc:* = null;
            try {
                mc = _loader.content;
            } catch(error:Error) {
                _scriptAccessDenied = true;
                dispatchEvent(new LoaderEvent(LoaderEvent.SCRIPT_ACCESS_DENIED, this, error.message));
                return;
            };
            if ((_loader.content is AVM1Movie)){
                _scriptAccessDenied = true;
                dispatchEvent(new LoaderEvent(LoaderEvent.SCRIPT_ACCESS_DENIED, this, "AVM1Movie denies script access"));
            };
        }
        override protected function _calculateProgress():void{
            _cachedBytesLoaded = (_stealthMode) ? 0 : _loader.contentLoaderInfo.bytesLoaded;
            _cachedBytesTotal = _loader.contentLoaderInfo.bytesTotal;
            if (this.vars.integrateProgress == false){
            } else {
                if (((!((this._queue == null))) && (((!(("estimatedBytes" in this.vars))) || (this._queue.auditedSize))))){
                    if (this._queue.status <= LoaderStatus.COMPLETED){
                        _cachedBytesLoaded = (_cachedBytesLoaded + this._queue.bytesLoaded);
                        _cachedBytesTotal = (_cachedBytesTotal + this._queue.bytesTotal);
                    };
                } else {
                    if ((((uint(this.vars.estimatedBytes) > _cachedBytesLoaded)) && (((!(_initted)) || (((((!((this._queue == null))) && ((this._queue.status <= LoaderStatus.COMPLETED)))) && (!(this._queue.auditedSize)))))))){
                        _cachedBytesTotal = uint(this.vars.estimatedBytes);
                    };
                };
            };
            if (((((this._hasRSL) && ((_content == null)))) || (((!(_initted)) && ((_cachedBytesLoaded == _cachedBytesTotal)))))){
                _cachedBytesLoaded = int((_cachedBytesLoaded * 0.99));
            };
            _cacheIsDirty = false;
        }
        protected function _checkRequiredLoaders():void{
            if ((((((this._queue == null)) && (!((this.vars.integrateProgress == false))))) && (!(_scriptAccessDenied)))){
                this._queue = _rootLookup[_loader.content];
                if (this._queue != null){
                    this._changeQueueListeners(true);
                    this._queue.load(false);
                    _cacheIsDirty = true;
                };
            };
        }
        public function getClass(className:String):Class{
            var loaders:Array;
            var i:int;
            if ((((_content == null)) || (_scriptAccessDenied))){
                return (null);
            };
            var result:Object = _content.loaderInfo.applicationDomain.getDefinition(className);
            if (result != null){
                return ((result as Class));
            };
            if (this._queue != null){
                loaders = this._queue.getChildren(true, true);
                i = loaders.length;
                while (--i > -1) {
                    if ((loaders[i] is SWFLoader)){
                        result = (loaders[i] as SWFLoader).getClass(className);
                        if (result != null){
                            return ((result as Class));
                        };
                    };
                };
            };
            return (null);
        }
        public function getSWFChild(name:String):DisplayObject{
            return ((((!(_scriptAccessDenied)) && ((_content is DisplayObjectContainer)))) ? DisplayObjectContainer(_content).getChildByName(name) : null);
        }
        public function getLoader(nameOrURL:String):LoaderCore{
            return (((this._queue)!=null) ? this._queue.getLoader(nameOrURL) : null);
        }
        public function getContent(nameOrURL:String){
            if ((((nameOrURL == this.name)) || ((nameOrURL == _url)))){
                return (this.content);
            };
            var loader:LoaderCore = this.getLoader(nameOrURL);
            return (((loader)!=null) ? loader.content : null);
        }
        public function getChildren(includeNested:Boolean=false, omitLoaderMaxes:Boolean=false):Array{
            return (((this._queue)!=null) ? this._queue.getChildren(includeNested, omitLoaderMaxes) : []);
        }
        override protected function _initHandler(event:Event):void{
            var tempContent:* = null;
            var className:* = null;
            var rslPreloader:* = null;
            var event:* = event;
            if (_stealthMode){
                _initted = true;
                this._dump(1, _status, true);
                return;
            };
            this._hasRSL = false;
            try {
                tempContent = _loader.content;
                className = getQualifiedClassName(tempContent);
                if (className.substr(-13) == "__Preloader__"){
                    rslPreloader = tempContent["__rslPreloader"];
                    if (rslPreloader != null){
                        className = getQualifiedClassName(rslPreloader);
                        if (className == "fl.rsl::RSLPreloader"){
                            this._hasRSL = true;
                            this._rslAddedCount = 0;
                            tempContent.addEventListener(Event.ADDED, this._rslAddedHandler);
                        };
                    };
                };
            } catch(error:Error) {
            };
            if (!(this._hasRSL)){
                this._init();
            };
        }
        protected function _init():void{
            var st:SoundTransform;
            this._determineScriptAccess();
            if (!(_scriptAccessDenied)){
                if (!(this._hasRSL)){
                    _content = _loader.content;
                };
                if (_content != null){
                    if ((((this.vars.autoPlay == false)) && ((_content is MovieClip)))){
                        st = _content.soundTransform;
                        st.volume = 0;
                        _content.soundTransform = st;
                        _content.stop();
                    };
                    this._checkRequiredLoaders();
                };
            } else {
                _content = _loader;
            };
            super._initHandler(null);
        }
        protected function _rslAddedHandler(event:Event):void{
            if ((((((event.target is DisplayObject)) && ((event.currentTarget is DisplayObjectContainer)))) && ((event.target.parent == event.currentTarget)))){
                this._rslAddedCount++;
            };
            if (this._rslAddedCount > 1){
                event.currentTarget.removeEventListener(Event.ADDED, this._rslAddedHandler);
                if (_status == LoaderStatus.LOADING){
                    _content = event.target;
                    this._init();
                    this._calculateProgress();
                    dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS, this));
                    this._completeHandler(null);
                };
            };
        }
        override protected function _passThroughEvent(event:Event):void{
            if (event.target != this._queue){
                super._passThroughEvent(event);
            };
        }
        override protected function _progressHandler(event:Event):void{
            var bl:uint;
            var bt:uint;
            if (_status == LoaderStatus.LOADING){
                if ((((this._queue == null)) && (_initted))){
                    this._checkRequiredLoaders();
                };
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
            };
        }
        override protected function _completeHandler(event:Event=null):void{
            var st:SoundTransform;
            this._checkRequiredLoaders();
            this._calculateProgress();
            if (this.progress == 1){
                if (((((!(_scriptAccessDenied)) && ((this.vars.autoPlay == false)))) && ((_content is MovieClip)))){
                    st = _content.soundTransform;
                    st.volume = 1;
                    _content.soundTransform = st;
                };
                this._changeQueueListeners(false);
                super._determineScriptAccess();
                super._completeHandler(event);
            };
        }

    }
}//package com.greensock.loading 
