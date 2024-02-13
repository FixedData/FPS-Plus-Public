package characters;

@charList(false)
@gfList(true)
class GfTankmen extends CharacterInfoBase
{

    override public function new(){

        super();

        info.name = "gf-tankmen";
        info.spritePath = "week7/gfTankmen";
        info.frameLoadType = sparrow;
        
        info.iconName = "gf";
        info.hasLeftAndRightIdle = true;

        addByIndices('sad', offset(-2, -21), 'GF Crying at Gunpoint', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, true);
		addByIndices('danceLeft', offset(0, -9), 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		addByIndices('danceRight', offset(0, -9), 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

    }

}