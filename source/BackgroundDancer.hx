package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class BackgroundDancer extends FlxSprite
{
	public function new(x:Float, y:Float, week:Int = 4)
	{
		super(x, y);
		var path:String = "limo/limoDancer";
		var name:String = "bg dancer sketch PINK";

		if (week == 7)
		{
			path = "griswell/barbleDancer";
			name = "barble_instance";
		}
		frames = Paths.getSparrowAtlas(path, "week" + week);
		animation.addByIndices('danceLeft', name, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		animation.addByIndices('danceRight', name, [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		animation.play('danceLeft');
		antialiasing = true;
	}

	var danceDir:Bool = false;

	public function dance():Void
	{
		danceDir = !danceDir;

		if (danceDir)
			animation.play('danceRight', true);
		else
			animation.play('danceLeft', true);
	}
}
