package;

import flxanimate.FlxAnimate;

typedef AtlasAnimInfo = {
	startFrame:Int,
	length:Int,
	framerate:Float,
    looped:Bool,
    loopFrame:Null<Int>
}

class AtlasSprite extends FlxAnimate
{

    public var animInfoMap:Map<String, AtlasAnimInfo> = new Map<String, AtlasAnimInfo>();
	public var curAnim:String;

    public var frameCallback:(String, Int, Int)->Void;
    public var animationEndCallback:String->Void;

    private var baseWidth:Float;
    private var baseHeight:Float;

    public function new(?_x:Float, ?_y:Float, _path:String) {
        super(_x, _y, _path);
        anim.callback = animCallback;
        baseWidth = pixels.width/2;
        baseHeight = pixels.height/2;
        width = baseWidth;
        height = baseHeight;
    }

    public function addAnimationByLabel(name:String, label:String, ?framerate:Float = 24, ?looped:Bool = false, ?loopFrame:Null<Int> = null):Void{
        var labels = anim.getFrameLabels();
        if(!labels.contains(label)){
            trace("LABEL " + label + " NOT FOUND, ABORTING ANIM ADD");
            return;
        }

        var frame = anim.getFrameLabel(label);

		var nextAnimFrame:Int;
		if(labels.indexOf(label) < labels.length - 1){
			nextAnimFrame = anim.getFrameLabel(labels[labels.indexOf(label)+1]).index;
		}
		else{
			nextAnimFrame = anim.length;
		}

        if(looped && loopFrame == null){
            loopFrame = 0;
        }

		animInfoMap.set(name, {
		    startFrame: frame.index,
			length: nextAnimFrame - frame.index,
			framerate: framerate,
            looped: looped,
            loopFrame: loopFrame
		});
    }

    public function addAnimationByFrame(name:String, frame:Int, length:Int, ?framerate:Float = 24, ?looped:Bool = false, ?loopFrame:Null<Int> = null):Void{
        if(looped && loopFrame == null){
            loopFrame = 0;
        }

		animInfoMap.set(name, {
		    startFrame: frame,
			length: length,
			framerate: framerate,
            looped: looped,
            loopFrame: loopFrame
		});
    }

    public function playAnim(name:String, ?force:Bool = true, ?reverse:Bool = false, ?frameOffset:Int = 0) {
        curAnim = name;

        if(frameOffset >= animInfoMap.get(name).length){
            frameOffset = animInfoMap.get(name).length - 1;
        }

		anim.play("", force, reverse, animInfoMap.get(name).startFrame + frameOffset);
    }

    function animCallback(name:String, frame:Int):Void{
		var animInfo = animInfoMap.get(curAnim);

        if(frameCallback != null){ frameCallback(name, frame, frame); }

		if(frame == (animInfo.startFrame + animInfo.length) - 1){
            if(animationEndCallback != null){ animationEndCallback(name); }

            if(animInfo.looped){
                playAnim(curAnim, true, animInfo.loopFrame);
            }
            else{
                anim.pause();
            }
		}
	}

    override function set_flipX(Value:Bool):Bool {
        flipX = Value;
        return super.set_flipX(Value);
    }

    override function set_flipY(Value:Bool):Bool {
        flipY = Value;
        return super.set_flipY(Value);
    }

    override function update(elapsed:Float) {

        if(flipX){ offset.x = -width; }
        else { offset.x = 0; }

        if(flipY){ offset.y = -height; }
        else { offset.y = 0; }

        super.update(elapsed);
    }

    override function updateHitbox() {
        width = Math.abs(scale.x) * baseWidth;
		height = Math.abs(scale.y) * baseHeight;
    }

}