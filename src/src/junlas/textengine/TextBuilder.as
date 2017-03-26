//Created by Action Script Viewer - http://www.buraks.com/asv
package junlas.textengine {
    import __AS3__.vec.*;
    import flash.text.engine.*;
    import flash.errors.*;

    public class TextBuilder {

        private var _config:GraphicTextConfig;
        private var _graphicTextInfoVect:Vector.<GraphicTextInfo>;
        private var _generateTextInfoVect:Vector.<GenerateTextInfo>;

        public function TextBuilder(config:GraphicTextConfig=null){
            super();
            this._config = config;
            this._graphicTextInfoVect = new Vector.<GraphicTextInfo>();
            this._generateTextInfoVect = new Vector.<GenerateTextInfo>();
        }
        public function createGraphicText(sections:Vector.<SectionElement>):GraphicTextInfo{
            var sectionEle:SectionElement;
            var groupElement:GroupElement;
            var graphicInfoTextBlock:TextBlock;
            var textLine:TextLine;
            var xPos:Number;
            var yPos:Number;
            var isFirstRow:Boolean;
            var contentEle:ContentElement;
            var graphicInfo:GraphicTextInfo = new GraphicTextInfo(this._config);
            this._graphicTextInfoVect.push(graphicInfo);
            var groupVector:Vector.<ContentElement> = new Vector.<ContentElement>();
            for each (sectionEle in sections) {
                contentEle = sectionEle.getTextElement();
                if ((contentEle is GraphicElement)){
                    if (GraphicElement(contentEle).elementWidth > this._config.engine_width){
                        throw (new IllegalOperationError("GraphicWidth显示宽带大于EngineWidth,显示可能异常"));
                    };
                } else {
                    graphicInfo.linkAllText(TextElement(contentEle).text);
                };
                groupVector.push(contentEle);
            };
            groupElement = new GroupElement(groupVector);
            groupElement.eventMirror = graphicInfo.getEventDispatcher();
            graphicInfoTextBlock = graphicInfo.getTextBlock();
            graphicInfoTextBlock.content = groupElement;
            textLine = null;
            xPos = 0;
            yPos = 0;
            isFirstRow = true;
            while (true) {
                textLine = graphicInfoTextBlock.createTextLine(textLine, this._config.engine_width);
                if (!(textLine)){
                    break;
                };
                switch (graphicInfoTextBlock.lineRotation){
                    case TextRotation.ROTATE_90:
                    case TextRotation.ROTATE_270:
                        xPos = (xPos + (textLine.x + this._config.engine_line_spacing));
                        if (isFirstRow){
                            xPos = textLine.width;
                            isFirstRow = false;
                        };
                        textLine.x = xPos;
                        break;
                    default:
                        yPos = (yPos + (textLine.y + this._config.engine_line_spacing));
                        if (isFirstRow){
                            yPos = textLine.height;
                            isFirstRow = false;
                        };
                        textLine.y = yPos;
                };
                graphicInfo.getGraphicTextContainer().addChild(textLine);
                graphicInfo.getTextLineVect().push(textLine);
            };
            return (graphicInfo);
        }
        public function createGenerateText(str:String, textWidth:Number, lineSpace:Number, fontSize:int=12, fontColor:uint=0xFFFFFF, fontAlpha:Number=1, fontName:String="宋体", isDevice:Boolean=true):GenerateTextInfo{
            var generateInfo:GenerateTextInfo = new GenerateTextInfo();
            this._generateTextInfoVect.push(generateInfo);
            var fontDesc:FontDescription = new FontDescription(fontName);
            if (isDevice){
                fontDesc.fontLookup = FontLookup.DEVICE;
            } else {
                fontDesc.fontLookup = FontLookup.EMBEDDED_CFF;
            };
            var format:ElementFormat = new ElementFormat(fontDesc, fontSize, fontColor, fontAlpha);
            var textEle:TextElement = new TextElement(str, format);
            var textBlock:TextBlock = new TextBlock(textEle);
            var textLine:TextLine;
            var yPos:Number = 0;
            var isFirstRow:Boolean = true;
            while (true) {
                textLine = textBlock.createTextLine(textLine, textWidth);
                if (!(textLine)){
                    break;
                };
                yPos = (yPos + (textLine.y + lineSpace));
                if (isFirstRow){
                    yPos = textLine.height;
                    isFirstRow = false;
                };
                textLine.y = yPos;
                generateInfo.getGenerateTextContainer().addChild(textLine);
            };
            return (generateInfo);
        }
        public function destroyGraphicText():void{
            while (this._graphicTextInfoVect.length) {
                this._graphicTextInfoVect.pop().destroy();
            };
        }
        public function destroyGenerateText():void{
            while (this._generateTextInfoVect.length) {
                this._generateTextInfoVect.pop().destroy();
            };
        }
        public function destroy():void{
            this.destroyGraphicText();
            this.destroyGenerateText();
        }

    }
}//package junlas.textengine 
