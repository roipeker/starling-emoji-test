// =================================================================================================
//
//	Created by Rodrigo Lopez [roipeker™] on 28/06/2018.
//
// =================================================================================================

package {
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.filesystem.File;
import flash.utils.ByteArray;

public class AppUtils {

    public static var outputFolder:String = 'bin';
    public static var adlAppDir:String = 'bin-assets';

    private static var _stage:Stage;
    private static var _isADL:Boolean;
    private static var _appDir:File;

    public function AppUtils() {
    }

    public static function init(stage:Stage, onLoaderInfoComplete:Function = null):void {
        _stage = stage;
        _stage.scaleMode = StageScaleMode.NO_SCALE;
        _stage.align = StageAlign.TOP_LEFT;
        if (onLoaderInfoComplete) {
            _stage.loaderInfo.content.loaderInfo.addEventListener(Event.COMPLETE, _loaderInfoComplete);

            function _loaderInfoComplete(e:Event):void {
                onLoaderInfoComplete();
            }
        }

        // -- init app folder for production and adl --
        _appDir = File.applicationDirectory;
        _isADL = _appDir.name == outputFolder;
        if (_isADL) {
            _appDir = new File(_appDir.nativePath).parent.resolvePath(adlAppDir);
        }
    }

    public static function get stage():Stage {
        return _stage;
    }

    public static function get isADL():Boolean {
        return _isADL;
    }

    public static function get appDir():File {
        return _appDir;
    }



    private static var bytes:ByteArray = new ByteArray();

    public static function charToUnicode(char:String):uint {
        //init byte array
        bytes.clear();
        bytes.writeUTFBytes(char);
        bytes.position = 0;

        //how many bytes?
        var n_bytes:int = 0;
        var b:uint = bytes.readUnsignedByte();
        var start:uint = 0;
        if(bytes.length == 1 && (b & 0x80) == 0) {
            //1 byte (0xxxxxxx)
            //return without changes
            return b;
        } else if(bytes.length == 2 && (b & 0xE0) == 0xC0) {
            //2 bytes (110xxxxx 10xxxxxx)
            n_bytes = 2;
            start = b & 0x1F;
        } else if(bytes.length == 3 && (b & 0xF0) == 0xE0) {
            //3 bytes (1110xxxx 10xxxxxx 10xxxxxx)
            n_bytes = 3;
            start = b & 0xF;
        } else if(bytes.length == 4 && (b & 0xF8) == 0xF0) {
            //4 bytes (11110xxx 10xxxxxx 10xxxxxx 10xxxxxx)
            n_bytes = 4;
            start = b & 0x7;
        } else {
            //invalid
            return 0;
        }

        //add starting bits
        var code:uint = 0;
        code |= start;

        //add following bytes
        bytes.position = 1;
        while(bytes.position < bytes.length) {
            b = bytes.readUnsignedByte();
            code <<= 6;
            code |= b & 0x3F;
        }
        return code;
    }
}
}
