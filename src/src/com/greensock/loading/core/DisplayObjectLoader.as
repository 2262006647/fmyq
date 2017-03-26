//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.loading.core {
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import com.greensock.loading.*;
    import com.greensock.loading.display.*;
    import flash.system.*;
    import com.greensock.events.*;

    public class DisplayObjectLoader extends LoaderItem {

        protected static var _bitmapData:BitmapData = new BitmapData(1, 1, false);
        protected static var _gcDispatcher:DisplayObject;
        protected static var _gcCycles:uint = 0;

        protected var _loader:Loader;
        protected var _sprite:Sprite;
        protected var _context:LoaderContext;
        protected var _initted:Boolean;
        protected var _stealthMode:Boolean;

        public function DisplayObjectLoader(urlOrRequest, vars:Object=null){
            super(urlOrRequest, vars);
            this._refreshLoader(false);
            if ((LoaderMax.contentDisplayClass is Class)){
                this._sprite = new LoaderMax.contentDisplayClass(this);
                if (!(this._sprite.hasOwnProperty("rawContent"))){
                    throw (new Error("LoaderMax.contentDisplayClass must be set to a class with a 'rawContent' property, like com.greensock.loading.display.ContentDisplay"));
                };
            } else {
                this._sprite = new ContentDisplay(this);
            };
        }
        public static function forceGC(dispatcher:DisplayObject, cycles:uint=1):void{
            if (_gcCycles < cycles){
                _gcCycles = cycles;
                if (_gcDispatcher == null){
                    _gcDispatcher = dispatcher;
                    _gcDispatcher.addEventListener(Event.ENTER_FRAME, _forceGCHandler, false, 0, true);
                };
            };
        }
        protected static function _forceGCHandler(event:Event):void{
            var event:* = event;
            if (_gcCycles == 0){
                _gcDispatcher.removeEventListener(Event.ENTER_FRAME, _forceGCHandler);
                _gcDispatcher = null;
            };
            _gcCycles--;
            try {
                new LocalConnection().connect("FORCE_GC");
                new LocalConnection().connect("FORCE_GC");
            } catch(error:Error) {
            };
        }

        public function setContentDisplay(contentDisplay:Sprite):void{
            this._sprite = contentDisplay;
        }
        override protected function _load():void{
            _prepRequest();
            if ((this.vars.context is LoaderContext)){
                this._context = this.vars.context;
            } else {
                if ((((this._context == null)) && (!(_isLocal)))){
                    this._context = new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
                };
            };
            this._loader.load(_request, this._context);
        }
        protected function _refreshLoader(unloadContent:Boolean=true):void{
            var unloadContent:Boolean = unloadContent;
            if (this._loader != null){
                if (_status == LoaderStatus.LOADING){
                    try {
                        this._loader.close();
                    } catch(error:Error) {
                    };
                };
                this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, _progressHandler);
                this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _completeHandler);
                this._loader.contentLoaderInfo.removeEventListener("ioError", _failHandler);
                this._loader.contentLoaderInfo.removeEventListener("securityError", this._securityErrorHandler);
                this._loader.contentLoaderInfo.removeEventListener("httpStatus", _httpStatusHandler);
                this._loader.contentLoaderInfo.removeEventListener(Event.INIT, this._initHandler);
                if (unloadContent){
                    try {
                        if (this._loader.hasOwnProperty("unloadAndStop")){
                            (this._loader as Object).unloadAndStop();
                        } else {
                            this._loader.unload();
                        };
                    } catch(error:Error) {
                    };
                };
                forceGC(this._sprite, (this.hasOwnProperty("getClass")) ? 3 : 1);
            };
            this._initted = false;
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _progressHandler, false, 0, true);
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _completeHandler, false, 0, true);
            this._loader.contentLoaderInfo.addEventListener("ioError", _failHandler, false, 0, true);
            this._loader.contentLoaderInfo.addEventListener("securityError", this._securityErrorHandler, false, 0, true);
            this._loader.contentLoaderInfo.addEventListener("httpStatus", _httpStatusHandler, false, 0, true);
            this._loader.contentLoaderInfo.addEventListener(Event.INIT, this._initHandler, false, 0, true);
        }
        override protected function _dump(scrubLevel:int=0, newStatus:int=0, suppressEvents:Boolean=false):void{
            if (scrubLevel == 1){
                (this._sprite as Object).rawContent = null;
            } else {
                if (scrubLevel == 2){
                    (this._sprite as Object).loader = null;
                } else {
                    if (scrubLevel == 3){
                        (this._sprite as Object).dispose(false, false);
                    };
                };
            };
            if (!(this._stealthMode)){
                this._refreshLoader(Boolean(!((scrubLevel == 2))));
            };
            super._dump(scrubLevel, newStatus, suppressEvents);
        }
        protected function _determineScriptAccess():void{
            if (!(_scriptAccessDenied)){
                try {
                    _bitmapData.draw(this._loader.content);
                } catch(error:Error) {
                    _scriptAccessDenied = true;
                    dispatchEvent(new LoaderEvent(LoaderEvent.SCRIPT_ACCESS_DENIED, this, error.message));
                };
            };
        }
        protected function _securityErrorHandler(event:ErrorEvent):void{
            if (((((!((this._context == null))) && (this._context.checkPolicyFile))) && (!(("context" in this.vars))))){
                this._context.checkPolicyFile = false;
                this._context.applicationDomain = null;
                this._context.securityDomain = null;
                _scriptAccessDenied = true;
                _errorHandler(event);
                this._load();
            } else {
                _failHandler(event);
            };
        }
        protected function _initHandler(event:Event):void{
            if (!(this._initted)){
                this._initted = true;
                (this._sprite as Object).rawContent = (_content as DisplayObject);
                dispatchEvent(new LoaderEvent(LoaderEvent.INIT, this));
            };
        }
        override public function get content(){
            return (this._sprite);
        }
        public function get rawContent(){
            return (_content);
        }

    }
}//package com.greensock.loading.core 
