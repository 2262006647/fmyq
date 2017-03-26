//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map.resource {
    import flash.display.*;
    import flash.filters.*;
    import com.junlas.engine.map.data.*;
    import junlas.textengine.*;

    public class ActionResource extends Sprite {

        private var _actionType:String;
        private var _resXml:XML;
        private var _resPng:BitmapData;
        public var _coreRes:IActionResource;
        private var _roleXmlData:RoleXmlData;
        private var _bm:Bitmap;
        private var _nameArea:Sprite;
        private var _shadowArea:Sprite;

        public function ActionResource(actionType:String){
            super();
            this._actionType = actionType;
            this._bm = new Bitmap();
            this._nameArea = new Sprite();
            this._shadowArea = new Sprite();
            addChild(this._nameArea);
            addChild(this._shadowArea);
            addChild(this._bm);
        }
        private function initPlay():void{
            var offsetX:Number = 0;
            var offsetY:Number = 0;
            this._nameArea.x = (int(this._roleXmlData.NameX) + offsetX);
            this._nameArea.y = (int(this._roleXmlData.NameY) + offsetY);
            this._shadowArea.graphics.clear();
            this._shadowArea.graphics.beginFill(0x666666, 0.2);
            this._shadowArea.graphics.drawEllipse(-25, -15, 50, 30);
            this._shadowArea.graphics.endFill();
            this._shadowArea.x = offsetX;
            this._shadowArea.y = offsetY;
            this._shadowArea.scaleX = (Number(this._roleXmlData.shadowX) * 0.01);
            this._shadowArea.scaleY = (Number(this._roleXmlData.shadowY) * 0.01);
            var shadowFilter:DropShadowFilter = new DropShadowFilter();
            shadowFilter.distance = 0;
            shadowFilter.angle = 45;
            shadowFilter.alpha = 0.5;
            shadowFilter.blurX = 64;
            shadowFilter.blurY = 64;
            shadowFilter.color = 0x666666;
            this._shadowArea.filters = [shadowFilter];
        }
        public function updateScaleX(scaleX:int):void{
            if (scaleX != this.scaleX){
                this._nameArea.scaleX = (this._nameArea.scaleX * -1);
                this.scaleX = scaleX;
            };
        }
        public function updateRoleAlpha(alpha:Number=1):void{
            this._bm.alpha = alpha;
        }
        public function run():BitmapDataSourceClone{
            if (this._coreRes){
                return (this._coreRes.run());
            };
            return (null);
        }
        public function set bitmapData(bmd:BitmapData):void{
            this._bm.bitmapData = bmd;
        }
        public function getActionType():String{
            return (this._actionType);
        }
        public function setName(n:String):void{
            this._nameArea.graphics.clear();
            var textBuilder:TextBuilder = new TextBuilder();
            var textInfo:GenerateTextInfo = textBuilder.createGenerateText(n, 100, 0, 14, 6742614);
            var nameTextCon:Sprite = textInfo.getGenerateTextContainer();
            nameTextCon.x = -((nameTextCon.width >> 1));
            nameTextCon.y = -((nameTextCon.height >> 1));
            this._nameArea.addChild(nameTextCon);
        }
        public function setResXml(resXML:XML):void{
            this._resXml = resXML;
            this._roleXmlData = new RoleXmlData(this._resXml);
            this._bm.x = this._roleXmlData.X;
            this._bm.y = this._roleXmlData.Y;
            this.initPlay();
        }
        public function setResPng(resPng:BitmapData):void{
            this._resPng = resPng;
        }
        public function setCoreRes(ar:IActionResource):void{
            this._coreRes = ar;
        }
		public function toDebug():void{
			trace("BB:",_coreRes);
			return;
		}

    }
}//package com.junlas.engine.map.resource 
