package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;

using StringTools;

class Boyfriend extends Character
{
	public var stunned:Bool = false;
	public var pausad:Bool = false;
	// Fake pausa anim for replays
	public var fakepausa:Bool = false;

	private var iframes:Bool = false;
	private var itoggle:Bool = true;

	public function new(x:Float, y:Float, ?char:String = 'bf')
	{
		if (char != 'bf')
			this.pausad = false;
		super(x, y, char, true);
	}

	override function update(elapsed:Float)
	{
		if (!debugMode)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}
			else
				holdTimer = 0;

			if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debugMode)
			{
				playAnim('idle', true, false, 10);
			}

			if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished)
			{
				playAnim('deathLoop');
			}
		}
		itoggle = !itoggle;
		this.visible = !iframes || itoggle;

		super.update(elapsed);
	}

	public function iFrames(time:Float):Void
	{
		iframes = true;
		new FlxTimer().start(time, function(t:FlxTimer)
		{
			iframes = false;
		});
	}

	public function isInvincible():Bool
	{
		return iframes;
	}

	override function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		super.playAnim((pausad || fakepausa) ? 'pausad' : AnimName, Force, Reversed, Frame);
	}
}
