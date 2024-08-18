package game.system;

import lime.graphics.Image;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import lime.graphics.cairo.CairoImageSurface;

class FunkinBitmap extends BitmapData {
	@:noCompletion private override function __fromImage(image:#if lime Image #else Dynamic #end):Void
	{
		#if lime
		if (image != null && image.buffer != null)
		{
			this.image = image;

			width = image.width;
			height = image.height;
			rect = new Rectangle(0, 0, image.width, image.height);

			__textureWidth = width;
			__textureHeight = height;

			#if sys
			image.format = BGRA32;
			image.premultiplied = true;
			#end

			__isValid = true;
			readable = true;

			if(FlxG.stage.context3D != null) {
				lock();
				getTexture(FlxG.stage.context3D);
				getSurface();

				readable = true;
				this.image = null;
			}
		}
		#end
	}

	public override function getSurface():#if lime CairoImageSurface #else Dynamic #end
	{
		#if lime
		if (__surface == null)
		{
			__surface = CairoImageSurface.fromImage(image);
		}

		return __surface;
		#else
		return null;
		#end
	}
}