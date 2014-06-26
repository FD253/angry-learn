package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author 
 */
class MenuGenerico extends FlxState
{
	private var _btnSecuencias:FlxButton;
	private function clickSecuencias():Void
	{
	
	}
	public function new() 
	{
		super();
	}
	
	override public function create():Void
	{
		_btnSecuencias = new FlxButton(0, 0, "Secuencias", clickSecuencias);
		_btnSecuencias.loadGraphic(AssetPaths.btntest__png);
		_btnSecuencias.scale.x = 2;
		_btnSecuencias.scale.y = 2;
		_btnSecuencias.label.scale.x = 2;
		_btnSecuencias.label.scale.y = 2;
		_btnSecuencias.screenCenter();
		add(_btnSecuencias);
		super.create();
		
	}
	
}