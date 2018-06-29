// =================================================================================================
//
//	Created by Rodrigo Lopez [roipeker™] on 28/06/2018.
//
// =================================================================================================

package {
import flash.text.Font;

public class Fonts {

    [Embed(source="../bin-assets/fonts/OpenSans-Regular-Emoji.ttf", fontFamily="OpenSansEmoji", fontWeight="normal", fontStyle="normal", mimeType="application/x-font", embedAsCFF="false")]
    public static const OpenSansEmoji:Class;

    public static var OPENSANS_EMOJI:String;

    // distance field font.
    public static var OPENSANS_EMOJI_BMP:String = "OpenSans-Regular-Emoji-Bitmap";

    public static var defaultFontFace:String;

    public function Fonts() {
    }

    public static function init():void {
        OPENSANS_EMOJI = Font(new OpenSansEmoji()).fontName;
        defaultFontFace = OPENSANS_EMOJI;
        trace("TTF Emoji font name:", OPENSANS_EMOJI);
    }

}
}
