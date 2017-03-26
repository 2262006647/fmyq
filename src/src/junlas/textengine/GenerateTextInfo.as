//Created by Action Script Viewer - http://www.buraks.com/asv
package junlas.textengine {
    import flash.display.*;

    public class GenerateTextInfo {

        private var _generateTextContainer:Sprite;

        public function GenerateTextInfo(){
            super();
            this._generateTextContainer = new Sprite();
            this._generateTextContainer.mouseChildren = (this._generateTextContainer.mouseEnabled = false);
        }
        public function getGenerateTextContainer():Sprite{
            return (this._generateTextContainer);
        }
        public function destroy():void{
            while (this._generateTextContainer.numChildren) {
                this._generateTextContainer.removeChildAt(0);
            };
            if (this._generateTextContainer.parent){
                this._generateTextContainer.parent.removeChild(this._generateTextContainer);
            };
        }

    }
}//package junlas.textengine 
