package;

import states.PlayState.ScoreStats;
import flixel.FlxG;

typedef SongStats = {
	score:Int,
	accuracy:Float,
	rank:Rank
}

enum Rank {
	none;
	loss;
	good;
	great;
	excellent;
	perfect;
	gold;
}

class Highscore
{

	
	//Major versions will be incompatible and will wipe scores. Minor versions should always convert / repair scores.
	static var scoreFormatVersion:String = "1.1";

	public static var songScores:Map<String, SongStats> = new Map<String, SongStats>();

	static final forceResetScores:Bool = false;

	public static function saveScore(_song:String, _score:Int = 0, _accurracy:Float = 0, _diff:Int = 1, _rank:Rank = none):Void{
		var song:String = formatSong(_song, _diff);

		var proposedStats:SongStats = {
			score: _score,
			accuracy: _accurracy,
			rank: _rank
		};

		if (songScores.exists(song)){
			var currentStats = songScores.get(song);

			if (proposedStats.score < currentStats.score){
				proposedStats.score = currentStats.score;
			}
			if (proposedStats.accuracy < currentStats.accuracy){
				proposedStats.accuracy = currentStats.accuracy;
			}
			if (rankToInt(proposedStats.rank) < rankToInt(currentStats.rank)){
				proposedStats.rank = currentStats.rank;
			}
			
			setScore(song, proposedStats);
		}
		else{
			setScore(song, proposedStats);
		}
	}

	public static function saveWeekScore(_week:Int = 1, _score:Int = 0, _accurracy:Float = 0, _diff:Int = 1, _rank:Rank = none):Void{
		saveScore("week" + _week, _score, _accurracy, _diff, _rank);
	}

	static function setScore(_song:String, _stats:SongStats):Void{
		// Reminder that I don't need to format this song, it should come formatted!
		SaveManager.scores();
		songScores.set(_song, _stats);
		FlxG.save.data.songScores = songScores;
		SaveManager.global();
	}

	public static function formatSong(song:String, diff:Int):String{
		if (diff == 0){ song += '-easy'; }
		else if (diff == 2){ song += '-hard'; }
		return song;
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	public static function getScore(song:String, diff:Int):SongStats{
		if (!songScores.exists(formatSong(song, diff))){
			var emptyScore:SongStats = {
				score: 0,
				accuracy: 0,
				rank: none
			}
			setScore(formatSong(song, diff), emptyScore);
		}

		return songScores.get(formatSong(song, diff));
	}

	public static inline function scoreExists(song:String, diff:Int):Bool{
		return songScores.exists(formatSong(song, diff));
	}

	public static function getWeekScore(week:Int, diff:Int):SongStats{
		return getScore("week" + week, diff);
	}

	public static function load():Void{
		SaveManager.scores();

		if(FlxG.save.data.scoreFormatVersion == null || cast (FlxG.save.data.scoreFormatVersion, String).split(".")[0] != scoreFormatVersion.split(".")[0] || forceResetScores){
			FlxG.save.data.songScores = songScores;
		}
		else if(cast (FlxG.save.data.scoreFormatVersion, String).split(".")[1] != scoreFormatVersion.split(".")[1]){
			var savedScores:Map<String, Dynamic> = FlxG.save.data.songScores;
			for(key => value in savedScores){
				if(value.rank == null){
					value.rank = none;
				}
			}
			FlxG.save.data.songScores = savedScores; 
		}

		if (FlxG.save.data.songScores != null){
			songScores = FlxG.save.data.songScores;
		}

		FlxG.save.data.scoreFormatVersion = scoreFormatVersion;

		SaveManager.flush();
		SaveManager.global();
	}

	public static function calculateRank(scoreData:ScoreStats):Rank{

		var totalNotes = scoreData.sickCount + scoreData.goodCount + scoreData.badCount + scoreData.shitCount + scoreData.missCount;

		if (scoreData.sickCount == totalNotes) return gold;
		
		var grade = (scoreData.sickCount + scoreData.goodCount) / totalNotes;
	  
		if(grade == 1){
			return perfect;
		}
		else if(grade >= 0.90){
			return excellent;
		}
		else if(grade >= 0.80){
			return great;
		}
		else if(grade >= 0.60){
			return good;
		}
		else{
			return loss;
		}

	}

	static inline function rankToInt(rank:Rank):Int{
		switch(rank){
			case loss: return 1;
			case good: return 2;
			case great: return 3;
			case excellent: return 4;
			case perfect: return 5;
			case gold: return 6;
			default: return 0;
		}
	}
}
