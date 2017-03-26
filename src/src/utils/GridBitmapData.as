// Decompiled by AS3 Sorcerer 1.70
// http://www.as3sorcerer.com/

//src.utils.GridBitmapData

package utils
{
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import flash.geom.*;
    import flash.display.*;

    public class GridBitmapData 
    {

        public var width:Number;
        public var height:Number;
        public var grid9BitmapdataList:Array;
        public var padding:Padding;

        public function GridBitmapData()
        {
            this.grid9BitmapdataList = [];
        }

        public static function getGrid9Rects(_arg1:Rectangle, _arg2:int, _arg3:int):Array
        {
            var _local4:* = ((_arg2 - _arg1.width) - _arg1.x);
            var _local5:* = (_arg1.x + _arg1.width);
            var _local6:* = (_arg1.y + _arg1.height);
            var _local7:* = ((_arg3 - _arg1.height) - _arg1.y);
            return ([new Rectangle(0, 0, _arg1.x, _arg1.y), new Rectangle(_arg1.x, 0, _arg1.width, _arg1.y), new Rectangle(_local5, 0, _local4, _arg1.y), new Rectangle(0, _arg1.y, _arg1.x, _arg1.height), new Rectangle(_arg1.x, _arg1.y, _arg1.width, _arg1.height), new Rectangle(_local5, _arg1.y, _local4, _arg1.height), new Rectangle(0, _local6, _arg1.x, _local7), new Rectangle(_arg1.x, _local6, _arg1.width, _local7), new Rectangle(_local5, _local6, _local4, _local7)]);
        }


        public function bind(_arg1:BitmapData, _arg2:Padding):void
        {
            var _local3:Rectangle;
            var _local4:BitmapData;
            this.padding = _arg2;
            this.width = _arg1.width;
            this.height = _arg1.height;
            var _local5:* = _arg2.getScale9Grid(this.width, this.height);
            var _local6:* = getGrid9Rects(_local5, this.width, this.height);
            var _local7:* = new Point();
            this.grid9BitmapdataList.splice(0);
            var _local8:int;
            while (_local8 < 9) {
                _local3 = _local6[_local8];
                _local4 = new BitmapData(_local3.width, _local3.height, true, 0);
                _local4.copyPixels(_arg1, _local3, _local7);
                this.grid9BitmapdataList[_local8] = _local4;
                _local8++;
            };
        }

        public function dispose():void
        {
            var _local1:int;
            if (this.grid9BitmapdataList){
                _local1 = 0;
                while (_local1 < this.grid9BitmapdataList.length) {
                    this.grid9BitmapdataList[_local1].dispose();
                    _local1++;
                };
                this.grid9BitmapdataList.length = 0;
            };
        }


    }
}//package src.utils

