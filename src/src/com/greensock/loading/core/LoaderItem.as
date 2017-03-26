//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.loading.core {
    import flash.net.*;
    import flash.events.*;
    import com.greensock.events.*;
    import com.greensock.loading.*;

    public class LoaderItem extends LoaderCore {

        protected static var _cacheID:uint = (uint((Math.random() * 100000000)) * int((Math.random() * 1000)));

        protected var _url:String;
        protected var _request:URLRequest;
        protected var _scriptAccessDenied:Boolean;
        protected var _auditStream:URLStream;
        protected var _preferEstimatedBytesInAudit:Boolean;
        protected var _httpStatus:int;

        public function LoaderItem(urlOrRequest, vars:Object=null){
            super(vars);
            this._request = ((urlOrRequest is URLRequest)) ? (urlOrRequest as URLRequest) : new URLRequest(urlOrRequest);
            this._url = this._request.url;
        }
        protected function _prepRequest():void{
            this._scriptAccessDenied = false;
            this._httpStatus = 0;
            this._closeStream();
            if (((this.vars.noCache) && (((!(_isLocal)) || ((this._url.substr(0, 4) == "http")))))){
                this._request.url = (((this._url + ((this._url.indexOf("?"))==-1) ? "?" : "&") + "cacheBusterID=") + _cacheID++);
            };
        }
        override protected function _dump(scrubLevel:int=0, newStatus:int=0, suppressEvents:Boolean=false):void{
            this._closeStream();
            super._dump(scrubLevel, newStatus, suppressEvents);
        }
        override public function auditSize():void{
            if (this._auditStream == null){
                this._auditStream = new URLStream();
                this._auditStream.addEventListener(ProgressEvent.PROGRESS, this._auditStreamHandler, false, 0, true);
                this._auditStream.addEventListener(Event.COMPLETE, this._auditStreamHandler, false, 0, true);
                this._auditStream.addEventListener("ioError", this._auditStreamHandler, false, 0, true);
                this._auditStream.addEventListener("securityError", this._auditStreamHandler, false, 0, true);
                this._auditStream.load(this._request);
            };
        }
        protected function _closeStream():void{
            if (this._auditStream != null){
                this._auditStream.removeEventListener(ProgressEvent.PROGRESS, this._auditStreamHandler);
                this._auditStream.removeEventListener(Event.COMPLETE, this._auditStreamHandler);
                this._auditStream.removeEventListener("ioError", this._auditStreamHandler);
                this._auditStream.removeEventListener("securityError", this._auditStreamHandler);
                try {
                    this._auditStream.close();
                } catch(error:Error) {
                };
                this._auditStream = null;
            };
        }
        protected function _auditStreamHandler(event:Event):void{
            if ((event is ProgressEvent)){
                _cachedBytesTotal = (event as ProgressEvent).bytesTotal;
                if (((this._preferEstimatedBytesInAudit) && ((uint(this.vars.estimatedBytes) > _cachedBytesTotal)))){
                    _cachedBytesTotal = uint(this.vars.estimatedBytes);
                };
            } else {
                if ((((event.type == "ioError")) || ((event.type == "securityError")))){
                    if (((("alternateURL" in this.vars)) && (!((this._url == this.vars.alternateURL))))){
                        this._url = (this._request.url = this.vars.alternateURL);
                        this._auditStream.load(this._request);
                        _errorHandler(event);
                        return;
                    };
                    super._failHandler(event);
                };
            };
            _auditedSize = true;
            this._closeStream();
            dispatchEvent(new Event("auditedSize"));
        }
        override protected function _failHandler(event:Event):void{
            if (((("alternateURL" in this.vars)) && (!((this._url == this.vars.alternateURL))))){
                this.url = this.vars.alternateURL;
                _errorHandler(event);
            } else {
                super._failHandler(event);
            };
        }
        protected function _httpStatusHandler(event:Event):void{
            this._httpStatus = (event as Object).status;
            dispatchEvent(new LoaderEvent(LoaderEvent.HTTP_STATUS, this));
        }
        public function get url():String{
            return (this._url);
        }
        public function set url(value:String):void{
            var isLoading:Boolean;
            if (this._url != value){
                this._url = (this._request.url = value);
                isLoading = Boolean((_status == LoaderStatus.LOADING));
                this._dump(0, LoaderStatus.READY, true);
                if (isLoading){
                    _load();
                };
            };
        }
        public function get request():URLRequest{
            return (this._request);
        }
        public function get httpStatus():int{
            return (this._httpStatus);
        }
        public function get scriptAccessDenied():Boolean{
            return (this._scriptAccessDenied);
        }

    }
}//package com.greensock.loading.core 
