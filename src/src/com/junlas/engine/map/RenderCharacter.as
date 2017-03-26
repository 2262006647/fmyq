//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map {
    import __AS3__.vec.*;
    import flash.events.*;

    public class RenderCharacter {

        private var _enterFrameVect:Vector.<Function>;

        public function RenderCharacter(){
            super();
            this._enterFrameVect = new Vector.<Function>();
            this.addEvent();
        }
        private function addEvent():void{
            StaticClass.stage.addEventListener(Event.ENTER_FRAME, this.run);
        }
        private function run(e:Event):void{
            var handler:Function;
            var i:int;
            while (i < this._enterFrameVect.length) {
                handler = this._enterFrameVect[i];
                if (handler){
                    handler.apply(null);
                };
                i++;
            };
        }
        public function setEnterFrameHandler(handler:Function):void{
            if (this._enterFrameVect.indexOf(handler) == -1){
                this._enterFrameVect.push(handler);
            };
        }

    }
}//package com.junlas.engine.map 
