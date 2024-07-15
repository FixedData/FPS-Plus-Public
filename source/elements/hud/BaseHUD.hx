package elements.hud;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import extensions.flixel.FlxTextExt;
import flixel.ui.FlxBar;

@:access(states.PlayState)
class BaseHUD extends FlxTypedSpriteGroup<FlxSprite> {
    public var parent:PlayState;

    public var iconP1:Null<HealthIcon>;
    public var iconP2:Null<HealthIcon>;
    public var healthBar:Null<FlxBar>;
    public var scoreTxt:Null<FlxTextExt>;

    public function new(parent:PlayState) {
        super();
        this.parent = parent;
        init();
    }

    public var curStep(get,never):Int;
    function get_curStep():Int return PlayState.instance.curStep;

    public var curBeat(get,never):Int;
    @:noCompletion function get_curBeat():Int return PlayState.instance.curBeat;

    public function init():Void {}
    public function beatHit():Void {}
    public function stepHit():Void {}

    public function onScoreUpdate(stats:ScoreStats):Void {}
    public function onStartCountdown():Void {}

    public function getVar(v:String) return Reflect.getProperty(this,v);
}