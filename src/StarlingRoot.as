// =================================================================================================
//
//	Created by Rodrigo Lopez [roipeker™] on 28/06/2018.
//
// =================================================================================================

package {
import com.roipeker.utils.adl.ScreenEmulator;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.Font;
import flash.text.StageText;
import flash.text.StageTextInitOptions;

import starling.assets.AssetManager;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.StringUtil;

public class StarlingRoot extends Sprite {

    private var assetMan:AssetManager;
    private var msg:String = "To see {0}, take a {1} to Russia. 😵";
    private var st:StageText;
    private var baseY:int = 50;

    private var stageTextImage:Image;

    public function StarlingRoot() {
        addEventListener(Event.ADDED_TO_STAGE, onAdded)
    }

    private function onAdded(event:Event):void {
        Fonts.init();
    }

    public function loaded(assets:AssetManager):void {
        assetMan = assets;
        initFonts();
    }

    private function initFonts():void {
        var plane:String = String.fromCharCode(1434);
        var ball:String = String.fromCharCode(1409);
        msg = StringUtil.format(msg, ball, plane);


        var ttf_tf:TextField = TextFactory.create(this, Fonts.OPENSANS_EMOJI, 22, 0x333333, msg, -1, -1);
        ttf_tf.x = 10;
        ttf_tf.y = baseY;

        var bmp_tf:TextField = TextFactory.create(this, Fonts.OPENSANS_EMOJI_BMP, 22, 0x222222, msg, -1, -1);
        bmp_tf.x = 10;
        bmp_tf.y = baseY + 100;


        stageTextImage = new Image(Texture.fromColor(32, 32, 0x0));
        stageTextImage.x = 10;
        stageTextImage.y = baseY + 300;
        addChild(stageTextImage);

        createInputText();

        validateEmoji(null);
    }


    function createInputText():void {
        var scale:Number = ScreenEmulator.instance.stageScale;
        var input_bg:Quad = new Quad(400, 50, 0xe4e4e4);
        addChild(input_bg);
        input_bg.x = 10;
        input_bg.y = baseY + 200;
        var r:Rectangle = input_bg.getBounds(stage);
        r.x *= scale;
        r.y *= scale;
        r.width *= scale;
        r.height *= scale;

        st = new StageText(new StageTextInitOptions(false));
        st.stage = AppUtils.stage;
        st.addEventListener("change", validateEmoji);
        st.fontSize = 22 * scale;
        // on OSX/Windows, you have to install it for ADL to detect it...
        st.fontFamily = "Open Sans Emoji";
        st.viewPort = r;
        st.text = msg;

    }

    private function validateEmoji(event:Object):void {
        var str:String = st.text;
        var emoji:String = "";
        for (var i:int = 0; i < str.length; i++) {
            var char:String = str.charAt(i);
            if (str.charCodeAt(i) > 0x2327) {
                emoji += char;
            } else {
                if (emoji != "") {
                    trace("Emoji code: U+" + AppUtils.charToUnicode(emoji).toString(16));
                }
                emoji = "";
                trace(char, "U+" + char.charCodeAt(0).toString(16));
            }
        }

        // todo: focus out on iOS before drawing
        var viewport:Rectangle = st.viewPort;
        var scale:Number = 1 / ScreenEmulator.instance.stageScale;
        var bd:BitmapData = new BitmapData(viewport.width * scale, viewport.height * scale, true, 0x22ff0000);
        st.drawViewPortToBitmapData(bd);
        var result:Texture = Texture.fromBitmapData(bd, false, false, Starling.contentScaleFactor);
        stageTextImage.texture = result;
        stageTextImage.readjustSize();
        bd.dispose();
    }

    //============================
    // test --
    //============================

    /**
     * I used this to create the charset input file for msdf-font
     */
    private function showEmojiFontChars():void {
        var f:Font = new Fonts.OpenSansEmoji();
        var output:String = "";
        // range of unicode values for the emojis i included.
        for (var i:int = 1355; i < 1912; i++) {
            var str:String = String.fromCharCode(i);
            if (f.hasGlyphs(str)) {
                output += str;
            }
        }
        trace("Chars:" + output);
    }
}

}
