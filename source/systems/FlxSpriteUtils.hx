package systems;

import flixel.util.FlxColor;
import flixel.util.FlxAxes;

/**
    macro extension to add convenient functions to FlxSprites
**/
class FlxSpriteUtils {

    inline static public function setScale(spr:FlxSprite, scaleX:Float, ?scaleY:Null<Float> = null, ?updatehitbox = true):FlxSprite
    {
        scaleY ??= scaleX;
        spr.scale.set(scaleX, scaleY);
        if (updatehitbox) spr.updateHitbox();
        return spr;
    }

    inline static public function setSpriteSize(spr:FlxSprite, width:Float = 0,height:Float = 0, ?updatehitbox = true):FlxSprite
    {
        spr.setGraphicSize(width,height);
        if (updatehitbox) spr.updateHitbox();
        return spr;
    }

    inline static public function makeScaledGraphic(spr:FlxSprite,width:Float,height:Float,color:FlxColor = FlxColor.WHITE):FlxSprite
    {
        spr.makeGraphic(1,1,color);
        spr.scale.set(width,height);
        spr.updateHitbox();
        return spr;
    }

    inline static public function centerOnSprite(spr:FlxSprite, sprite2:FlxSprite, axes:FlxAxes = XY):FlxSprite {
        if (axes.x) spr.x = sprite2.x + (sprite2.width - spr.width) / 2;
        if (axes.y) spr.y = sprite2.y + (sprite2.height - spr.height) / 2;

        return spr;
    }

    //literally used to save lines.
    inline static public function loadFrames(sprite:FlxSprite, image:String):FlxSprite {
        sprite.frames = Paths.getSparrowAtlas(image);
        return sprite;
    }
}
