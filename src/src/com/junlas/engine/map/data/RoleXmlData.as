//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map.data {

    public class RoleXmlData {

        public var X:Number = 0;
        public var Y:Number = 0;
        public var dir:int = 1;
        public var Frame:int;
        public var Width:Number = 0;
        public var Height:Number = 0;
        public var Time:Number = 0;
        public var NameX:Number = 0;
        public var NameY:Number = 0;
        public var shadowX:Number = 0;
        public var shadowY:Number = 0;
        public var hitWidth:Number = 0;
        public var hitHeight:Number = 0;
        public var action:int;

        public function RoleXmlData(data:XML){
            var name:String;
            var val:String;
            super();
            var att:XMLList = data.attributes();
            for each (data in att) {
                name = data.name().toString();
                val = data.toString();
                if (this.hasOwnProperty(name)){
                    this[name] = val;
                };
            };
        }
    }
}//package com.junlas.engine.map.data 
