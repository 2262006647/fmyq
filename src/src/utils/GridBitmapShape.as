// Decompiled by AS3 Sorcerer 1.70
// http://www.as3sorcerer.com/

//src.utils.GridBitmapShape

package utils
{
    import flash.display.Shape;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import flash.geom.*;
    import flash.display.*;

    public class GridBitmapShape extends Shape 
    {

        private var _gridBitmapData:GridBitmapData;
        private var matrix:Matrix;
        private var p:Point;
        private var _ww:int = 0;
        private var _hh:int = 0;

        public function GridBitmapShape(_arg1:GridBitmapData)
        {
            this._gridBitmapData = _arg1;
            this.matrix = new Matrix();
            this.p = new Point();
        }

        public function draw(_arg1:int=0, _arg2:int=0):void
        {
            var _local10:int;
            var _local3:Rectangle;
            var _local4:BitmapData;
            var _local5:* = this.graphics;
            this.graphics.clear();
            if (_arg1 == 0){
                _arg1 = this._gridBitmapData.width;
            };
            if (_arg2 == 0){
                _arg2 = this._gridBitmapData.height;
            };
            var _local6:* = this._gridBitmapData.padding;
            var _local7:* = this._gridBitmapData.padding.getScale9Grid(_arg1, _arg2);
            var _local8:* = GridBitmapData.getGrid9Rects(_local7, _arg1, _arg2);
            this._ww = _arg1;
            this._hh = _arg2;
            var _local9:int;
            while (_local9 < 9) {
                _local3 = _local8[_local9];
                _local4 = this._gridBitmapData.grid9BitmapdataList[_local9];
                _local10 = 1;
                this.matrix.d = 1;
                this.matrix.a = _local10;
                _local10 = 0;
                this.matrix.ty = 0;
                this.matrix.tx = _local10;
                this.matrix.c = _local10;
                this.matrix.b = _local10;
                if ((((((((((_local9 == 1)) || ((_local9 == 3)))) || ((_local9 == 4)))) || ((_local9 == 5)))) || ((_local9 == 7)))){
                    this.matrix.scale((_local3.width / _local4.width), (_local3.height / _local4.height));
                };
                this.matrix.tx = _local3.x;
                this.matrix.ty = _local3.y;
                _local5.beginBitmapFill(_local4, this.matrix);
                _local5.drawRect(_local3.x, _local3.y, _local3.width, _local3.height);
                _local9++;
            };
            _local5.endFill();
        }

        override public function set width(_arg1:Number):void
        {
            this.draw(_arg1, this._hh);
        }

        override public function get width():Number
        {
            return (this._ww);
        }

        override public function set height(_arg1:Number):void
        {
            this.draw(this._ww, _arg1);
        }

        override public function get height():Number
        {
            return (this._hh);
        }

        public function fillNoise(_arg1:BitmapData):void
        {
            var _local2:* = this._gridBitmapData.padding;
            var _local3:* = _local2.getScale9Grid(this.width, this.height);
            var _local4:* = this.graphics;
            this.graphics.beginBitmapFill(_arg1, this.matrix, true, true);
            _local4.drawRect(_local3.x, _local3.y, _local3.width, _local3.height);
            _local4.endFill();
        }

        public function get gridBitmapData():GridBitmapData
        {
            return (this._gridBitmapData);
        }

        public function set gridBitmapData(_arg1:GridBitmapData):void
        {
            this._gridBitmapData = _arg1;
        }

        public function dispose():void
        {
            if (this._gridBitmapData){
                this._gridBitmapData.dispose();
            };
            this._gridBitmapData = null;
            this.graphics.clear();
        }


    }
}//package src.utils

