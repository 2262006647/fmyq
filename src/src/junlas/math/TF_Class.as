//Created by Action Script Viewer - http://www.buraks.com/asv
package junlas.math {

    public class TF_Class {

        public static function sinD(_arg1:Number):Number{
            return (Math.sin((_arg1 * (Math.PI / 180))));
        }
        public static function cosD(_arg1:Number):Number{
            return (Math.cos((_arg1 * (Math.PI / 180))));
        }
        public static function tanD(_arg1:Number):Number{
            return (Math.tan((_arg1 * (Math.PI / 180))));
        }
        public static function asinD(_arg1:Number):Number{
            return ((Math.asin(_arg1) * (180 / Math.PI)));
        }
        public static function acosD(_arg1:Number):Number{
            return ((Math.acos(_arg1) * (180 / Math.PI)));
        }
        public static function atanD(_arg1:Number):Number{
            return ((Math.atan(_arg1) * (180 / Math.PI)));
        }
        public static function atan2D(_arg1:Number, _arg2:Number):Number{
            return ((Math.atan2(_arg1, _arg2) * (180 / Math.PI)));
        }
        public static function distance(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number{
            var _local5:Number = (_arg3 - _arg1);
            var _local6:Number = (_arg4 - _arg2);
            return (Math.sqrt(((_local5 * _local5) + (_local6 * _local6))));
        }
        public static function angleOfLine(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number{
            return (atan2D((_arg4 - _arg2), (_arg3 - _arg1)));
        }
        public static function degreesToRadians(_arg1:Number):Number{
            return ((_arg1 * (Math.PI / 180)));
        }
        public static function radiansToDegrees(_arg1:Number):Number{
            return ((_arg1 * (180 / Math.PI)));
        }
        public static function fixAngle(_arg1:Number):Number{
            _arg1 = (_arg1 % 360);
            return (((_arg1)<0) ? (_arg1 + 360) : _arg1);
        }
        public static function cartesianToPolar(_arg1:mVector):Object{
            var _local2:Number = Math.sqrt(((_arg1.x * _arg1.x) + (_arg1.y * _arg1.y)));
            var _local3:Number = atan2D(_arg1.y, _arg1.x);
            return ({
                r:_local2,
                t:_local3
            });
        }
        public static function FormatAngle(_arg1:Number):Number{
            _arg1 = (_arg1 % 360);
            if (_arg1 > 180){
                _arg1 = (_arg1 - 360);
            };
            if (_arg1 < -180){
                _arg1 = (_arg1 + 360);
            };
            return (_arg1);
        }
        public static function FormatAngle90(_arg1:Number):Number{
            _arg1 = (_arg1 % 180);
            if (_arg1 > 90){
                _arg1 = (180 - _arg1);
            };
            if (_arg1 < -90){
                _arg1 = (_arg1 + 180);
            };
            return (_arg1);
        }

    }
}//package junlas.math 
