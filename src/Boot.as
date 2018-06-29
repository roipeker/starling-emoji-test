package {

import com.roipeker.utils.adl.ScreenEmulator;
import com.roipeker.utils.adl.collections.DeviceBrands;
import com.roipeker.utils.adl.ui.DeviceUI;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;

import starling.assets.AssetManager;
import starling.core.Starling;

[SWF(width="400", height="400", backgroundColor="#FFFFFF", frameRate="60")]
public class Boot extends Sprite {

    private var starling:Starling;

    public function Boot() {
        AppUtils.init(stage, onLoaderInfoComplete);
    }

    private function onLoaderInfoComplete():void {
        ScreenEmulator.instance.init(stage, -30, -30, true, ScreenEmulator.ORIENTATION_PORTRAIT);
        ScreenEmulator.instance.emulate(DeviceBrands.apple.ipad_2);
//        starling = new Starling(StarlingRoot, stage, screenSetup.viewPort);
        starling = new Starling(StarlingRoot, stage, ScreenEmulator.instance.getViewPort());
        starling.skipUnchangedFrames = true;
        starling.supportHighResolutions = true;
        starling.stage.stageWidth = ScreenEmulator.instance.stageWidthPoints;
        starling.stage.stageHeight = ScreenEmulator.instance.stageHeightPoints;
//        starling.stage.stageWidth = screenSetup.stageWidth;
//        starling.stage.stageHeight = screenSetup.stageHeight;
        starling.addEventListener("rootCreated", onRooterCreated);
        starling.start();

        stage.addEventListener(Event.RESIZE, onStageResize, false, 1);
    }

    private function onStageResize(event:Event):void {
        var viewport:Rectangle = starling.viewPort;
        viewport.setTo(0, 0, stage.stageWidth, stage.stageHeight);
        starling.viewPort = viewport;
        starling.stage.stageWidth = stage.stageWidth;
        starling.stage.stageHeight = stage.stageHeight;
    }

    private function onRooterCreated(event:Object, main:StarlingRoot):void {
        var assetManager:AssetManager = new AssetManager(1);
        assetManager.enqueue(AppUtils.appDir.resolvePath('assets'));
        assetManager.loadQueue(function () {
            main.loaded(assetManager);
        });

        DeviceUI.instance.transparentStatusbarBackground = true;
        starling.stage.addChild(DeviceUI.instance);
    }


    public static function testUnicodeChars():void {
//        var str:String = "🌝";
//        var str:String = "🌜";
//        var str:String = "🍐";
//        var str:String = "🏈";
//        var str:String = "👨";
//        var str:String = "👎";
        var str:String = "🙊";

        // emojis are detected as several chars.
        trace("num chars:", str.length);
        var len:int = str.length;
        var total:int = 0;
        for (var i:int = 0; i < len; i++) {
            var code:Number = str.charCodeAt(i);
            trace(code, code.toString(16));
            total += code;
        }

        // gives incorrect value...
//        trace(total.toString(16));

        // using unicode: (https://gist.github.com/MorbZ/5726339)
        trace("real unicode value: U+" + AppUtils.charToUnicode(str));
    }
}
}
