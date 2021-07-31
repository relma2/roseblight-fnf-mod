import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame;
import flixel.graphics.tile.FlxDrawTilesItem;
import flixel.math.FlxPoint;
import flixel.math.FlxPoint.FlxCallbackPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;

using flixel.util.FlxColorTransformUtil;

class FlxTileBackdrop extends FlxBackdrop
{
	override function regenGraphic():Void
	{
		var sx:Float = Math.abs(scale.x);
		var sy:Float = Math.abs(scale.y);

		var ssw:Int = Std.int(_scrollW * sx);
		var ssh:Int = Std.int(_scrollH * sy);

		var w:Int = ssw;
		var h:Int = ssh;

		var frameBitmap:BitmapData = null;

		if (_repeatX)
			w += FlxG.width;
		if (_repeatY)
			h += FlxG.height;

		if (FlxG.renderBlit)
		{
			if (graphic == null || (graphic.width != w || graphic.height != h))
			{
				makeGraphic(w, h, FlxColor.TRANSPARENT, true);
			}
		}
		else
		{
			_tileInfo = [];
			_numTiles = 0;

			width = frameWidth = w;
			height = frameHeight = h;
		}

		_ppoint.x = -w;
		_ppoint.y = -h;

		if (FlxG.renderBlit)
		{
			pixels.lock();
			_flashRect2.setTo(0, 0, graphic.width, graphic.height);
			pixels.fillRect(_flashRect2, FlxColor.TRANSPARENT);
			_matrix.identity();
			_matrix.scale(sx, sy);
			frameBitmap = _tileFrame.paint();
		}

		while (_ppoint.y < h)
		{
			while (_ppoint.x < w)
			{
				if (FlxG.renderBlit)
				{
					pixels.draw(frameBitmap, _matrix);
					_matrix.tx += ssw;
				}
				else
				{
					_tileInfo.push(_ppoint.x);
					_tileInfo.push(_ppoint.y);
					_numTiles++;
				}
				_ppoint.x += ssw;
			}
			if (FlxG.renderBlit)
			{
				_matrix.tx = 0;
				_matrix.ty += ssh;
			}

			_ppoint.x = -w;
			_ppoint.y += ssh;
		}

		if (FlxG.renderBlit)
		{
			frameBitmap.dispose();
			pixels.unlock();
			dirty = true;
			calcFrame();
		}
	}
}
