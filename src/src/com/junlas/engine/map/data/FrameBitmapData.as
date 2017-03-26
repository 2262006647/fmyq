//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map.data {
    import flash.display.*;
    import flash.geom.*;
    import __AS3__.vec.*;
    import flash.utils.*;

    public class FrameBitmapData {

        private var _xml:XML;
        private var _isColorFilter:Boolean;
        private var _list:Vector.<BitmapDataSourceClone>;
        private var _time:Number = 0;
        private var _frameNum:int = 0;

        public function FrameBitmapData(sourceBitmapData:BitmapData, sourceXML:XML, isColorFilter:Boolean=false){
            super();
            var bmd:BitmapData = sourceBitmapData;
            this._xml = sourceXML;
            this._isColorFilter = isColorFilter;
            var cellWidth:int = int((0.9 + (bmd.width / int(this._xml.@Frame))));
            var cellHeight:int = int(this._xml.@Height);
            this._list = this.parseBitmapData(bmd, int(this._xml.@Frame), cellWidth, cellHeight);
        }
        private function parseBitmapData(bmd:BitmapData, cellNum:int, cellWidth:int, cellHeight:int):Vector.<BitmapDataSourceClone>{
            var tempBmd:BitmapData;
            var realRect:Rectangle;
            var curWidth:Number;
            var curHeight:Number;
            var realBitData:BitmapData;
            var rect:Rectangle = new Rectangle();
            rect.width = cellWidth;
            rect.height = cellHeight;
            var bitmapdata:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
            var mat:Matrix = new Matrix(-1, 0, 0, 1, cellWidth, 0);
            var point:Point = new Point();
            var rtnArr:Vector.<BitmapDataSourceClone> = new Vector.<BitmapDataSourceClone>();
            while (cellNum > 0) {
                tempBmd = new BitmapData(rect.width, rect.height, true, 0);
                tempBmd.copyPixels(bmd, rect, point);
                rect.x = (rect.x + rect.width);
                if (int(this._xml.@dir) != 1){
                    bitmapdata.fillRect(bitmapdata.rect, 0);
                    bitmapdata.draw(tempBmd, mat);
                    tempBmd.dispose();
                    tempBmd = bitmapdata.clone();
                };
                if (this._isColorFilter){
                    realRect = tempBmd.getColorBoundsRect(4294967295, 4294967295, false);
                    if (((!(realRect.isEmpty())) && (((!((tempBmd.width == realRect.width))) || (!((tempBmd.height == realRect.height))))))){
                        curWidth = realRect.width;
                        curHeight = realRect.height;
                        realBitData = new BitmapData(curWidth, curHeight, true, 0);
                        realBitData.copyPixels(tempBmd, realRect, point);
                        tempBmd.dispose();
                        tempBmd = realBitData;
                    };
                };
                rtnArr.push(new BitmapDataSourceClone(tempBmd));
                cellNum--;
            };
            bitmapdata.dispose();
            bmd.dispose();
            return (rtnArr);
        }
        public function recordTime():void{
            this._time = getTimer();
        }
        public function enterFrame():BitmapDataSourceClone{
            var hasPlayFrame:int = ((getTimer() - this._time) / int(this._xml.@Time));
            if (this._frameNum != hasPlayFrame){
                this._frameNum = hasPlayFrame;
            };
            return (this._list[(this._frameNum % this._list.length)]);
        }

    }
}//package com.junlas.engine.map.data 
