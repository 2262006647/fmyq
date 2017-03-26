//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map.scene {
    import flash.display.*;
    import flash.utils.*;
    import com.junlas.engine.map.astar.*;
    import com.junlas.engine.map.*;
    import junlas.math.*;
    import com.assist.view.interfaces.*;
    import com.junlas.engine.loader.*;

    public class MapScene extends Sprite implements IMapScene {

        private var _backgroundScene:Sprite;
        private var _realityScene:Sprite;
        private var _yStart:Number;
        private var _mapSWF:Sprite;
        private var _mapGrid:Array;
        private var _grid:Grid;
        private var _astar:AStar;
        private var _allRolePmc:Sprite;
        private var _debugPmc:Sprite;
        private var _debugDrawLinePmc:Sprite;

        public function MapScene(mapGrid:Array, yStart:Number=0, direType:int=0){
            var currT:Number;
            super();
            this._mapGrid = mapGrid;
            this._yStart = yStart;
            if (this._mapGrid.length == 0){
                throw (new ArgumentError("网格为空，请检查数据"));
            };
            this._backgroundScene = new Sprite();
            this._realityScene = new Sprite();
            this._realityScene.y = this._yStart;
            addChild(this._backgroundScene);
            addChild(this._realityScene);
            var firstT:Number = getTimer();
            var colNum:int = this._mapGrid.length;
            var rowNum:int = this._mapGrid[0].length;
            this._grid = new Grid(colNum, rowNum);
            this.initMapNode();
            this._grid.calculateLinks(direType);
            this._astar = new AStar(this._grid);
            if (StaticClass.isDebug){
                currT = getTimer();
                trace("初始化地图网格，历时:", (currT - firstT));
                this._debugPmc = new Sprite();
                this._debugDrawLinePmc = new Sprite();
                this._debugPmc.mouseChildren = (this._debugPmc.mouseEnabled = false);
                this._debugDrawLinePmc.mouseChildren = (this._debugDrawLinePmc.mouseEnabled = false);
                this.showGrids();
                this._realityScene.addChild(this._debugPmc);
                this._realityScene.addChild(this._debugDrawLinePmc);
            };
            this._allRolePmc = new Sprite();
            this._realityScene.addChild(this._allRolePmc);
        }
        private function initMapNode():void{
            var rowArr:Array;
            var col:int;
            var row:int;
            while (row < this._mapGrid.length) {
                rowArr = this._mapGrid[row];
                col = 0;
                while (col < rowArr.length) {
                    this._grid.setWalkable(row, col, rowArr[col]);
                    col++;
                };
                row++;
            };
        }
        public function setStartNode(point:mVector):void{
            var x:int = int((point.x / StaticClass.gridCellSize));
            var y:int = int((point.y / StaticClass.gridCellSize));
            if (y > this._grid.numCols){
                y = (this._grid.numCols - 1);
            };
            if (y < 0){
                y = 0;
            };
            if (x > this._grid.numRows){
                x = (this._grid.numRows - 1);
            };
            if (x < 0){
                x = 0;
            };
            this._grid.setStartNode(y, x);
        }
        public function setEndNode(point:mVector):void{
            var x:int = int((point.x / StaticClass.gridCellSize));
            var y:int = int((point.y / StaticClass.gridCellSize));
            if (y > this._grid.numCols){
                y = (this._grid.numCols - 1);
            };
            if (y < 0){
                y = 0;
            };
            if (x > this._grid.numRows){
                x = (this._grid.numRows - 1);
            };
            if (x < 0){
                x = 0;
            };
            this._grid.setEndNode(y, x);
        }
        public function getPath():Array{
            var path:Array;
            if (this._astar.findPath()){
                path = this._astar.path;
            };
            if (StaticClass.isDebug){
                this.drawDebugLine(path);
            };
            return (path);
        }
        private function drawDebugLine(path:Array):void{
            var node:Node;
            if (path == null){
                return;
            };
            this._debugDrawLinePmc.graphics.clear();
            var startPosNode:Node = path[0];
            this._debugDrawLinePmc.graphics.moveTo(((startPosNode.y + 0.5) * StaticClass.gridCellSize), ((startPosNode.x + 0.5) * StaticClass.gridCellSize));
            this._debugDrawLinePmc.graphics.lineStyle(2, 0);
            var i:int = 1;
            while (i < path.length) {
                node = path[i];
                this._debugDrawLinePmc.graphics.lineTo(((node.y + 0.5) * StaticClass.gridCellSize), ((node.x + 0.5) * StaticClass.gridCellSize));
                i++;
            };
            this._debugDrawLinePmc.graphics.endFill();
        }
        public function addObject(obj:CharacterObject):void{
            obj.addToMapScene(this._allRolePmc);
        }
        public function addLoadMapResource(path:String):void{
            var file:* = null;
            var path:* = path;
            file = new File();
            file.load(path);
            file.onComplete = function ():void{
                _mapSWF = (file.loader.contentLoaderInfo.content);
				trace(file.loader.contentLoaderInfo.content);
                while (_backgroundScene.numChildren) {
                    _backgroundScene.removeChildAt(0);
                };
				trace(_mapSWF);
                (_mapSWF as Sprite).scaleX = ((_mapSWF as Sprite).scaleY = 1);
                _backgroundScene.addChild((_mapSWF as Sprite));
            };
        }
        public function addMiniMapResource(mapRes:DisplayObject):void{
            this._backgroundScene.addChild(mapRes);
        }
        public function clickRealityPos(realityPos:mVector):void{
            realityPos.setTo(this._realityScene.mouseX, this._realityScene.mouseY);
        }
        public function getSceneWidth():Number{
            return ((this._grid.numRows * StaticClass.gridCellSize));
        }
        public function getSceneHeight():Number{
            if (this._yStart == 0){
                return ((this._grid.numCols * StaticClass.gridCellSize));
            };
            return (StaticClass.stage.stageHeight);
        }
        public function setX(px:Number):void{
            this.x = px;
        }
        public function setY(py:Number):void{
            this.y = py;
        }
        public function getYStart():Number{
            return (this._yStart);
        }
        public function getMapSWF():Sprite{
            return (this._mapSWF);
        }
        private function showGrids():void{
            var j:int;
            var node:Node;
            var uiGridNode:MapGridNode;
            var i:int;
            while (i < this._grid.numCols) {
                j = 0;
                while (j < this._grid.numRows) {
                    node = this._grid.getNode(i, j);
                    uiGridNode = new MapGridNode(j, i, node.value);
                    this._debugPmc.addChild(uiGridNode);
                    j++;
                };
                i++;
            };
            trace("debug pmc", this._debugPmc.width, this._debugPmc.height);
        }

    }
}//package com.junlas.engine.map.scene 

