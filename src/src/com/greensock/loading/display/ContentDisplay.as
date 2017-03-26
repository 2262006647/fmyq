//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.loading.display {
    import com.greensock.loading.core.*;
    import flash.display.*;
    import flash.geom.*;

    public class ContentDisplay extends Sprite {

        protected static var _transformProps:Object = {
            x:1,
            y:1,
            scaleX:1,
            scaleY:1,
            rotation:1,
            alpha:1,
            visible:true,
            blendMode:"normal"
        };

        protected var _fitRect:Rectangle;
        protected var _loader:LoaderItem;
        protected var _rawContent:DisplayObject;
        protected var _vars:Object;
        public var gcProtect;

        public function ContentDisplay(loader:LoaderItem){
            super();
            this.loader = loader;
        }
        public function dispose(unloadLoader:Boolean=true, disposeLoader:Boolean=true):void{
            if (this.parent != null){
                this.parent.removeChild(this);
            };
            this.rawContent = null;
            if (this._loader != null){
                if (unloadLoader){
                    this._loader.unload();
                };
                if (disposeLoader){
                    this._loader.dispose(false);
                    this._loader = null;
                };
            };
        }
        public function get rawContent(){
            return (this._rawContent);
        }
        public function set rawContent(value):void{
            var w:Number;
            var h:Number;
            var wGap:Number;
            var hGap:Number;
            var scaleMode:String;
            var displayRatio:Number;
            var contentRatio:Number;
            if (((((!((this._rawContent == null))) && (!((this._rawContent == value))))) && ((this._rawContent.parent == this)))){
                removeChild(this._rawContent);
            };
            var mc:DisplayObject = (this._rawContent = (value as DisplayObject));
            if ((((mc == null)) || ((this._vars == null)))){
                return;
            };
            addChildAt(mc, 0);
            var contentWidth:Number = mc.width;
            var contentHeight:Number = mc.height;
            if (((this._loader.hasOwnProperty("getClass")) && (!(this._loader.scriptAccessDenied)))){
                contentWidth = mc.loaderInfo.width;
                contentHeight = mc.loaderInfo.height;
            };
            if (this._fitRect != null){
                w = this._fitRect.width;
                h = this._fitRect.height;
                wGap = (w - contentWidth);
                hGap = (h - contentHeight);
                scaleMode = this._vars.scaleMode;
                if (scaleMode != "none"){
                    displayRatio = (w / h);
                    contentRatio = (contentWidth / contentHeight);
                    if ((((((contentRatio < displayRatio)) && ((scaleMode == "proportionalInside")))) || ((((contentRatio > displayRatio)) && ((scaleMode == "proportionalOutside")))))){
                        w = (h * contentRatio);
                    };
                    if ((((((contentRatio > displayRatio)) && ((scaleMode == "proportionalInside")))) || ((((contentRatio < displayRatio)) && ((scaleMode == "proportionalOutside")))))){
                        h = (w / contentRatio);
                    };
                    if (scaleMode != "heightOnly"){
                        mc.width = (mc.width * (w / contentWidth));
                        wGap = (this._fitRect.width - w);
                    };
                    if (scaleMode != "widthOnly"){
                        mc.height = (mc.height * (h / contentHeight));
                        hGap = (this._fitRect.height - h);
                    };
                };
                if (this._vars.hAlign == "left"){
                    wGap = 0;
                } else {
                    if (this._vars.hAlign != "right"){
                        wGap = (wGap * 0.5);
                    };
                };
                if (this._vars.vAlign == "top"){
                    hGap = 0;
                } else {
                    if (this._vars.vAlign != "bottom"){
                        hGap = (hGap * 0.5);
                    };
                };
                mc.x = this._fitRect.x;
                mc.y = this._fitRect.y;
                if (this._vars.crop == true){
                    mc.scrollRect = new Rectangle((-(wGap) / mc.scaleX), (-(hGap) / mc.scaleY), (this._fitRect.width / mc.scaleX), (this._fitRect.height / mc.scaleY));
                } else {
                    mc.x = (mc.x + wGap);
                    mc.y = (mc.y + hGap);
                };
            } else {
                mc.x = (this._vars.centerRegistration) ? (-(contentWidth) / 2) : 0;
                mc.y = (this._vars.centerRegistration) ? (-(contentHeight) / 2) : 0;
            };
        }
        public function get loader():LoaderItem{
            return (this._loader);
        }
        public function set loader(value:LoaderItem):void{
            var type:String;
            var p:String;
            this._loader = value;
            if (this._loader == null){
                return;
            };
            if (!(this._loader.hasOwnProperty("setContentDisplay"))){
                throw (new Error("Incompatible loader used for a ContentDisplay"));
            };
            graphics.clear();
            this._fitRect = null;
            this._vars = this._loader.vars;
            this.name = this._loader.name;
            if ((this._vars.container is DisplayObjectContainer)){
                (this._vars.container as DisplayObjectContainer).addChild(this);
            };
            for (p in _transformProps) {
                if ((p in this._vars)){
                    type = typeof(_transformProps[p]);
                    this[p] = ((type)=="number") ? Number(this._vars[p]) : ((type)=="string") ? String(this._vars[p]) : Boolean(this._vars[p]);
                };
            };
            if (((("width" in this._vars)) || (("height" in this._vars)))){
                this._fitRect = new Rectangle(0, 0, Number(this._vars.width), Number(this._vars.height));
                this._fitRect.x = (this._vars.centerRegistration) ? (-(this._fitRect.width) / 2) : 0;
                this._fitRect.y = (this._vars.centerRegistration) ? (-(this._fitRect.height) / 2) : 0;
                graphics.beginFill((("bgColor" in this._vars)) ? uint(this._vars.bgColor) : 0xFFFFFF, (("bgAlpha" in this._vars)) ? Number(this._vars.bgAlpha) : (("bgColor" in this._vars)) ? 1 : 0);
                graphics.drawRect(this._fitRect.x, this._fitRect.y, this._fitRect.width, this._fitRect.height);
                graphics.endFill();
            };
            if (this._loader.content != this){
                (this._loader as Object).setContentDisplay(this);
            };
            this.rawContent = (this._loader as Object).rawContent;
        }

    }
}//package com.greensock.loading.display 
