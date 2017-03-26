//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map.astar {

    public class Link {

        public var node:Node;
        public var cost:Number;

        public function Link(node:Node, cost:Number){
            super();
            this.node = node;
            this.cost = cost;
        }
    }
}//package com.junlas.engine.map.astar 
