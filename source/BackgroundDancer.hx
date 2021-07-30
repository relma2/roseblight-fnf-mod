package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class BackgroundDancer extends FlxSprite implements SpriteOffsetting
{
	public var animOffsets:Map<String, Array<Float>>;

	public function new(x:Float, y:Float, week:Int = 4)
	{
		super(x, y);
		animOffsets = new Map<String, Array<Float>>();
		var offX:Int = 0;
		var offY:Int = 0;
		var path:String = "limo/limoDancer";
		var name:String = "bg dancer sketch PINK";
		if (week == 7)
		{
			path = "griswell/barbleDancer";
			name = "barble_instance";
			offX = -10;
		}
		frames = Paths.getSparrowAtlas(path, "week" + week);
		animation.addByIndices('danceLeft', name, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		animation.addByIndices('danceRight', name, [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		addOffset('danceRight', 1.0 * offX, 1.0 * offY);
		playAnim('danceLeft');
		antialiasing = true;
	}

	var danceDir:Bool = false;

	public function dance():Void
	{
		danceDir = !danceDir;

		if (danceDir)
			playAnim('danceRight', true);
		else
			playAnim('danceLeft', true);
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0)
	{
		animation.play(AnimName, Force, Reversed, Frame);
		offset.set(animOffsets.exists(AnimName) ? animOffsets.get(AnimName)[0] : 0, animOffsets.exists(AnimName) ? animOffsets.get(AnimName)[1] : 0);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
