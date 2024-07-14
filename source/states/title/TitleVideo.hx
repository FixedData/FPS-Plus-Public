package states.title;

import elements.VideoSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;

using StringTools;

class TitleVideo extends FlxState
{
	// var oldFPS:Int = VideoHandler.MAX_FPS;
	var video:VideoSprite;
	var titleState = new TitleScreen();

	override public function create():Void
	{

		super.create();

		//FlxG.sound.cache(Paths.music("klaskiiLoop"));

		if(!Main.novid){

			video = new VideoSprite();
			video.addCallback(ONEND,()->{
				next();
			},true);
			video.load(Paths.video('klaskiiTitle'));
			video.play();
			add(video);
		}
		else{
			next();
		}
	}

	override public function update(elapsed:Float){

		super.update(elapsed);

		if(Binds.justPressed("menuAccept")){
			video.skip();
		}

	}

	function next():Void{

		FlxG.camera.flash(FlxColor.WHITE, 60);
		FlxG.sound.playMusic(Paths.music(TitleScreen.titleMusic), TitleScreen.titleMusicVolume);
		Conductor.changeBPM(158);
		FlxG.switchState(titleState);

	}
	
}
