//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map.astar {

    public class BinaryHeap {

        public var a:Array;
        public var justMinFun:Function;

        public function BinaryHeap(justMinFun:Function=null){
            this.a = [];
            this.justMinFun = function (x:Object, y:Object):Boolean{
                return ((x < y));
            };
            super();
            this.a.push(-1);
            if (justMinFun != null){
                this.justMinFun = justMinFun;
            };
        }
        public function ins(value:Object):void{
            var temp:Object;
            var p:int = this.a.length;
            this.a[p] = value;
            var pp:int = (p >> 1);
            while ((((p > 1)) && (this.justMinFun(this.a[p], this.a[pp])))) {
                temp = this.a[p];
                this.a[p] = this.a[pp];
                this.a[pp] = temp;
                p = pp;
                pp = (p >> 1);
            };
        }
        public function pop():Object{
            var minp:int;
            var temp:Object;
            var min:Object = this.a[1];
            this.a[1] = this.a[(this.a.length - 1)];
            this.a.pop();
            var p:int = 1;
            var l:int = this.a.length;
            var sp1:int = (p << 1);
            var sp2:int = (sp1 + 1);
            while (sp1 < l) {
                if (sp2 < l){
                    minp = (this.justMinFun(this.a[sp2], this.a[sp1])) ? sp2 : sp1;
                } else {
                    minp = sp1;
                };
                if (this.justMinFun(this.a[minp], this.a[p])){
                    temp = this.a[p];
                    this.a[p] = this.a[minp];
                    this.a[minp] = temp;
                    p = minp;
                    sp1 = (p << 1);
                    sp2 = (sp1 + 1);
                } else {
                    break;
                };
            };
            return (min);
        }

    }
}//package com.junlas.engine.map.astar 
