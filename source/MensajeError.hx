package ;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;

class MensajeError extends FlxSpriteGroup
{
	public var textoError : FlxText;
	public var imagenError : FlxSprite;
	
	override function new () {
		super();
		textoError = new FlxText(0, 0, FlxG.width, "HAY PROBLEMAS PARA CONECTARSE A INTERNET", 48);
		textoError.font = AssetPaths.carter__ttf;	
		textoError.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		textoError.autoSize = false;
		textoError.alignment = "center";
		textoError.fieldWidth = FlxG.width;
		
		textoError.updateHitbox();
		add(textoError);		
		
		imagenError = new FlxSprite(0, 0, AssetPaths.error_red__png);
		add(imagenError);
		imagenError.setPosition((width - imagenError.width) / 2, textoError.height * 1.2);
		
		visible = false;
		setPosition((FlxG.width - width) / 2, FlxG.height * 0.3);
	}
	
}