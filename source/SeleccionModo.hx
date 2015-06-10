package ;
import flixel.addons.ui.FlxInputText;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;


class SeleccionModo extends BaseEstado
{
	var btnModoLibre : FlxButton;
	var btnModoRegistrado : FlxButton;
	override public function create() 
	{
		super.create();
		var textSize = 30;
		btnModoLibre = new FlxButton(10, 10, null, btnModoLibreOnClick);
		btnModoLibre.loadGraphic(AssetPaths.selector_normal__png);
		btnModoLibre.x = (FlxG.width / 2) - (btnModoLibre.width / 2);
		btnModoLibre.y = FlxG.height * 0.23;
		var txtModoLibre = new FlxText(btnModoLibre.x + btnModoLibre.width * 0.25,
									 btnModoLibre.y, 0, "Modo libre" , textSize);
		txtModoLibre.font = AssetPaths.carter__ttf;
		txtModoLibre.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		txtModoLibre.y = btnModoLibre.y + (btnModoLibre.height / 2) - (txtModoLibre.height / 2) - (txtModoLibre.size * 0.3);
		add(btnModoLibre);
		add(txtModoLibre);

		btnModoRegistrado = new FlxButton(10, 40, null, btnModoRegistradoOnClick);
		btnModoRegistrado.loadGraphic(AssetPaths.selector_normal__png);
		btnModoRegistrado.x = (FlxG.width / 2) - (btnModoRegistrado.width / 2);
		btnModoRegistrado.y = FlxG.height * 0.23 + 100;
		var txtModoRegistrado = new FlxText(btnModoRegistrado.x + btnModoRegistrado.width * 0.25,
									 btnModoRegistrado.y, 0, "Modo registrado" , textSize);
		txtModoRegistrado.font = AssetPaths.carter__ttf;
		txtModoRegistrado.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		txtModoRegistrado.y = btnModoRegistrado.y + (btnModoRegistrado.height / 2) - (txtModoRegistrado.height / 2) - (txtModoRegistrado.size * 0.3);
		add(btnModoRegistrado);
		add(txtModoRegistrado);
		
		var textfield = new TextField();
		textfield.x = 50;
        textfield.y = 50;
        textfield.type = TextFieldType.INPUT;
        textfield.textColor = 0x000000;
        textfield.border = true;
        textfield.borderColor = 0xFFFF00;
        textfield.background = true;
        textfield.backgroundColor = 0xFFFFFF;
        textfield.width = 200;
        textfield.height = 40;
        textfield.setTextFormat(new TextFormat(null, 32));
		
		textfield.needsSoftKeyboard = true;
		
		//FlxG.addChildBelowMouse(textfield);
	}
	
	function btnModoLibreOnClick()
	{
		Reg.setearModoLibre();
		Reg.modoDeJuego = Reg.LIBRE;
		FlxG.switchState(new MenuPrincipal());
	}
	
	function btnModoRegistradoOnClick()
	{
		Reg.modoDeJuego = Reg.REGISTRADO;
		FlxG.switchState(new SeleccionUsuario());
	}
}