//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map {
    import com.junlas.engine.map.data.*;
    import junlas.math.*;
    import flash.display.*;
    import com.junlas.engine.map.resource.*;

    public class CharacterObject {

        private var _default_Direction:CharacterDirection;
        private var _charCtrl:CharacterController;
        private var _charGraphicRes:GraphicsResource;
        private var _pmc:Sprite;
        private var _currActionRes:ActionResource;
        private var _render:RenderCharacter;
        private var _cameraFocus:Function;

        public function CharacterObject(ctrl:CharacterController){
            super();
            this._charCtrl = ctrl;
        }
        private function enterFrameHandler():void{
            var bmdSC:BitmapDataSourceClone;
            if (this._currActionRes){
                bmdSC = this._currActionRes.run();
            };
            if (bmdSC != null){
                this._currActionRes.bitmapData = bmdSC.srcBitmapData;
            };
            this.characterGo();
        }
        private function characterGo():void{
            if (!(this._charCtrl.isWalk)){
                this.updateCharacterAction(MapCharacterAction.Stand);
                return;
            };
            var currPos:mVector = this._charCtrl.currPos;
            var nextPos:mVector = this._charCtrl.nextPos;
            if (!(nextPos)){
                this.updateCharacterAction(MapCharacterAction.Stand);
                return;
            };
            this.updateCharacterAction(MapCharacterAction.Run);
            var temp:mVector = nextPos.minus(currPos);
            temp.length = this._charCtrl.getGoPathStepSpeed();
            currPos.plusEquals(temp);
            this._currActionRes.x = currPos.x;
            this._currActionRes.y = currPos.y;
            if (this._charCtrl.directionValue(temp) >= 0){
                this._currActionRes.updateScaleX(1);
            } else {
                this._currActionRes.updateScaleX(-1);
            };
            ((this._cameraFocus) && (this._cameraFocus(currPos.x, currPos.y)));
        }
        public function addToMapScene(pmc:Sprite):void{
            this._pmc = pmc;
            ((this._currActionRes) && (this._pmc.addChild(this._currActionRes)));
        }
        private function updateCharacterAction(characterActionType:String):void{
            var lastScaleX:int = 1;
            if (((this._currActionRes) && (this._currActionRes.parent))){
                if (this._charCtrl.isShaded()){
                    this._currActionRes.updateRoleAlpha(0.5);
                } else {
                    this._currActionRes.updateRoleAlpha(1);
                };
                if (this._currActionRes.getActionType() == characterActionType){
                    return;
                };
                this._currActionRes.parent.removeChild(this._currActionRes);
                lastScaleX = this._currActionRes.scaleX;
            };
            this._currActionRes = this._charGraphicRes.getActionResource(characterActionType);
            if (((this._pmc) && (this._currActionRes))){
                this._pmc.addChild(this._currActionRes);
            };
            this._currActionRes.x = this._charCtrl.currPos.x;
            this._currActionRes.y = this._charCtrl.currPos.y;
            this._currActionRes.updateScaleX(lastScaleX);
            if (this._charCtrl.isShaded()){
                this._currActionRes.updateRoleAlpha(0.5);
            } else {
                this._currActionRes.updateRoleAlpha(1);
            };
        }
        public function setCameraFocus(cameraFocus:Function):void{
            this._cameraFocus = cameraFocus;
            this._cameraFocus(this._charCtrl.currPos.x, this._charCtrl.currPos.y);
        }
        public function set grahpicsRes(graphicsRes:GraphicsResource):void{
            this._charGraphicRes = graphicsRes;
            this.updateCharacterAction(MapCharacterAction.Stand);
        }
        public function set render(render:RenderCharacter):void{
            if (this._render){
                throw (new Error("已经有渲染器存在了.."));
            };
            this._render = render;
            this._render.setEnterFrameHandler(this.enterFrameHandler);
        }
        public function set directionNum(direNum:int):void{
            switch (direNum){
                case this.Default_Direction.StandBy:
                    this.updateCharacterAction(MapCharacterAction.Stand);
                    break;
                default:
                    trace("初始方向定位:", direNum);
            };
        }
        public function setPos(x:Number, y:Number):void{
            this._currActionRes.x = x;
            this._currActionRes.y = y;
            this._charCtrl.currPos.setTo(x, y);
        }
        public function setName(n:String):void{
            this._charGraphicRes.setName(n);
        }
        public function setSpeed(s:Number):void{
            this._charCtrl.setGoPathStepSpeed(s);
        }
        public function get Default_Direction():CharacterDirection{
            if (!(this._default_Direction)){
                this._default_Direction = new CharacterDirection();
            };
            return (this._default_Direction);
        }
        public function set Default_Direction(direc:CharacterDirection):void{
            this._default_Direction = direc;
        }

    }
}//package com.junlas.engine.map 
