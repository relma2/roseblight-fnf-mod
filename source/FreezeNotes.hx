package;

import Assertion.*;
import Note;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef SwagFreeze =
{
	var beats:Array<Int>; // Beat numbers that "pausa notes" show up
	var directions:Array<Int>; // Directions that freeeze notes go in
	var penalties:Null<Array<Int>>; // Number of beats you get frozen for; if null uses global penalty
}

class FreezeNotes
{
	var name:String = "test";
	var globalPenalty:Int;
	var easy:SwagFreeze;
	var medium:SwagFreeze;
	var hard:SwagFreeze;

	public function new(jsonInput:String, ?folder:String)
	{
		// pre lowercasing the folder name
		var folderLowercase = StringTools.replace(folder, " ", "-").toLowerCase();
		switch (folderLowercase)
		{
			case 'dad-battle':
				folderLowercase = 'dadbattle';
			case 'philly-nice':
				folderLowercase = 'philly';
			case 'brain-jail':
				folderLowercase = 'brainjail';
		}

		trace('loading ' + folderLowercase + '/' + jsonInput.toLowerCase());
		var rawJson = Assets.getText(Paths.json(folderLowercase + '/' + jsonInput.toLowerCase())).trim();

		while (!rawJson.endsWith("}"))
			rawJson = rawJson.substr(0, rawJson.length - 1);

		var myName = Json.parse(rawJson).name;
		var mySongName = Json.parse(rawJson).songName;
		weakAssert(myName == mySongName);
		this.name = myName == null ? (mySongName == null ? "test" : mySongName) : myName;
		var p = Json.parse(rawJson).penalty;
		// weakAssert((p != null && p > 0), "must have positive pausa penalty; using default value 5 beats");
		this.globalPenalty = p > 0 ? p : 5;

		this.easy = cast Json.parse(rawJson).easy;
		assert(this.easy.beats.length == this.easy.directions.length);
		assert(this.easy.penalties == null || this.easy.penalties.length <= this.easy.directions.length);

		this.medium = cast Json.parse(rawJson).medium;
		assert(this.medium.beats.length == this.medium.directions.length);
		assert(this.medium.penalties == null || this.medium.penalties.length <= this.medium.directions.length);

		this.hard = cast Json.parse(rawJson).hard;
		assert(this.hard.beats.length == this.hard.directions.length);
		assert(this.hard.penalties == null || this.hard.penalties.length <= this.hard.directions.length);
	}

	public function generateWarnNotes(difficulty:String, beatStepTime:Float, unspawn:Array<Note>, xOffset:Float = 0, X:Float = 0, Y:Float = 0):Void
	{
		trace("generating Warn Notes in chart for " + this.name + " at difficulty " + difficulty);
		var freeze:SwagFreeze = difficulty == "easy" ? this.easy : (difficulty == "medium" ? this.medium : this.hard);

		for (x in 0...freeze.beats.length)
		{
			var warnNoteTime:Int = freeze.beats[x];
			var warnNote:Note = new Note(warnNoteTime * beatStepTime, freeze.directions[x], null, false, true, true);
			var myPenalty:Int = 5;
			if (freeze.penalties == null || freeze.penalties.length < x + 1 || freeze.penalties[x] < 0)
				myPenalty = this.globalPenalty;
			else
				myPenalty = freeze.penalties[x];
			warnNote.penalty = myPenalty;
			warnNote.scrollFactor.set(X, Y);
			warnNote.mustPress = true;
			warnNote.x += xOffset; // general offset
			unspawn.push(warnNote);
		}
	}
}
