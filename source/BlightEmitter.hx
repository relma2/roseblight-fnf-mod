package;

import flixel.math.FlxRandom;
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

	public function new(X, Y)
	{
		super();
		this.x = X;
		this._centerX = x;
		this.y = Y;
		this._wave = new FlxRandom().bool();
	}

	override function onEmit():Void
	{
		this._centerX = this.x;
		this._wave = new FlxRandom().bool();
		var b:String = new FlxRandom().bool() ? "0" : "1";
		this.loadGraphic(Paths.image("particle" + b, "shared"));
		this.updateFramePixels();
	}
}
