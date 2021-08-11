package;

import flixel.FlxSprite;

class NoteSplash extends FlxSprite
{
	public function new(X:Float, Y:Float, direction:Int)
	{
		super(X, Y);
		frames = Paths.getSparrowAtlas('notesplash', 'shared');
		animation.addByPrefix('idle', 'notesplash', 36, false);
		scale.set(1.08, 1.08);
		antialiasing = true;
		alpha = 0.69;

		var myOffset:Int = -20;

		updateHitbox();
		if (direction == 0 || direction == 3)
			offset.set(0.291 * this.width + myOffset, 0.315 * this.height + myOffset);
		else
			offset.set(0.33 * this.width + myOffset, 0.315 * this.height + myOffset);
		animation.play('idle');

		animation.finishCallback = function(t)
		{
			kill();
		}
	}
}
