//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map.astar {

    public class AStar {

        private var _open:BinaryHeap;
        private var _grid:Grid;
        private var _endNode:Node;
        private var _startNode:Node;
        private var _path:Array;
        public var heuristic:Function;
        private var _straightCost:Number = 1;
        private var _diagCost:Number = 1.4142135623731;
        private var nowversion:int = 1;
        private var TwoOneTwoZero:Number;

        public function AStar(grid:Grid){
            this.TwoOneTwoZero = (2 * Math.cos((Math.PI / 3)));
            super();
            this._grid = grid;
            this.heuristic = this.euclidian2;
        }
        private function justMin(x:Object, y:Object):Boolean{
            return ((x.f < y.f));
        }
        public function findPath():Boolean{
            this._endNode = this._grid.endNode;
            this.nowversion++;
            this._startNode = this._grid.startNode;
            if (((!(this._startNode.walkable)) || (!(this._endNode.walkable)))){
                return (false);
            };
            this._open = new BinaryHeap(this.justMin);
            this._startNode.g = 0;
            return (this.search());
        }
        public function search():Boolean{
            var len:int;
            var i:int;
            var test:Node;
            var cost:Number;
            var g:Number;
            var h:Number;
            var f:Number;
            var node:Node = this._startNode;
            node.version = this.nowversion;
            while (node != this._endNode) {
                len = node.links.length;
                i = 0;
                while (i < len) {
                    test = node.links[i].node;
                    cost = node.links[i].cost;
                    g = (node.g + cost);
                    h = this.heuristic(test);
                    f = (g + h);
                    if (test.version == this.nowversion){
                        if (test.f > f){
                            test.f = f;
                            test.g = g;
                            test.h = h;
                            test.parent = node;
                        };
                    } else {
                        test.f = f;
                        test.g = g;
                        test.h = h;
                        test.parent = node;
                        this._open.ins(test);
                        test.version = this.nowversion;
                    };
                    i++;
                };
                if (this._open.a.length == 1){
                    return (false);
                };
                node = (this._open.pop() as Node);
            };
            this.buildPath();
            return (true);
        }
        private function buildPath():void{
            this._path = [];
            var node:Node = this._endNode;
            this._path.push(node);
            while (node != this._startNode) {
                node = node.parent;
                this._path.unshift(node);
            };
        }
        public function get path():Array{
            return (this._path);
        }
        public function manhattan(node:Node):Number{
            return ((Math.abs((node.x - this._endNode.x)) + Math.abs((node.y - this._endNode.y))));
        }
        public function manhattan2(node:Node):Number{
            var dx:Number = Math.abs((node.x - this._endNode.x));
            var dy:Number = Math.abs((node.y - this._endNode.y));
            return (((dx + dy) + (Math.abs((dx - dy)) / 1000)));
        }
        public function euclidian(node:Node):Number{
            var dx:Number = (node.x - this._endNode.x);
            var dy:Number = (node.y - this._endNode.y);
            return (Math.sqrt(((dx * dx) + (dy * dy))));
        }
        public function chineseCheckersEuclidian2(node:Node):Number{
            var y:int = (node.y / this.TwoOneTwoZero);
            var x:int = (node.x + (node.y / 2));
            var dx:Number = ((x - this._endNode.x) - (this._endNode.y / 2));
            var dy:Number = (y - (this._endNode.y / this.TwoOneTwoZero));
            return (this.sqrt(((dx * dx) + (dy * dy))));
        }
        private function sqrt(x:Number):Number{
            return (Math.sqrt(x));
        }
        public function euclidian2(node:Node):Number{
            var dx:Number = (node.x - this._endNode.x);
            var dy:Number = (node.y - this._endNode.y);
            return (((dx * dx) + (dy * dy)));
        }
        public function diagonal(node:Node):Number{
            var dx:Number = Math.abs((node.x - this._endNode.x));
            var dy:Number = Math.abs((node.y - this._endNode.y));
            var diag:Number = Math.min(dx, dy);
            var straight:Number = (dx + dy);
            return (((this._diagCost * diag) + (this._straightCost * (straight - (2 * diag)))));
        }

    }
}//package com.junlas.engine.map.astar 
