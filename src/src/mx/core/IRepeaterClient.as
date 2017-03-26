//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.core {

    public interface IRepeaterClient {

        function get instanceIndices():Array;
        function set instanceIndices(value:Array):void;
        function get isDocument():Boolean;
        function get repeaterIndices():Array;
        function set repeaterIndices(value:Array):void;
        function get repeaters():Array;
        function set repeaters(value:Array):void;
        function initializeRepeaterArrays(parent:IRepeaterClient):void;

    }
}//package mx.core 
