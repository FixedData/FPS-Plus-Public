package extensions.openfl;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if flash
import openfl.Lib;
#end


//this here cuz it was just gonna be a custom fps but i realized sprite is more convenient to work with
@:access(states.PlayState)
class DebugDisplay extends Sprite
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public var memory(get, never):Float;
	inline function get_memory():Float return cast(openfl.system.System.totalMemory, UInt);

	public var fps:TextField;
	var underlay:Bitmap;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		underlay = new Bitmap();
		underlay.bitmapData = new BitmapData(1,1,true,0x6F000000);
		addChild(underlay);

		fps = new TextField();
		fps.defaultTextFormat = new TextFormat("_sans", 12, color);
		fps.selectable = false;
		fps.mouseEnabled = false;
		fps.autoSize = LEFT;
		fps.multiline = true;
		addChild(fps);

		currentFPS = 0;

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);

		if (currentCount != cacheCount)
		{
			fps.text = "FPS: " + currentFPS + ' | ' + flixel.util.FlxStringUtil.formatBytes(memory) + getExtraData();
		}

		underlay.width = fps.width + 4;
		underlay.height = fps.height;

		cacheCount = currentCount;

	}

	function getExtraData() 
	{
		if (Std.isOfType(FlxG.state,PlayState)) {
			var pState:PlayState = cast FlxG.state;
			if (pState.autoplay) return '\nAutoPlayed';
		}
		return '';
	}
	


}
