//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map.astar {

    public class Grid {

        private var _startNode:Node;
        private var _endNode:Node;
        private var _nodes:Array;
        private var _numCols:int;
        private var _numRows:int;
        private var type:int;
        private var _straightCost:Number = 1;
        private var _diagCost:Number = 1.4142135623731;

        public function Grid(numCols:int, numRows:int){
            var j:int;
            super();
            this._numCols = numCols;
            this._numRows = numRows;
            this._nodes = [];
            var i:int;
            while (i < this._numCols) {
                this._nodes[i] = [];
                j = 0;
                while (j < this._numRows) {
                    this._nodes[i][j] = new Node(i, j);
                    j++;
                };
                i++;
            };
        }
        public function calculateLinks(type:int=0):void{
            var j:int;
            this.type = type;
            var i:int;
            while (i < this._numCols) {
                j = 0;
                while (j < this._numRows) {
                    this.initNodeLink(this._nodes[i][j], type);
                    j++;
                };
                i++;
            };
        }
        public function getType():int{
            return (this.type);
        }
        private function initNodeLink(node:Node, type:int):void{
            var j:int;
            var test:Node;
            var cost:Number;
            var test2:Node;
            var startX:int = Math.max(0, (node.x - 1));
            var endX:int = Math.min((this.numCols - 1), (node.x + 1));
            var startY:int = Math.max(0, (node.y - 1));
            var endY:int = Math.min((this.numRows - 1), (node.y + 1));
            node.links = [];
            var i:int = startX;
            while (i <= endX) {
                j = startY;
                for (;j <= endY;j++) {
                    test = this.getNode(i, j);
                    if ((((test == node)) || (!(test.walkable)))){
                    } else {
                        if (((((!((type == 2))) && (!((i == node.x))))) && (!((j == node.y))))){
                            test2 = this.getNode(node.x, j);
                            if (!(test2.walkable)){
                                continue;
                            };
                            test2 = this.getNode(i, node.y);
                            //unresolved if
                        } else {
                            cost = this._straightCost;
                            if (!((((node.x == test.x)) || ((node.y == test.y))))){
                                if (type == 1){
                                    continue;
                                };
                                if ((((type == 2)) && ((((node.x - test.x) * (node.y - test.y)) == 1)))){
                                    continue;
                                };
                                if (type == 2){
                                    cost = this._straightCost;
                                } else {
                                    cost = this._diagCost;
                                };
                            };
                            node.links.push(new Link(test, cost));
                        };
                    };
                };
                i++;
            };
        }
        public function getNode(x:int, y:int):Node{
            return (this._nodes[x][y]);
        }
        public function setEndNode(x:int, y:int):void{
            this._endNode = this._nodes[x][y];
        }
        public function setStartNode(x:int, y:int):void{
            this._startNode = this._nodes[x][y];
        }
        public function setWalkable(x:int, y:int, value:int):void{
            this._nodes[x][y].value = value;
            this._nodes[x][y].walkable = !((value == 0));
        }
        public function get endNode():Node{
            return (this._endNode);
        }
        public function get numCols():int{
            return (this._numCols);
        }
        public function get numRows():int{
            return (this._numRows);
        }
        public function get startNode():Node{
            return (this._startNode);
        }

    }
}//package com.junlas.engine.map.astar 
