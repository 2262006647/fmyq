// Decompiled by AS3 Sorcerer 1.70
// http://www.as3sorcerer.com/

//src.utils.Padding

package utils
{
	import flash.geom.*;
	import flash.geom.Rectangle;
	
	public class Padding 
	{
		
		public var bottom:Number;
		public var left:Number;
		public var right:Number;
		public var top:Number;
		
		public function Padding(_arg1:Number=0, _arg2:Number=0, _arg3:Number=-1, _arg4:Number=-1)
		{
			this.top = _arg1;
			this.right = _arg2;
			if (_arg3 == Number.NEGATIVE_INFINITY){
				_arg3 = _arg1;
			};
			this.bottom = _arg3;
			if (_arg4 == Number.NEGATIVE_INFINITY){
				_arg4 = _arg2;
			};
			this.left = _arg4;
		}
		
		public function clone():Padding
		{
			return (new Padding(this.left, this.top, this.right, this.bottom));
		}
		
		public function equals(_arg1:Padding):Boolean
		{
			if (_arg1.left != this.left){
				return (false);
			};
			if (_arg1.right != this.right){
				return (false);
			};
			if (_arg1.top != this.top){
				return (false);
			};
			if (_arg1.bottom != this.bottom){
				return (false);
			};
			return (true);
		}
		
		public function getScale9Grid(_arg1:Number, _arg2:Number):Rectangle
		{
			var _local3:* = ((_arg1 - this.left) - this.right);
			var _local4:* = ((_arg2 - this.top) - this.bottom);
			return (new Rectangle(this.left, this.top, _local3, _local4));
		}
		
		public function toString():String
		{
			var _local1:String = "Padding : ";
			_local1 = (_local1 + (" left:" + this.left));
			_local1 = (_local1 + (" right:" + this.right));
			_local1 = (_local1 + (" top:" + this.top));
			_local1 = (_local1 + (" bottom:" + this.bottom));
			return (_local1);
		}
		
		
	}
}//package src.utils

