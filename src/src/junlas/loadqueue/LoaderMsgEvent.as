//Created by Action Script Viewer - http://www.buraks.com/asv
package junlas.loadqueue {
    import flash.events.*;

    public class LoaderMsgEvent extends Event {

        public static const EventName_Progress:String = "EventName_Progress";
        public static const EventName_Complete:String = "EventName_Complete";
        public static const EventName_Error:String = "EventName_Error";
        public static const EventName_OneComplete:String = "EventName_OneComplete";

        private var _data:Object;

        public function LoaderMsgEvent(type:String, data:Object){
            super(type, false, false);
            this._data = data;
        }
        public function get data():Object{
            return (this._data);
        }

    }
}//package junlas.loadqueue 
