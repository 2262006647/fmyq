//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map.resource {
    import com.junlas.engine.map.data.*;
    import flash.display.*;

    public class ActionStandResource implements IActionResource {

        private var _frameBitmapSWF:FrameBitmapData;

        public function ActionStandResource(resPng:BitmapData=null, resXml:XML=null){
            super();
            if (((resPng) && (resXml))){
                this._frameBitmapSWF = new FrameBitmapData(resPng, resXml, false);
                this.recordInitTime();
            };
        }
        public function setData(resPng:BitmapData, resXml:XML):void{
            if (this._frameBitmapSWF){
                throw (new Error("FrameBitmapData已经有数据了."));
            };
            this._frameBitmapSWF = new FrameBitmapData(resPng, resXml, false);
            this.recordInitTime();
        }
        public function recordInitTime():void{
            this._frameBitmapSWF.recordTime();
        }
        public function run():BitmapDataSourceClone{
            return (this._frameBitmapSWF.enterFrame());
        }

    }
}//package com.junlas.engine.map.resource 
