//Created by Action Script Viewer - http://www.buraks.com/asv
package junlas.math {

    public class mVector {

        public static var PI_OVER_ONE_EIGHTY:Number = 0.0174532925199433;

        public var x:Number;
        public var y:Number;

        public function mVector(_arg1:Number=0, _arg2:Number=0){
            super();
            this.x = _arg1;
            this.y = _arg2;
        }
        public function setTo(_arg1:Number, _arg2:Number):void{
            this.x = _arg1;
            this.y = _arg2;
        }
        public function copyFrom(_arg1:mVector):mVector{
            this.x = _arg1.x;
            this.y = _arg1.y;
            return (this);
        }
        public function toString():String{
            var _local1:Number = (Math.round((this.x * 1000)) / 1000);
            var _local2:Number = (Math.round((this.y * 1000)) / 1000);
            return ((((("[" + _local1) + ", ") + _local2) + "]"));
        }
        public function clone():mVector{
            return (new mVector(this.x, this.y));
        }
        public function plus(_arg1:mVector):mVector{
            return (new mVector((this.x + _arg1.x), (this.y + _arg1.y)));
        }
        public function plusEquals(_arg1:mVector):mVector{
            this.x = (this.x + _arg1.x);
            this.y = (this.y + _arg1.y);
            return (this);
        }
        public function minus(_arg1:mVector):mVector{
            return (new mVector((this.x - _arg1.x), (this.y - _arg1.y)));
        }
        public function minusEquals(_arg1:mVector):mVector{
            this.x = (this.x - _arg1.x);
            this.y = (this.y - _arg1.y);
            return (this);
        }
        public function negate():mVector{
            return (new mVector(-(this.x), -(this.y)));
        }
        public function negateEquals():void{
            this.x = -(this.x);
            this.y = -(this.y);
        }
        public function mult(_arg1:Number):mVector{
            return (new mVector((this.x * _arg1), (this.y * _arg1)));
        }
        public function multEquals(_arg1:Number):mVector{
            this.x = (this.x * _arg1);
            this.y = (this.y * _arg1);
            return (this);
        }
        public function rotateAngle(_arg1:Number):mVector{
            var _local2:Number = TF_Class.cosD(_arg1);
            var _local3:Number = TF_Class.sinD(_arg1);
            var _local4:mVector = new mVector(((this.x * _local2) - (this.y * _local3)), ((this.y * _local2) + (this.x * _local3)));
            return (_local4);
        }
        public function rotateAngleEquals(_arg1:Number):mVector{
            return (this.copyFrom(this.rotateAngle(_arg1)));
        }
        public function rotateAngleForTarget(_arg1:Number, _arg2:mVector):mVector{
            var _local3:mVector = this.minus(_arg2);
            var _local4:Number = TF_Class.cosD(_arg1);
            var _local5:Number = TF_Class.sinD(_arg1);
            var _local6:mVector = new mVector(((_local3.x * _local4) - (_local3.y * _local5)), ((_local3.y * _local4) + (_local3.x * _local5)));
            var _local7:mVector = _local6.plus(_arg2);
            return (_local7);
        }
        public function rotateAngleForTargetEquals(_arg1:Number, _arg2:mVector):mVector{
            return (this.copyFrom(this.rotateAngleForTarget(_arg1, _arg2)));
        }
        public function rotateRadian(_arg1:Number):mVector{
            var _local2:Number = Math.cos(_arg1);
            var _local3:Number = Math.sin(_arg1);
            var _local4:mVector = new mVector(((this.x * _local2) - (this.y * _local3)), ((this.y * _local2) + (this.x * _local3)));
            return (_local4);
        }
        public function rotateRadianEquals(_arg1:Number):mVector{
            return (this.copyFrom(this.rotateRadian(_arg1)));
        }
        public function rotateRadianForTarget(_arg1:Number, _arg2:mVector):mVector{
            var _local3:mVector = this.minus(_arg2);
            var _local4:Number = Math.cos(_arg1);
            var _local5:Number = Math.sin(_arg1);
            var _local6:mVector = new mVector(((_local3.x * _local4) - (_local3.y * _local5)), ((_local3.y * _local4) + (_local3.x * _local5)));
            var _local7:mVector = _local6.plus(_arg2);
            return (_local7);
        }
        public function rotateRadianForTargetEquals(_arg1:Number, _arg2:mVector):mVector{
            return (this.copyFrom(this.rotateRadianForTarget(_arg1, _arg2)));
        }
        public function dot(_arg1:mVector):Number{
            return (((this.x * _arg1.x) + (this.y * _arg1.y)));
        }
        public function cross(_arg1:mVector):Number{
            return (((this.x * _arg1.y) - (this.y * _arg1.x)));
        }
        public function times(_arg1:mVector):mVector{
            return (new mVector((this.x * _arg1.x), (this.y * _arg1.y)));
        }
        public function div(_arg1:Number):mVector{
            if (_arg1 == 0){
                _arg1 = 0.0001;
            };
            return (new mVector((this.x / _arg1), (this.y / _arg1)));
        }
        public function divEquals(_arg1:Number):mVector{
            if (_arg1 == 0){
                _arg1 = 0.0001;
            };
            this.x = (this.x / _arg1);
            this.y = (this.y / _arg1);
            return (this);
        }
        public function distance(_arg1:mVector):Number{
            var _local2:mVector = this.minus(_arg1);
            return (_local2.length);
        }
        public function normalize():mVector{
            var _local1:Number = this.length;
            if (_local1 == 0){
                _local1 = 0.0001;
            };
            return (this.mult((1 / _local1)));
        }
        public function compare(_arg1:mVector):Boolean{
            if ((((this.x == _arg1.x)) && ((this.y == _arg1.y)))){
                return (true);
            };
            return (false);
        }
        public function getNormal():mVector{
            return (new mVector(-(this.y), this.x));
        }
        public function isNormalTo(_arg1:mVector):Boolean{
            return ((this.dot(_arg1) == 0));
        }
        public function angleBetween(_arg1:mVector):Number{
            var _local2:Number = this.dot(_arg1);
            var _local3:Number = (_local2 / (this.length * _arg1.length));
            return (TF_Class.acosD(_local3));
        }
        public function radianBetween(_arg1:mVector):Number{
            var _local2:Number = (this.dot(_arg1) / (this.length * _arg1.length));
            return (Math.acos(_local2));
        }
        public function get length():Number{
            return (Math.sqrt(((this.x * this.x) + (this.y * this.y))));
        }
        public function set length(_arg1:Number):void{
            var _local2:Number = this.length;
            if (_local2){
                this.multEquals((_arg1 / _local2));
            } else {
                this.x = _arg1;
            };
        }
        public function set angle(_arg1:Number):void{
            var _local2:Number = this.length;
            this.x = (_local2 * TF_Class.cosD(_arg1));
            this.y = (_local2 * TF_Class.sinD(_arg1));
        }
        public function get angle():Number{
            return (TF_Class.atan2D(this.y, this.x));
        }

    }
}//package junlas.math 
