// =================================================================================================
//
//	Created by Rodrigo Lopez [roipeker™] on 28/06/2018.
//
// =================================================================================================

package {
import starling.display.DisplayObjectContainer;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.text.TextFormat;
import starling.utils.Align;

public class TextFactory {

    public function TextFactory() {
    }

    public static function create(doc:DisplayObjectContainer = null, fontFace:String = null,
                                  size:Number = 25, color:uint = 0x4d4d4f,
                                  text:String = null,
                                  w:Number = -1, h:Number = -1,
                                  align:String = "left", leading:Number = 0,
                                  letterSpacing:Number = 0, debugSize:Boolean = false):TextField {
        var autoSize:String = "none";
        if (!fontFace) fontFace = Fonts.defaultFontFace;
        if (w == -1 && h == -1) {
            autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
            w = 0;
            h = 0;
        }
        if (w == -1) {
            autoSize = TextFieldAutoSize.HORIZONTAL;
            w = 0;
        }
        if (h == -1) {
            autoSize = TextFieldAutoSize.VERTICAL;
            h = 0;
        }

        var format:TextFormat = new TextFormat(fontFace, size, color);
        format.kerning = true;
        format.leading = leading;
        format.letterSpacing = letterSpacing;
        format.horizontalAlign = align;
        format.verticalAlign = Align.TOP;
        /*if (fontFace.toLowerCase().indexOf("bold") > -1) {
            format.bold = true;
        }*/
        var tf:TextField = new TextField(w, h, text, format);
        tf.isHtmlText = false;
        tf.autoSize = autoSize;
        tf.touchable = false;
        if (debugSize) {
            tf.border = true;
        }
        if (text && text.length < 30) {
            tf.batchable = true;
        }
        if (doc) {
            doc.addChild(tf);
        }
//        tf.visible = false;

//		_map.push( tf );
        return tf;
    }

}
}
