package game;

import flixel.math.FlxRect;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.geom.Matrix;
import openfl.display.BitmapData;

typedef BitmapDrawThing = {
    var data:BitmapData;
    var position:Point;
} 

/**
 * Helper class mainly for BitmapData stuffs
 */
class ImageUtils {
    /**
     * This function lets you combine your BitmapData mess to a single BitmapData.
     * @param list_bitmap idk, read BitmapDrawThing
     * @return BitmapData
     */
    public static function drawBitmapArray(list_bitmap:Array<BitmapDrawThing>):BitmapData {
        var maxWidth:Int = 0;
        var maxHeight:Int = 0;
        for (ine => i in list_bitmap){
            if (i == null) {
                trace("Error at " + ine);
                continue;
            }
            if (i.data == null) {
                trace("my man" + ine);
                continue;
            }
            maxWidth = Std.int(Math.max(maxWidth,i.data.width));
            maxHeight = Std.int(Math.max(maxHeight,i.data.height));
        }

        var canvas:BitmapData = new BitmapData(maxWidth,maxHeight, true, 0xFF000000);
        for (bitData in list_bitmap){
            var spr:Bitmap = new Bitmap(bitData.data);
            @:privateAccess
                canvas.draw(spr, new Matrix(spr.__transform.a,spr.__transform.b,spr.__transform.c,spr.__transform.d, bitData.position.x,bitData.position.y));
        }
        
        return canvas;
    }

    /**
     * Resizes your BitmapData using Nearest-neighbor method
     * 
     * @param toResize BitmapData that you want to resize
     * @param scaleX Scaling
     * @param scaleY Another scaling
     * @return BitmapData
     */
    public static function resizeBitmapData(toResize:BitmapData, scaleX:Float, scaleY:Float):BitmapData {
        var newWidth:Int = Std.int(toResize.width*scaleX);
        var newHeight:Int = Std.int(toResize.height*scaleY);
        var canvas:BitmapData = new BitmapData(newWidth, newHeight);
        
        for (y in 0...newHeight) {
            for (x in 0...newWidth) {
                var nearestX:Int = Std.int(Math.min(Std.int(x / scaleX), toResize.width - 1));
                var nearestY:Int = Std.int(Math.min(Std.int(y / scaleY), toResize.height - 1));
                canvas.setPixel32(x, y, toResize.getPixel32(nearestX, nearestY));
            }
        }
        return canvas;
    }

    public static function bitmapFillAndClip(toFit:BitmapData, width:Int, height:Int):BitmapData {
        var newScaleX:Float = width / toFit.width;
        var newScaleY:Float = height / toFit.height;
        var scale:Float = Math.max(newScaleX, newScaleY);
        var canvas:BitmapData = resizeBitmapData(toFit, scale, scale);
        
        var clippedBitmap:BitmapData = new BitmapData(width, height);
        
        var offsetX:Int = cast Math.max(0, (canvas.width - width) / 2);
        var offsetY:Int = cast Math.max(0, (canvas.height - height) / 2);
    
        clippedBitmap.copyPixels(canvas, new Rectangle(offsetX, offsetY, width, height), new Point(0, 0));
        return clippedBitmap;
    }
    
}