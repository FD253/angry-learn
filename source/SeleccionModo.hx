package ;
import flixel.addons.ui.FlxInputText;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import KeyboardTextField;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;


class SeleccionModo extends BaseEstado
{
	var fondo : FlxSprite;
	var btnModoLibre : FlxButton;
	var btnModoRegistrado : FlxButton;
	var t : KeyboardTextField;
	var grupo : FlxSpriteGroup;
	
	override public function create() 
	{
		super.create();
		
		grupo = new FlxSpriteGroup();
				
		fondo = new FlxSprite(0, 0, AssetPaths.fondo_panel__png);
		grupo.add(fondo);
		
		cuadroUsuario.visible = false;
		nombreUsuario.visible = false;
		var textSize = 30;
		btnModoLibre = new FlxButton(10, 10, null, btnModoLibreOnClick);
		btnModoLibre.loadGraphic(AssetPaths.modo__png);
		btnModoLibre.x = (fondo.width / 2) - (btnModoLibre.width / 2);
		btnModoLibre.y = fondo.height * 0.23;
		var txtModoLibre = new FlxText(btnModoLibre.x ,
									 btnModoLibre.y, 0, "MODO LIBRE" , textSize);
		txtModoLibre.font = AssetPaths.carter__ttf;
		txtModoLibre.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		txtModoLibre.autoSize = false;
		txtModoLibre.alignment = "center";
		txtModoLibre.fieldWidth = btnModoLibre.width;
		txtModoLibre.y = btnModoLibre.y + (btnModoLibre.height / 2) - (txtModoLibre.height / 2);
		
		//txtModoLibre.y = btnModoLibre.y + (btnModoLibre.height / 2) - (txtModoLibre.height / 2) - (txtModoLibre.size * 0.3);
		
		
		grupo.add(btnModoLibre);
		grupo.add(txtModoLibre);

		btnModoRegistrado = new FlxButton(10, 40, null, btnModoRegistradoOnClick);
		btnModoRegistrado.loadGraphic(AssetPaths.modo__png);
		btnModoRegistrado.x = (fondo.width / 2) - (btnModoRegistrado.width / 2);
		btnModoRegistrado.y = fondo.height * 0.23 + 100;
		var txtModoRegistrado = new FlxText(btnModoRegistrado.x + btnModoRegistrado.width * 0.25,
									 btnModoRegistrado.y, 0, "USUARIO REGISTRADO" , textSize);
		txtModoRegistrado.font = AssetPaths.carter__ttf;
		txtModoRegistrado.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		txtModoRegistrado.y = btnModoRegistrado.y + (btnModoRegistrado.height / 2) - (txtModoRegistrado.height / 2) - (txtModoRegistrado.size * 0.3);
		
		grupo.add(btnModoRegistrado);
		grupo.add(txtModoRegistrado);
		
		grupo.setPosition(FlxG.width / 2 - grupo.width / 2, FlxG.height / 2 - grupo.height / 2);
		
		add(grupo);
		
		t = KeyboardTextField.getKeyboardField();
		t.x = (FlxG.stage.stageWidth - t.width) / 2;
		t.y = (FlxG.stage.stageHeight - t.height) * 0.7;
		
		FlxG.addChildBelowMouse(t);
	}
	override public function destroy() {
		super.destroy();
		FlxG.removeChild(t);
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