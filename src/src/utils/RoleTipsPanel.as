// Decompiled by AS3 Sorcerer 1.70
// http://www.as3sorcerer.com/

//src.RoleTipsPanel

package utils
{
	import flash.display.*;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.*;
	import flash.text.*;
	import flash.text.TextField;
	
	import utils.*;
	import utils.GridBitmapShape;
	
	public class RoleTipsPanel extends Sprite 
	{
//		[Embed(source="../libs/uiCreateRoleLib.swf",symbol="System_Tips_bg")]
//		private var System_Tips_bg:Class;
		[Embed(source="../libs/uiCreateRoleLib.swf",symbol="System_Panel_border_8")]
//		[Embed(source="../libs/System_Panel_border_8.png")]
		private var System_Panel_border_8:Class			
		private var _stage:Sprite;
		private var _tipsTfd:TextField;
		private var _tipBg:GridBitmapShape;
		
		public function RoleTipsPanel(_arg1:String, _arg2:Sprite)
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this._stage = _arg2;
			this.updateTipsHdr(_arg1);
		}
		
		public function updateTipsHdr(_arg1:String):void
		{
			this._tipsTfd = new TextField();
			this._tipsTfd.x = 5;
			this._tipsTfd.y = 5;
			this._tipsTfd.autoSize = TextFieldAutoSize.LEFT;
			this._tipsTfd.textColor = 14210735;
			var _local2:* = new TextFormat();
			_local2.size = 12;
			_local2.bold = false;
			_local2.leading = 3;
			_local2.font = "SimSun";
			this._tipsTfd.defaultTextFormat = _local2;
			this._tipsTfd.multiline = true;
			this._tipsTfd.mouseEnabled = false;
			this._tipsTfd.filters = [new DropShadowFilter(0, 45, 0, 1, 3, 3, 2.5)];
			this._tipsTfd.htmlText = _arg1;
			var _local3:* = new System_Panel_border_8();
			var _local4:* = new GridBitmapData();
			//			if (_local3 == null){
			//				trace("传入的bitmapData  为 null ");
			//				_local3 = new BitmapData(10, 10, true, 0);
			//			};
			_local4.bind(_local3.bitmapData, new Padding(5, 5, 5, 5));
			this._tipBg = new GridBitmapShape(_local4);
			this._tipBg.draw((this._tipsTfd.textWidth + 18), this._tipsTfd.textHeight+18);
			addChild(this._tipBg);
			addChild(this._tipsTfd);
			this._stage.addChild(this);
			this.x = this._stage.mouseX;
			this.y = (this._stage.mouseY - this.height);
		}
		
		public function dispose():void
		{
			if (this.parent){
				this.parent.removeChild(this);
			};
			this._tipsTfd = null;
			if (this._tipBg){
				this._tipBg.dispose();
			};
			this._tipBg = null;
		}
		
		
	}
}//package src

