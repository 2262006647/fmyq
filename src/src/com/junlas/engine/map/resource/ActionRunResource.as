//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map.resource {
    import com.junlas.engine.map.data.*;
    import flash.display.*;

    public class ActionRunResource implements IActionResource {

        public var _frameBitmapSWF:FrameBitmapData;

        public function ActionRunResource(resPng:BitmapData, resXml:XML){
            super();
            this._frameBitmapSWF = new FrameBitmapData(resPng, resXml);
        }
        public function recordInitTime():void{
            this._frameBitmapSWF.recordTime();
        }
        public function run():BitmapDataSourceClone{
            return (this._frameBitmapSWF.enterFrame());
        }

    }
}//package com.junlas.engine.map.resource 
