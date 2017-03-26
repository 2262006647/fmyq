//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.loading {
    import flash.net.*;
    import flash.events.*;
    import com.greensock.loading.core.*;

    public class DataLoader extends LoaderItem {

        private static var _classActivated:Boolean = _activateClass("DataLoader", DataLoader, "txt,js");

        protected var _loader:URLLoader;

        public function DataLoader(urlOrRequest, vars:Object=null){
            super(urlOrRequest, vars);
            _type = "DataLoader";
            this._loader = new URLLoader(null);
            if (("format" in this.vars)){
                this._loader.dataFormat = String(this.vars.format);
            };
            this._loader.addEventListener(ProgressEvent.PROGRESS, _progressHandler, false, 0, true);
            this._loader.addEventListener(Event.COMPLETE, this._receiveDataHandler, false, 0, true);
            this._loader.addEventListener("ioError", _failHandler, false, 0, true);
            this._loader.addEventListener("securityError", _failHandler, false, 0, true);
            this._loader.addEventListener("httpStatus", _httpStatusHandler, false, 0, true);
        }
        override protected function _load():void{
            _prepRequest();
            this._loader.load(_request);
        }
        override protected function _dump(scrubLevel:int=0, newStatus:int=0, suppressEvents:Boolean=false):void{
            var scrubLevel:int = scrubLevel;
            var newStatus:int = newStatus;
            var suppressEvents:Boolean = suppressEvents;
            if (_status == LoaderStatus.LOADING){
                try {
                    this._loader.close();
                } catch(error:Error) {
                };
            };
            super._dump(scrubLevel, newStatus, suppressEvents);
        }
        protected function _receiveDataHandler(event:Event):void{
            _content = this._loader.data;
            super._completeHandler(event);
        }

    }
}//package com.greensock.loading 
