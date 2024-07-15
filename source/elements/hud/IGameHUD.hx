package elements.hud;

import extensions.flixel.FlxTextExt;
import flixel.ui.FlxBar;

//later might make this not a interface
interface IGameHUD {
    var parent:PlayState;

    //these are expected but dont need to be used.
    @:optional public var iconP1:Null<HealthIcon>;
    @:optional public var iconP2:Null<HealthIcon>;
    @:optional public var healthBar:Null<FlxBar>;
    @:optional public var scoreTxt:Null<FlxTextExt>;

    public function stepHit(step:Int):Void;
    public function beatHit(beat:Int):Void;

    public function onScoreUpdate(stats:ScoreStats):Void;
    public function onStartCountdown():Void;



    public function getVar(obj:String):Dynamic;



}