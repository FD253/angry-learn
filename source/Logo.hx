package ;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Logo extends FlxState
{

	override public function create()
	{
		super.create();
		
		var timer = new FlxTimer(1.2, timerOnTick, 1);
		var logo = new FlxSprite(0, 0, AssetPaths.logo__png);
		logo.setPosition((FlxG.width - logo.width) / 2, (FlxG.height - logo.height) / 2);
		add(logo);
		this.set_bgColor(FlxColor.WHITE);
	}
	
	function timerOnTick(timer : FlxTimer) {
		FlxG.switchState(new SeleccionModo());
	}
	
}