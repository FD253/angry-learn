package ritmo;

import flixel.FlxState;
import flixel.FlxG;

/**
 * ...
 * @author Gabriel
 */
class Nivel1 extends FlxState
{

	override public function create():Void 
	{
		super.create();
		FlxG.sound.play(AssetPaths.ritmo_bell__wav);
	}
}