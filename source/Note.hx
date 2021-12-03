package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;
	public var mania:Int = 0;
	public var noteType:Int = 0;

	public static var noteyOff1:Array<Float> = [4, 0, 0, 0, 0, 0];
	public static var noteyOff2:Array<Float> = [0, 0, 0, 0, 0, 0];
	public static var noteyOff3:Array<Float> = [0, 0, 0, 0, 0, 0];

	public static var swagWidth:Float;
	public static var noteScale:Float;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	public static var EX1_NOTE:Int = 4;
	public static var EX2_NOTE:Int = 5;

	public static var tooMuch:Float = 30;

	public var dType:Int = 0;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		swagWidth = 160 * 0.7; //factor not the same as noteScale
		noteScale = 0.7;
		mania = 0;
		if (PlayState.SONG.mania == 1)
		{
			swagWidth = 120 * 0.8;
			noteScale = 0.3;
			mania = 1;
		}
		else if (PlayState.SONG.mania == 2)
		{
			swagWidth = 90 * 0.32;
			noteScale = 0.25;
			mania = 2;
		}
		else if (PlayState.SONG.mania == 3)
		{
			swagWidth = 65 * 0.7;
			noteScale = 0.40;
			mania = 3;
		}
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		if (PlayState.SONG.mania == 2)
		{
			x -= tooMuch;
		}
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;

		var t = Std.int(noteData / Main.dataJump[mania]);
		this.noteType = t;
		this.noteData = noteData % Main.keyAmmo[mania];

		var addto = FlxG.save.data.offset;
		if (Main.editor) //xd
		{
			addto = 0;
		}
		this.strumTime = strumTime + addto;

		var daStage:String = PlayState.curStage;

		switch (daStage)
		{
			case 'school' | 'schoolEvil':
				loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

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
				
				animation.addByPrefix('mardiScroll', 'mardi0');
				animation.addByPrefix('deepScroll', 'deep0');
				animation.addByPrefix('aquaScroll', 'aqua0');
				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');
				animation.addByPrefix('whiteScroll', 'white0');
				animation.addByPrefix('oldScroll', 'old0');
				animation.addByPrefix('pinkScroll', 'pink0');
				animation.addByPrefix('lavenderScroll', 'lavender0');
				animation.addByPrefix('orangeScroll', 'orange0');
				animation.addByPrefix('infraScroll', 'infra0');
				animation.addByPrefix('blurpleScroll', 'blurple0');
				animation.addByPrefix('yellowScroll', 'yellow0');
				animation.addByPrefix('violetScroll', 'violet0');
				animation.addByPrefix('blackScroll', 'black0');
				animation.addByPrefix('darkScroll', 'dark0');
				animation.addByPrefix('grayScroll', 'gray0');
				animation.addByPrefix('jonquilScroll', 'jonquil0');
				animation.addByPrefix('shamrockScroll', 'shamrock0');
				

                animation.addByPrefix('mardiholdend', 'mardi hold end');
				animation.addByPrefix('deepholdend', 'deep hold end');
				animation.addByPrefix('aquaholdend', 'aqua hold end');
				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');
				animation.addByPrefix('whiteholdend', 'white hold end');
				animation.addByPrefix('oldholdend', 'old hold end');
				animation.addByPrefix('pinkholdend', 'pink hold end');
				animation.addByPrefix('lavenderholdend', 'lavender hold end');
				animation.addByPrefix('orangeholdend', 'orange hold end');
				animation.addByPrefix('infraholdend', 'infra hold end');
				animation.addByPrefix('blurpleholdend', 'blurple hold end');
				animation.addByPrefix('yellowholdend', 'yellow hold end');
				animation.addByPrefix('violetholdend', 'violet hold end');
				animation.addByPrefix('blackholdend', 'black hold end');
				animation.addByPrefix('darkholdend', 'dark hold end');
				animation.addByPrefix('grayholdend', 'gray hold end');
				animation.addByPrefix('jonquilholdend', 'jonquil hold end');
				animation.addByPrefix('shamrockholdend', 'shamrock hold end');
				
				animation.addByPrefix('mardihold', 'mardi hold piece');
				animation.addByPrefix('deephold', 'deep hold piece');
				animation.addByPrefix('aquahold', 'aqua hold piece');
				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');
				animation.addByPrefix('whitehold', 'white hold piece');
				animation.addByPrefix('oldhold', 'old hold piece');
				animation.addByPrefix('pinkhold', 'pink hold piece');
				animation.addByPrefix('lavenderhold', 'lavender hold piece');
				animation.addByPrefix('orangehold', 'orange hold piece');
				animation.addByPrefix('infrahold', 'infra hold piece');
				animation.addByPrefix('blurplehold', 'blurple hold piece');
				animation.addByPrefix('yellowhold', 'yellow hold piece');
				animation.addByPrefix('violethold', 'violet hold piece');
				animation.addByPrefix('blackhold', 'black hold piece');
				animation.addByPrefix('darkhold', 'dark hold piece');
				animation.addByPrefix('grayhold', 'gray hold piece');
				animation.addByPrefix('jonquilhold', 'jonquil hold piece');
				animation.addByPrefix('shamrockhold', 'shamrock hold piece');


				animation.addByPrefix('kill', 'kill');
				animation.addByPrefix('live', 'live');
				animation.addByPrefix('tiky', 'tiky');
				animation.addByPrefix('hell', 'hell');
				animation.addByPrefix('WHY', 'WHY');

				setGraphicSize(Std.int(width * noteScale));
				updateHitbox();
				antialiasing = true;
		}

		var frameN:Array<String> = ['purple', 'blue', 'green', 'red'];
		if (mania == 1) frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
		else if (mania == 2) frameN = ['mardi', 'deep', 'aqua', 'purple', 'blue', 'green', 'red', 'white', 'old', 'pink', 'lavender', 'orange', 'infra', 'blurple', 'yellow', 'violet', 'black', 'dark', 'gray', 'jonquil', 'shamrock'];
		else if (mania == 3) frameN = ['purple', 'blue', 'green', 'red', 'violet', 'yellow', 'white', 'red', 'green', 'yellow', 'violet', 'black', 'dark'];

		x += swagWidth * (noteData % Main.keyAmmo[mania]);
		animation.play(frameN[noteData % Main.keyAmmo[mania]] + 'Scroll');
		// trace(prevNote);

		switch (t)
		{
			case 1:
				animation.play('kill');
			case 2:
				animation.play('live');
			case 3:
				animation.play('tiky');
			case 4:
				animation.play('hell');
			case 5:
				animation.play('WHY');
		}

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;
			if (FlxG.save.data.downscroll)
			{
				scale.y *= -1;
			}

			x += width / 2;

			animation.play(frameN[noteData % Main.keyAmmo[mania]] + 'holdend');
			switch (noteData)
			{
				case 0:
				//nada
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
					//nada
				}
				prevNote.animation.play(frameN[prevNote.noteData] + 'hold');
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed * (0.7 / noteScale);
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		//getStrumTime();

		super.update(elapsed);

		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
