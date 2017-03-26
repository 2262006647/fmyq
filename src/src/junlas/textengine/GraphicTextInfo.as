//Created by Action Script Viewer - http://www.buraks.com/asv
package junlas.textengine {
    import flash.text.engine.*;
    import flash.events.*;
    import flash.display.*;
    import __AS3__.vec.*;
    import flash.ui.*;
    import flash.system.*;
    import flash.geom.*;

    public class GraphicTextInfo implements IEventDispatcher {

        private var _textBlock:TextBlock;
        private var _eventDispatcher:EventDispatcher;
        private var _graphicTextContainer:Sprite;
        private var _textLineVect:Vector.<TextLine>;
        private var _allText:String;
        private var _selectable:Boolean = false;
        private var _selectColor:uint = 0xFF00;
        private var _startIndex:SelectableItem;
        private var _endIndex:SelectableItem;

        public function GraphicTextInfo(config:GraphicTextConfig){
            super();
            if (config){
                this._textBlock = new TextBlock();
                switch (config.engine_rotation){
                    case "0":
                        this._textBlock.lineRotation = TextRotation.ROTATE_0;
                        break;
                    case "90":
                        this._textBlock.lineRotation = TextRotation.ROTATE_90;
                        break;
                    case "180":
                        this._textBlock.lineRotation = TextRotation.ROTATE_180;
                        break;
                    case "270":
                        this._textBlock.lineRotation = TextRotation.ROTATE_270;
                        break;
                    default:
                        this._textBlock.lineRotation = TextRotation.AUTO;
                };
                this._eventDispatcher = new EventDispatcher();
                this._graphicTextContainer = new Sprite();
                this._textLineVect = new Vector.<TextLine>();
                this._graphicTextContainer.x = config.engine_x;
                this._graphicTextContainer.y = config.engine_y;
                this._allText = "";
            };
        }
        public function linkAllText(text:String):void{
            this._allText = (this._allText + text);
        }
        private function invalidate():void{
            this._eventDispatcher.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            this._eventDispatcher.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this._eventDispatcher.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            this._eventDispatcher.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
            this._graphicTextContainer.addEventListener(Event.COPY, this.onCopy);
        }
        private function disvalidate():void{
            this._eventDispatcher.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            this._eventDispatcher.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this._eventDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            this._eventDispatcher.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
            this._eventDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
            this._graphicTextContainer.removeEventListener(Event.COPY, this.onCopy);
        }
        protected function onMouseOut(event:MouseEvent):void{
            Mouse.cursor = MouseCursor.ARROW;
        }
        protected function onMouseOver(event:MouseEvent):void{
            Mouse.cursor = MouseCursor.IBEAM;
        }
        protected function onCopy(event:Event):void{
            var start:int;
            var end:int;
            var index:int;
            var disObj:DisplayObject;
            if (((!(this._startIndex)) || (!(this._endIndex)))){
                return;
            };
            var isWellSort:Boolean = (this._endIndex.rowIndex >= this._startIndex.rowIndex);
            var tempHasGraphicItemIndexVect:Vector.<int> = new Vector.<int>();
            var rowIndex:int = -1;
            var tl:TextLine = this._textBlock.firstLine;
            while (tl != null) {
                rowIndex++;
                index = -1;
                while (++index < tl.atomCount) {
                    disObj = tl.getAtomGraphic(index);
                    if (disObj){
                        tempHasGraphicItemIndexVect.push(tl.getAtomTextBlockBeginIndex(index));
                    };
                };
                tl = tl.nextLine;
            };
            if (isWellSort){
                start = this._startIndex.getTextBlockIndex();
                end = (this._endIndex.getTextBlockIndex() + 1);
            } else {
                start = (this._startIndex.getTextBlockIndex() + 1);
                end = this._endIndex.getTextBlockIndex();
            };
            var copyStr:String = this._allText.substring(start, end);
            System.setClipboard(copyStr);
        }
        private function checkSubStringIndex(selectableItemVect:Vector.<int>, start:int, end:int, isWellSort:Boolean):Array{
            var graphicItemIndex:int;
            for each (graphicItemIndex in selectableItemVect) {
                trace(graphicItemIndex);
                if (isWellSort){
                    if (graphicItemIndex > start){
                        start++;
                    };
                    if (graphicItemIndex <= end){
                        end++;
                    };
                } else {
                    if (graphicItemIndex <= start){
                        start++;
                    };
                    if (graphicItemIndex > end){
                        end++;
                    };
                };
            };
            return ([start, end]);
        }
        protected function onMouseDown(event:MouseEvent):void{
            var colIndex:int;
            this._eventDispatcher.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
            this.clearGraphic();
            if (this._graphicTextContainer.stage){
                this._graphicTextContainer.stage.focus = this._graphicTextContainer;
            };
            var rowIndex:int = -1;
            var tl:TextLine = this._textBlock.firstLine;
            while (tl != null) {
                rowIndex++;
                colIndex = tl.getAtomIndexAtPoint(event.stageX, event.stageY);
                if (colIndex > -1){
                    this._startIndex = new SelectableItem(tl, rowIndex, colIndex);
                    return;
                };
                tl = tl.nextLine;
            };
        }
        protected function onMouseUp(event:MouseEvent):void{
            this._eventDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
        }
        protected function onMouseMove(event:MouseEvent):void{
            var colIndex:int;
            if (!(event.buttonDown)){
                this.onMouseUp(null);
                return;
            };
            var rowIndex:int = -1;
            var tl:TextLine = this._textBlock.firstLine;
            while (tl != null) {
                rowIndex++;
                colIndex = tl.getAtomIndexAtPoint(event.stageX, event.stageY);
                if (colIndex > -1){
                    this._endIndex = new SelectableItem(tl, rowIndex, colIndex);
                    if (!(this._endIndex.equals(this._startIndex))){
                        this.draw();
                    };
                    return;
                };
                tl = tl.nextLine;
            };
        }
        private function draw():void{
            this.clearGraphic();
            if (this._startIndex.currTextLine == this._endIndex.currTextLine){
                this.drawGraphic(this._startIndex.currTextLine, this._startIndex.getAtomBounds(), this._endIndex.getAtomBounds());
                return;
            };
            var isWellSort:Boolean = (this._endIndex.rowIndex >= this._startIndex.rowIndex);
            var isDraw:Boolean;
            var tl:TextLine = (isWellSort) ? this._textBlock.firstLine : this._textBlock.lastLine;
            while (tl != null) {
                if (tl == this._startIndex.currTextLine){
                    if (isWellSort){
                        this.drawGraphic(this._startIndex.currTextLine, this._startIndex.getAtomBounds(), this._startIndex.getEndAtomBounds());
                    } else {
                        this.drawGraphic(this._startIndex.currTextLine, this._startIndex.getStartAtomBounds(), this._startIndex.getAtomBounds());
                    };
                    isDraw = true;
                } else {
                    if (tl == this._endIndex.currTextLine){
                        if (isWellSort){
                            ((isDraw) && (this.drawGraphic(this._endIndex.currTextLine, this._endIndex.getStartAtomBounds(), this._endIndex.getAtomBounds())));
                        } else {
                            ((isDraw) && (this.drawGraphic(this._endIndex.currTextLine, this._endIndex.getAtomBounds(), this._endIndex.getEndAtomBounds())));
                        };
                        break;
                    };
                    ((isDraw) && (this.drawGraphic(tl, tl.getAtomBounds(0), tl.getAtomBounds((tl.atomCount - 1)))));
                };
                tl = (isWellSort) ? tl.nextLine : tl.previousLine;
            };
        }
        private function drawGraphic(tl:TextLine, rectS:Rectangle, rectE:Rectangle):void{
            this._graphicTextContainer.graphics.beginFill(this._selectColor, 1);
            this._graphicTextContainer.graphics.drawRect((tl.x + rectS.x), (tl.y + rectS.y), ((rectE.x - rectS.x) + rectE.width), rectE.height);
            this._graphicTextContainer.graphics.endFill();
        }
        private function clearGraphic():void{
            this._graphicTextContainer.graphics.clear();
        }
        public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
            this._eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        public function dispatchEvent(event:Event):Boolean{
            return (this._eventDispatcher.dispatchEvent(event));
        }
        public function hasEventListener(type:String):Boolean{
            return (this._eventDispatcher.hasEventListener(type));
        }
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
            this._eventDispatcher.removeEventListener(type, listener, useCapture);
        }
        public function willTrigger(type:String):Boolean{
            return (this._eventDispatcher.willTrigger(type));
        }
        public function getTextBlock():TextBlock{
            return (this._textBlock);
        }
        public function getEventDispatcher():EventDispatcher{
            return (this._eventDispatcher);
        }
        public function getGraphicTextContainer():Sprite{
            return (this._graphicTextContainer);
        }
        public function getTextLineVect():Vector.<TextLine>{
            return (this._textLineVect);
        }
        public function set selectable(s:Boolean):void{
            this._selectable = s;
            if (this._selectable){
                this.invalidate();
            } else {
                this.disvalidate();
                this.clearGraphic();
            };
        }
        public function get selectable():Boolean{
            return (this._selectable);
        }
        public function set selectColor(s:uint):void{
            this._selectColor = s;
        }
        public function get selectColor():uint{
            return (this._selectColor);
        }
        public function destroy():void{
            this.clearGraphic();
            this.disvalidate();
            while (this._graphicTextContainer.numChildren) {
                this._graphicTextContainer.removeChildAt(0);
            };
            if (this._graphicTextContainer.parent){
                this._graphicTextContainer.parent.removeChild(this._graphicTextContainer);
            };
        }

    }
}//package junlas.textengine 
