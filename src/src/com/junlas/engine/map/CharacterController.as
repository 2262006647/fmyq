//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map {
    import junlas.math.*;
    import flash.geom.*;
    import com.junlas.engine.map.scene.*;
    import flash.events.*;
    import com.junlas.engine.map.astar.*;
    import flash.display.*;
    import com.junlas.engine.map.data.*;

    public class CharacterController extends EventDispatcher {

        private var _scene:MapScene;
        private var _currPos:mVector;
        private var _clickPos:mVector;
        private var _nextPos:mVector;
        private var xDire:mVector;
        private var _currPath:Array;
        private var _currIndex:int;
        private var _goPathStepSpeed:Number = 10;
        private var _isWalk:Boolean = false;
        private var _characterRect:Rectangle;
        private var _rectPos:Point;
        private var _filterRect:Rectangle;

        public function CharacterController(scene:MapScene, method:int){
            this._currPos = new mVector();
            this._clickPos = new mVector();
            this._nextPos = new mVector();
            this.xDire = new mVector(1, 0);
            super();
            this._scene = scene;
            this._characterRect = new Rectangle();
            this._rectPos = new Point();
            this._filterRect = new Rectangle();
            if (method == MapRoleMethod.Mouse){
                this._scene.addEventListener(MouseEvent.CLICK, this.onClick);
            };
        }
        private function onClick(e:MouseEvent):void{
            this._scene.clickRealityPos(this._clickPos);
            this._scene.setStartNode(this._currPos);
            this._scene.setEndNode(this._clickPos);
            var findPath:Array = this._scene.getPath();
            if (findPath){
                this._currPath = findPath;
                this._currIndex = 1;
                this._isWalk = true;
				trace("path:",findPath);
            } else {
                trace("未找到可寻路径");
            };
        }
        public function get nextPos():mVector{
            var nextNode:Node;
            var node:Node = this._currPath[this._currIndex];
            if (!(node)){
                this._isWalk = false;
                this._nextPos.copyFrom(this._currPos);
                return (null);
            };
            this._nextPos.setTo(((node.y + 0.5) * StaticClass.gridCellSize), ((node.x + 0.5) * StaticClass.gridCellSize));
            if (this._nextPos.minusEquals(this._currPos).length < this._goPathStepSpeed){
                this._currIndex++;
                if (this._currIndex >= this._currPath.length){
                    this._isWalk = false;
                    this._nextPos.copyFrom(this._currPos);
                    return (null);
                };
                nextNode = this._currPath[this._currIndex];
                this._nextPos.setTo(((nextNode.y + 0.5) * StaticClass.gridCellSize), ((nextNode.x + 0.5) * StaticClass.gridCellSize));
            } else {
                this._nextPos.setTo(((node.y + 0.5) * StaticClass.gridCellSize), ((node.x + 0.5) * StaticClass.gridCellSize));
            };
            return (this._nextPos);
        }
        public function isShaded():Boolean{
            if (!(this._currPath)){
                return (false);
            };
            var node:Node = this._currPath[(this._currIndex - 1)];
            if (!(node)){
                return (false);
            };
            if (node.value == 2){
                return (true);
            };
            return (false);
        }
        public function directionValue(currDire:mVector):Number{
            return (currDire.dot(this.xDire));
        }
        public function updateCharacterThreshold(currBmdSc:BitmapDataSourceClone, isPositive:int=1):void{
            var srcBmd:BitmapData;
            if (!(currBmdSc)){
                return;
            };
            var width:Number = currBmdSc.srcBitmapData.width;
            var height:Number = currBmdSc.srcBitmapData.height;
            this._characterRect.x = 0;
            this._characterRect.y = 0;
            this._characterRect.width = width;
            this._characterRect.height = height;
            this._filterRect.x = (this._currPos.x - (width / 2));
            this._filterRect.y = ((this._currPos.y + this._scene.getYStart()) - height);
            this._filterRect.width = width;
            this._filterRect.height = height;
            var filter:BitmapData = new BitmapData(width, height, true, 0);
            filter.fillRect(this._characterRect, 4278190335);
            filter.threshold(this._scene.getMapSWF()["Map_proback"].bitmapData, this._filterRect, this._rectPos, ">", 0, 1073741824, 2147483648);
            if (isPositive){
                srcBmd = currBmdSc.positiveBitmapData;
            } else {
                srcBmd = currBmdSc.negativeBitmapData;
            };
            currBmdSc.srcBitmapData.copyPixels(srcBmd, this._characterRect, this._rectPos, filter, this._rectPos, false);
            filter.dispose();
        }
        public function setGoPathStepSpeed(s:Number):void{
            this._goPathStepSpeed = s;
        }
        public function getGoPathStepSpeed():Number{
            return (this._goPathStepSpeed);
        }
        public function get currPos():mVector{
            return (this._currPos);
        }
        public function get clickPos():mVector{
            return (this._clickPos);
        }
        public function get isWalk():Boolean{
            return (this._isWalk);
        }

    }
}//package com.junlas.engine.map 
