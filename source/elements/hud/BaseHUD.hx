package elements.hud;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;




//make a container later
class BaseHUD extends FlxTypedSpriteGroup<FlxSprite> implements IGameHUD {
	public var parent:PlayState;

	public var iconP1:HealthIcon;

	public var iconP2:HealthIcon;

    
}