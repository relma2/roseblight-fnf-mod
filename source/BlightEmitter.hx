package;

import flixel.util.helpers.FlxBounds;
import flixel.math.FlxRandom;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter.FlxEmitterMode;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;

class BlightEmitter extends FlxTypedEmitter<BlightParticle>
{
	private var _chainWidth:Float;

	public var scrollFactor:FlxPoint;

	public function new(X:Float, Y:Float, quantity:Int, chain:FlxSprite)
	{
		super(X, Y, quantity);
		this._chainWidth = chain.width;
		this.launchMode = FlxEmitterMode.SQUARE;
		this.blend = HARDLIGHT;
		this.velocity.set(-_chainWidth / 1.5, -450, _chainWidth / 1.5, -350, 0, -50, 0, -20);
		this.alpha.set(0.7, 0.8, 0.3, 0.5);
		this.scrollFactor = new FlxPoint(chain.scrollFactor.x, chain.scrollFactor.y);
	}

	public function createParticles(quantity:Int = -1)
	{
		if (quantity < 0)
			quantity = this._quantity;

		for (i in 0...quantity)
		{
			var p = Type.createInstance(BlightParticle, [this.x, this.y]);
			this.add(p);
		}
	}

	override function emitParticle()
	{
		var p:BlightParticle;
		p = super.emitParticle();
		p.x += new FlxRandom().float(-_chainWidth / 2, _chainWidth / 2);
		p.scrollFactor.set(this.scrollFactor.x, this.scrollFactor.y);
		return p;
	}
}

class BlightParticle extends FlxParticle
{
	private var _centerX:Float;
	private var _wave:Bool;
	private var prevElapsed:Float = 0;

	public var amplitude:Float;

	public function new(X, Y)
	{
		super();
		this.x = X;
		this._centerX = x;
		this.y = Y;
		this.antialiasing = false;
		this._wave = new FlxRandom().bool();
		this.amplitude = new FlxRandom().float(25, 30);
		this.loadGraphic(Paths.image("particle0", "shared"));
	}

	private function oscillate(elapsed:Float):Float
	{
		if (_wave)
		{
			return _centerX + amplitude * FlxMath.fastSin(elapsed);
		}
		else
		{
			return _centerX + amplitude * FlxMath.fastCos(elapsed);
		}
	}

	override function update(elapsed:Float):Void
	{
		this.x = _centerX;
		super.update(elapsed);
		prevElapsed = prevElapsed + elapsed < 6.3 ? prevElapsed + elapsed : (prevElapsed + elapsed) % (2 * Math.PI);
		_centerX = this.x;
		this.x = oscillate(prevElapsed);
	}

	override function onEmit():Void
	{
		this._centerX = this.x;
		var b:String = new FlxRandom().bool() ? "0" : "1";
		this.loadGraphic(Paths.image("particle" + b, "shared"));
		this.updateFramePixels();
	}
}
