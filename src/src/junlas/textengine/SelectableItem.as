//Created by Action Script Viewer - http://www.buraks.com/asv
package junlas.textengine {
    import flash.text.engine.*;
    import flash.geom.*;

    public class SelectableItem {

        private var _currTextLine:TextLine;
        private var _rowIndex:int;
        private var _colIndex:int;

        public function SelectableItem(currTextLine:TextLine, rowIndex:int, colIndex:int){
            super();
            this._currTextLine = currTextLine;
            this._rowIndex = rowIndex;
            this._colIndex = colIndex;
        }
        public function get currTextLine():TextLine{
            return (this._currTextLine);
        }
        public function get rowIndex():int{
            return (this._rowIndex);
        }
        public function get colIndex():int{
            return (this._colIndex);
        }
        public function getAtomBounds():Rectangle{
            return (this._currTextLine.getAtomBounds(this._colIndex));
        }
        public function equals(item:SelectableItem):Boolean{
            if ((((((this._currTextLine == item._currTextLine)) && ((this._rowIndex == item._rowIndex)))) && ((this._colIndex == item._colIndex)))){
            };
            return (false);
        }
        public function getEndAtomBounds():Rectangle{
            return (this._currTextLine.getAtomBounds((this._currTextLine.atomCount - 1)));
        }
        public function getStartAtomBounds():Rectangle{
            return (this._currTextLine.getAtomBounds(0));
        }
        public function getTextBlockIndex():int{
            return (this._currTextLine.getAtomTextBlockBeginIndex(this._colIndex));
        }

    }
}//package junlas.textengine 
