package;

import flixel.tweens.FlxEase;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import flixel.math.FlxMath;
import flixel.util.helpers.FlxRange;
import flixel.effects.particles.FlxParticle;
import flixel.FlxSprite;

using BlightParticle.RangeExtender;

class RangeExtender
{
	static public function pickRandom(r:FlxRange<Float>)
	{
		return new FlxRandom().float(r.start, r.end);
	}
}

// Instantiates a cross or circle-shaped pixelly particle in the style of RB:
// moves it up while oscillating randomly along the x axis
// fades after a set randomized lifespan
class BlightParticle extends FlxParticle
{
	public static var LIFESCALE:Float = 7.0;

	private var wave:Bool;
	private var centerX:Float;
	private var prevElapsed:Float;

	public function new(X:Float, Y:Float, scale:FlxRange<Float>, lifespan:FlxRange<Float>)
	{
		trace("relma2 -- entered bparticle cnstructor");
		super();
		this.loadGraphic(Paths.image("particle0", "shared"));
		// what fucking unit is lifespan in
		this.lifespan = lifespan.pickRandom() * LIFESCALE;
		this.setGraphicSize(Std.int(this.width * scale.pickRandom()));
		this.centerX = X;
		this.x = centerX;
		this.y = Y;
		this.wave = new FlxRandom().bool();
		trace("relma2 -- spriteattributes set");

		this.exists = true;
		this.moves = true;

		trace("relma2 -- blight particle attributes set");
		trace("relma2 -- lifespan is  " + this.lifespan);

		FlxTween.tween(this, {y: Y - 300}, this.lifespan, {
			ease: FlxEase.circOut
		});

		trace("relma2 -- tweens set");
	}

	private function oscillate(elapsed:Float):Void
	{
		if (wave)
		{
			this.x = centerX + 50 * FlxMath.fastSin(elapsed);
		}
		else
		{
			this.x = centerX + 50 * FlxMath.fastCos(elapsed);
		}
		this.updateHitbox();
	}

	override function update(elapsed:Float)
	{
		var time:Float = (prevElapsed + elapsed) % (2 * 3.14159265358979);
		oscillate(time);
		super.update(elapsed);
		prevElapsed = time;
	}
}
