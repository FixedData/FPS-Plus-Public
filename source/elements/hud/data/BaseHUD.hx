package elements.hud.data;

import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
import flixel.text.FlxText.FlxTextAlign;
import extensions.flixel.FlxTextExt;
import flixel.math.FlxMath;
import config.Config;
import flixel.ui.FlxBar;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;




//make a container later
@:access(states.PlayState)
class BaseHUD extends FlxTypedSpriteGroup<FlxSprite> implements IGameHUD {
	public var parent:PlayState;
	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
    public var healthBar:FlxBar;
	public var scoreTxt:FlxTextExt;

	
	var healthBarBG:FlxSprite;

    public function new(parent:PlayState) {
        super();
        this.parent = parent;

		healthBarBG = new FlxSprite(0, Config.downscroll ? FlxG.height * 0.1 : FlxG.height * 0.875).loadGraphic(Paths.image("ui/healthBar"));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.antialiasing = true;
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), parent, 'healthLerp', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(parent.dad.characterColor, parent.boyfriend.characterColor);
		healthBar.antialiasing = true;
        add(healthBar);

		iconP1 = new HealthIcon(parent.boyfriend.iconName, true);
		iconP1.canLerpToDefaultScale = true;
		iconP1.y = healthBar.y - (iconP1.height / 2);
        add(iconP1);

        iconP2 = new HealthIcon(parent.dad.iconName, false);
		iconP2.canLerpToDefaultScale = true;
		iconP2.y = healthBar.y - (iconP2.height / 2);
        add(iconP2);


		scoreTxt = new FlxTextExt(healthBarBG.x - 105, (FlxG.height * 0.9) + 36, 800, "", 22);
		scoreTxt.setFormat(Paths.font("vcr"), 22, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		add(scoreTxt);


		healthBarBG.visible = false;
		healthBar.visible = false;
		iconP1.visible = false;
		iconP2.visible = false;
		scoreTxt.visible = false;

    }

	public function onStartCountdown() {
		healthBarBG.visible = true;
		healthBar.visible = true;
		iconP1.visible = true;
		iconP2.visible = true;
		scoreTxt.visible = true;
	}

    override function update(elapsed:Float) {
        super.update(elapsed);

        final iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

        if (healthBar.percent < 20){
			iconP1.animation.curAnim.curFrame = 1;
			iconP2.animation.curAnim.curFrame = 2;
		}
		else if (healthBar.percent > 80){
			iconP1.animation.curAnim.curFrame = 2;
			iconP2.animation.curAnim.curFrame = 1;
		}
		else{
			iconP1.animation.curAnim.curFrame = 0;
			iconP2.animation.curAnim.curFrame = 0;
		}
    }

    public function stepHit(step:Int) {}

    public function beatHit(beat:Int) {
        if (beat % parent.iconBopFrequency == 0){
			iconP1.scale.x = iconP2.scale.y = iconP1.defaultScale * 1.2;
			iconP2.scale.x = iconP2.scale.y = iconP2.defaultScale * 1.2;
		}
    }

	public function onScoreUpdate(stats:ScoreStats) 
	{
		scoreTxt.text = "Score:" + stats.score;

		if(Config.showMisses == 1){
			scoreTxt.text += " | Misses:" + stats.missCount;
		}
		else if(Config.showMisses == 2){
			scoreTxt.text += " | Combo Breaks:" + stats.comboBreakCount;
		}
		if(Config.showAccuracy){
			scoreTxt.text += " | Accuracy:" + PlayState.truncateFloat(stats.accuracy, 2) + "%";
		}
	}

	public function getVar(v:String) return Reflect.getProperty(this,v);
	
}