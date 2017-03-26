//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map.scene {
    import com.junlas.engine.map.*;

    public class MapCamera {

        private var _mapScene:IMapScene;

        public function MapCamera(mapScene:IMapScene){
            super();
            this._mapScene = mapScene;
        }
        public function cameraFocus(characterX:Number, characterY:Number):void{
            var halfScreenX:Number = (this.screenWidth >> 1);
            var offsetWidth:Number = (halfScreenX - characterX);
            var minOffsetWidth:Number = (this.screenWidth - this._mapScene.getSceneWidth());
            if (offsetWidth < 0){
                if (offsetWidth < minOffsetWidth){
                    offsetWidth = minOffsetWidth;
                };
                this._mapScene.setX(offsetWidth);
            };
            if (offsetWidth > minOffsetWidth){
                if (offsetWidth > 0){
                    offsetWidth = 0;
                };
                this._mapScene.setX(offsetWidth);
            };
            var halfScreenY:Number = (this.screenHeight >> 1);
            var offsetHeight:Number = (halfScreenY - characterY);
            var minOffsetHeight:Number = (this.screenHeight - this._mapScene.getSceneHeight());
            if (offsetHeight < 0){
                if (offsetHeight < minOffsetHeight){
                    offsetHeight = minOffsetHeight;
                };
                this._mapScene.setY(offsetHeight);
            };
            if (offsetHeight > minOffsetHeight){
                if (offsetHeight > 0){
                    offsetHeight = 0;
                };
                this._mapScene.setY(offsetHeight);
            };
        }
        public function focus(obj:CharacterObject):void{
            obj.setCameraFocus(this.cameraFocus);
        }
        public function get screenWidth():Number{
            return (StaticClass.stage.stageWidth);
        }
        public function get screenHeight():Number{
            return (StaticClass.stage.stageHeight);
        }

    }
}//package com.junlas.engine.map.scene 
