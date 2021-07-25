package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class BoxSprite extends FlxSprite implements SpriteOffsetting
{
	public var animOffsets:Map<String, Array<Float>>;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		animOffsets = new Map<String, Array<Float>>();
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);
		offset.set(animOffsets.exists(AnimName) ? animOffsets.get(AnimName)[0] : 0, animOffsets.exists(AnimName) ? animOffsets.get(AnimName)[1] : 0);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}

class DialogueBox extends FlxSpriteGroup
{
	var box:BoxSprite;

	var curCharacter:String = '';
	var curBox:String = 'normal';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var bgFade:FlxSprite;

	private var isPixel:Bool = true;
	private var opening:Bool = false;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'himbo' | 'brainjail':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns' | 'aplovecraft':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFFFFFFF);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new BoxSprite(-20, 45);
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				isPixel = true;
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);
				isPixel = true;

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
				isPixel = true;

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'himbo' | 'brainjail' | 'aplovecraft':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('dialogueshit/speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'Speech Bubble Normal Open', [4], "", 24);
				box.animation.addByPrefix('cutsceneOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('cutscene', 'Speech Bubble Normal Open', [4], "", 24);
				box.animation.addByPrefix('loudOpen', 'speech bubble loud open', 24, false);
				box.animation.addByIndices('loud', 'speech bubble loud open', [1], "", 24);
				box.animation.addByPrefix('aaahOpen', 'AHH speech bubble', 24, false);
				box.animation.addByIndices('aaah', 'AHH speech bubble', [1], "", 24);
				box.animation.addByPrefix('timidOpen', 'speech bubble timid', 24, false);
				box.animation.addByIndices('timid', 'speech bubble timid', [3], "", 24);
				// TODO -- hazel play with these offsets
				box.addOffset('normal', 0, 50);
				box.addOffset('normalOpen', 0, 50);
				box.addOffset('aaah', -20, -10);
				box.addOffset('aaahOpen', 0, 50);
				// and similarly for all the other animations
				isPixel = false;
		}

		this.dialogueList = dialogueList;

		if (!hasDialog)
			return;

		portraitLeft = new FlxSprite(-200, 250);
		portraitLeft.frames = Paths.getSparrowAtlas('griswell/portraits', 'week7');
		portraitLeft.animation.addByPrefix('enter', 'dad', 24, false);
		portraitLeft.animation.addByPrefix('dad', 'dad', 24, false);
		portraitLeft.animation.addByPrefix('dad-transform1', 'dad-transformone', 24, false);
		portraitLeft.animation.addByPrefix('dad-transform2', 'dad-transformtwo', 24, false);
		portraitLeft.animation.addByPrefix('dad-blaykangry', 'dad-blaykangry', 24, false);
		portraitLeft.animation.addByPrefix('dad-blaykannoyed', 'dad-blaykannoyed', 24, false);
		portraitLeft.animation.addByPrefix('dad-blaykstun', 'dad-blaykstun', 24, false);
		portraitLeft.animation.addByPrefix('dad-blayknerv', 'dad-blayknerv', 24, false);
		portraitLeft.animation.addByPrefix('dad-nite', 'dad-nite', 24, false);
		portraitLeft.animation.addByPrefix('dad-niteevil', 'dad-niteevil', 24, false);
		portraitLeft.animation.addByPrefix('dad-niteblush', 'dad-niteblush', 24, false);
		portraitLeft.animation.addByPrefix('dad-nitesmirk', 'dad-nitesmirk', 24, false);
		portraitLeft.animation.addByPrefix('dad-united', 'dad-united', 24, false);
		scaleAsset(portraitLeft);
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(700, 100);
		portraitRight.frames = Paths.getSparrowAtlas('griswell/portraits', 'week7');
		portraitRight.animation.addByPrefix('enter', 'bf', 24, false);
		portraitRight.animation.addByPrefix('bf-angry', 'bf-angry', 24, false);
		portraitRight.animation.addByPrefix('gf', 'gf', 24, false);
		scaleAsset(portraitRight);
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		box.playAnim(curBox + 'Open');
		scaleAsset(box);
		box.updateHitbox();
		add(box);

		if (!isPixel)
			box.setPosition(0, 350);
		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD0CAC6;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF625D5d;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null && box.animation.curAnim.finished)
		{
			if (!opening)
			{
				box.playAnim(curBox + 'Open');
				opening = true;
			}
			else
			{
				box.playAnim(curBox);
			}
			dialogueOpened = true;
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
			opening = false;

			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		box.playAnim(curBox);
		if (curCharacter.contains('bf') || curCharacter.contains('gf'))
			box.flipX = false;
		else
			box.flipX = true;

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'bf-angry':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('bf-angry');
				}
			case 'gf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('gf');
				}
			case 'dad-empty' | 'empty':
				portraitLeft.visible = false;
				portraitRight.visible = false;
			default:
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play(curCharacter);
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		trace(splitName);
		curCharacter = splitName[1];
		curBox = (splitName.length < 4 || StringTools.trim(splitName[3]) == "") ? 'normal' : splitName[3];
		trace(curCharacter + ",  " + curBox);
		dialogueList[0] = splitName[2].trim();
	}

	function scaleAsset(ass:FlxSprite):Void
	{
		ass.setGraphicSize(Std.int(isPixel ? ass.width * PlayState.daPixelZoom * 0.9 : ass.width));
	}
}
