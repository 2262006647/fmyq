//Created by Action Script Viewer - http://www.buraks.com/asv
package com.junlas.engine.map.scene {
    import com.junlas.engine.map.*;
    import flash.display.*;

    public class MapGridNode extends Sprite {

        public function MapGridNode(xposIndex:int, yposIndex:int, nodeValue:int){
            super();
            this.x = ((xposIndex + 0.5) * StaticClass.gridCellSize);
            this.y = ((yposIndex + 0.5) * StaticClass.gridCellSize);
            if (nodeValue == 1){
                this.graphics.beginFill(153);
            } else {
                if (nodeValue == 2){
                    this.graphics.beginFill(65433);
                } else {
                    this.graphics.beginFill(0x66FF00);
                };
            };
            this.graphics.moveTo((-(StaticClass.gridCellSize) / 2), (-(StaticClass.gridCellSize) / 2));
            this.graphics.lineStyle(1, 12401007);
            this.graphics.lineTo((StaticClass.gridCellSize / 2), (-(StaticClass.gridCellSize) / 2));
            this.graphics.lineTo((StaticClass.gridCellSize / 2), (StaticClass.gridCellSize / 2));
            this.graphics.lineTo((-(StaticClass.gridCellSize) / 2), (StaticClass.gridCellSize / 2));
            this.graphics.lineTo((-(StaticClass.gridCellSize) / 2), (-(StaticClass.gridCellSize) / 2));
            this.alpha = 0.4;
        }
    }
}//package com.junlas.engine.map.scene 
