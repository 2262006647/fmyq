//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.loading {
    import flash.display.*;
    import flash.events.*;
    import com.greensock.loading.core.*;

    public class ImageLoader extends DisplayObjectLoader {

        private static var _classActivated:Boolean = _activateClass("ImageLoader", ImageLoader, "jpg,jpeg,png,gif,bmp");

        public function ImageLoader(urlOrRequest, vars:Object=null){
            super(urlOrRequest, vars);
            _type = "ImageLoader";
        }
        override protected function _initHandler(event:Event):void{
            _determineScriptAccess();
            if (!(_scriptAccessDenied)){
                _content = Bitmap(_loader.content);
                _content.smoothing = Boolean(!((this.vars.smoothing == false)));
            } else {
                _content = _loader;
            };
            super._initHandler(event);
        }

    }
}//package com.greensock.loading 
