package;

import flixel.graphics.frames.FlxFramesCollection;
import PlayState;
import Paths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;

using StringTools;

#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var warning:Bool = false;
	public var penalty:Null<Int>;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var modifiedByLua:Bool = false;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var rating:String = "shit";

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?inCharter:Bool = false, ?isWarning:Bool = false,
			?gottaHit:Bool = false)
	{
		super();
		this.warning = isWarning;
		this.mustPress = gottaHit;

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		if (inCharter)
			this.strumTime = strumTime;
		else
			this.strumTime = Math.round(strumTime);

		if (this.strumTime < 0)
			this.strumTime = 0;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		// defaults if no noteStyle was found in chart
		var noteTypeCheck:String = 'normal';

		// Randomly convert normal notes that occur on whole beat numbers
		// into warns. DEATH TO like, everyone i guess... im not very good
		// at sadistic battle cries.
		// BOW DOWN TO THE CHAIN HIMBO.
		var diffculty:String = CoolUtil.difficultyFromInt(PlayState.storyDifficulty);
		var EPSILON:Float = 3.5;
		var probability:Int;
		var myPenalty:Int = 0;
		switch (diffculty.toLowerCase())
		{
			case 'easy':
				probability = 20;
				myPenalty = 2;
			case 'medium':
				probability = 35;
				myPenalty = 3;
			case 'normal':
				probability = 35;
				myPenalty = 3;
			case 'hard':
				probability = 50;
				// uncomment the following line to make every whole beat note pausa
				// i mean you get TWO chain doms for the price of one >:)
				// probability = 100;
				// ORRR... uncomment this line for EVERY note to be a freeze note
				// probability = 777;
				myPenalty = 4;
			default:
				probability = 50;
				myPenalty = 3;
		}

		if (mustPress && !warning && (probability == 777 || (strumTime % Conductor.crochet) < EPSILON))
		{
			if (probability == 777 || new FlxRandom().bool(probability))
			{
				warning = true;
				this.penalty = myPenalty;
			}
		}

		if (PlayState.SONG.noteStyle == null)
		{
			switch (PlayState.storyWeek)
			{
				case 6:
					noteTypeCheck = 'pixel';
			}
		}
		else
		{
			noteTypeCheck = PlayState.SONG.noteStyle;
		}

		if (!warning)
		{
			switch (noteTypeCheck)
			{
				case 'pixel':
					loadGraphic(Paths.image('weeb/`pixelUI/arrows-pixels', 'week6'), true, 17, 17);

					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);

					if (isSustainNote)
					{
						loadGraphic(Paths.image('weeb/pixelUI/arrowEnds', 'week6'), true, 7, 6);

						animation.add('purpleholdend', [4]);
						animation.add('greenholdend', [6]);
						animation.add('redholdend', [7]);
						animation.add('blueholdend', [5]);

						animation.add('purplehold', [0]);
						animation.add('greenhold', [2]);
						animation.add('redhold', [3]);
						animation.add('bluehold', [1]);
					}

					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
				default:
					frames = Paths.getSparrowAtlas('NOTE_assets');

					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');

					animation.addByPrefix('purpleholdend', 'pruple end hold');
					animation.addByPrefix('greenholdend', 'green hold end');
					animation.addByPrefix('redholdend', 'red hold end');
					animation.addByPrefix('blueholdend', 'blue hold end');

					animation.addByPrefix('purplehold', 'purple hold piece');
					animation.addByPrefix('greenhold', 'green hold piece');
					animation.addByPrefix('redhold', 'red hold piece');
					animation.addByPrefix('bluehold', 'blue hold piece');

					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = true;
			}
		}
		else
		{
			// TODO: I really want the note to flash but I cant seem to get it right
			loadGraphic(Paths.image('griswell/warningNoteNormal', "week7"));
			setGraphicSize(Std.int(width * 0.7));
			updateHitbox();
			antialiasing = true;
		}

		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				animation.play('purpleScroll');
			case 1:
				x += swagWidth * 1;
				animation.play('blueScroll');
			case 2:
				x += swagWidth * 2;
				animation.play('greenScroll');
			case 3:
				x += swagWidth * 3;
				animation.play('redScroll');
		}

		// trace(prevNote);

		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS
		if (FlxG.save.data.downscroll && sustainNote)
			flipY = true;

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				if (FlxG.save.data.scrollSpeed != 1)
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * FlxG.save.data.scrollSpeed;
				else
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (warning && isOnScreen())
		{
			if ((Conductor.songPosition / Conductor.stepCrochet) % 4 >= 3.0)
			{
				switch (this.noteData)
				{
					case 0:
						this.setColorTransform(1.1, 0.9, 1.3);
					case 2:
						this.setColorTransform(0.9, 1.5, 0.9);
					case 1:
						this.setColorTransform(0.9, 0.9, 1.5);
					case 3:
						this.setColorTransform(1.5, 0.9, 0.9);
				}
			}
			else
			{
				this.setColorTransform(1.0, 1.0, 1.0);
			}
			this.updateFramePixels();
		}

		if (mustPress)
		{
			// ass
			if (isSustainNote)
			{
				if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5)
					&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
					canBeHit = true;
				else
					canBeHit = false;
			}
			else
			{
				if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
					&& strumTime < Conductor.songPosition + Conductor.safeZoneOffset)
					canBeHit = true;
				else
					canBeHit = false;
			}

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset * Conductor.timeScale && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}
	}
}
