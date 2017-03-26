//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map.astar {

    public class Node {

        public var x:int;
        public var y:int;
        public var f:Number;
        public var g:Number;
        public var h:Number;
        public var walkable:Boolean = true;
        public var parent:Node;
        public var version:int = 1;
        public var links:Array;
        public var value:int;

        public function Node(x:int, y:int){
            super();
            this.x = x;
            this.y = y;
        }
    }
}//package com.junlas.engine.map.astar 
