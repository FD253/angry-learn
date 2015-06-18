package ;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;



class BaseJuego extends BaseEstado
{
	
	var nombreJuego : FlxText;
	
	var menuDesplegable : FlxSpriteGroup; // En cada juego en particular, hacer .add del fondo y las cosas que van en él
	var btnMenuDesplegar : FlxButton;
	var btnMenuContraer : FlxButton;
	
	var barraProgresoFondo : FlxSprite;
	var barraProgresoRelleno : FlxSprite;
	var barraProgresoRellenoAncho : Float;	// El ancho original del relleno, seteado durante el create
	
	var animacionEnCurso : Bool = false;
	
	var menuPosicionX : Float;
	
	var cuadroPuntajeTotal : FlxSprite;
	var textoPuntajeTotal : FlxText;
	
	var cuadroPuntajeParcial : FlxSprite;
	var textoPuntajeParcial : FlxText;
	
	
	function actualizarProgreso(porcentaje : Float) {
		// Setea el progreso en la barra en base al porcentaje pasado como parámetro
		// El porcentaje es un número entre 0 y 100
		if (porcentaje < 5 || porcentaje > 100) {
			// Si es menos del 5% o más del 100, mostramos sólo el 5%
			barraProgresoRelleno.setGraphicSize(Std.int(barraProgresoRellenoAncho * 0.05), Std.int(barraProgresoRelleno.height));
			barraProgresoRelleno.updateHitbox();
		}
		else {
			barraProgresoRelleno.setGraphicSize(Std.int(barraProgresoRellenoAncho * porcentaje / 100), Std.int(barraProgresoRelleno.height));
			barraProgresoRelleno.updateHitbox();
		}
	}
	
	override public function create() {
		super.create();

		cuadroPuntajeTotal = new FlxSprite(FlxG.width - FlxG.width * 0.07, FlxG.height * 0.02, AssetPaths.cuadro_puntaje__png);
		cuadroPuntajeTotal.x -= cuadroPuntajeTotal.width;
		add(cuadroPuntajeTotal);
		textoPuntajeTotal = new FlxText(cuadroPuntajeTotal.x, cuadroPuntajeTotal.y, cuadroPuntajeTotal.width, "", Std.int(Reg.botonMenuTextSize * 0.75));
		textoPuntajeTotal.font = AssetPaths.carter__ttf;
		textoPuntajeTotal.autoSize = false;
		textoPuntajeTotal.wordWrap = false;
		textoPuntajeTotal.alignment = "center";
		textoPuntajeTotal.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 2, 1);
		textoPuntajeTotal.y = cuadroPuntajeTotal.y + (cuadroPuntajeTotal.height - textoPuntajeTotal.height) / 3;
		add(textoPuntajeTotal);
		
		cuadroPuntajeParcial = cuadroPuntajeTotal.clone();
		cuadroPuntajeParcial.setPosition(800, 350);
		cuadroPuntajeParcial.visible = false;
		cuadroPuntajeParcial.loadGraphic(AssetPaths.fondo_globo_puntaje__png);
		add(cuadroPuntajeParcial);
		
		textoPuntajeParcial = new FlxText(cuadroPuntajeParcial.x , cuadroPuntajeParcial.y, cuadroPuntajeParcial.width, "0", Std.int(Reg.botonMenuTextSize * 0.75));
		textoPuntajeParcial.font = AssetPaths.carter__ttf;
		textoPuntajeParcial.autoSize = false;
		textoPuntajeParcial.wordWrap = false;
		textoPuntajeParcial.alignment = "center";
		textoPuntajeParcial.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 2, 1);
		textoPuntajeParcial.y = cuadroPuntajeParcial.y + (cuadroPuntajeParcial.height - textoPuntajeParcial.height) / 3;
		textoPuntajeParcial.visible = false;
		add(textoPuntajeParcial);

		
		var botonAtras = new FlxButton(encabezado.height * 0.4, // 40% del alto de la barra naranja superior
									   FlxG.width * 0.015,	// 1.5% del ancho del juego
									   botonAtrasOnClick);
		botonAtras.loadGraphic(AssetPaths.boton_atras__png);
		add(botonAtras);
		
		barraProgresoFondo = new FlxSprite(FlxG.width, 0, AssetPaths.barra_progreso_fondo__png);
		barraProgresoFondo.setPosition((FlxG.width - barraProgresoFondo.width) / 2, encabezado.height * 0.9);
		add(barraProgresoFondo);
		
		barraProgresoRelleno = new FlxSprite(0, 0, AssetPaths.barra_progreso_relleno__png);
		barraProgresoRellenoAncho = barraProgresoRelleno.width;
		barraProgresoRelleno.setPosition(barraProgresoFondo.x + (barraProgresoFondo.width - barraProgresoRelleno.width) / 2, barraProgresoFondo.y + (barraProgresoFondo.height - barraProgresoRelleno.height) / 2);
		barraProgresoRelleno.setGraphicSize(Std.int(barraProgresoFondo.width * 0.05), Std.int(barraProgresoRelleno.height));
		barraProgresoRelleno.updateHitbox();
		
		add(barraProgresoRelleno);

		
		agregarMenuDesplegable();
	}

	function agregarTitulo(titulo:String) {
		nombreJuego = new FlxText(0, -5);
		nombreJuego.size = 36; // HARDCODED
		nombreJuego.text = titulo;
		nombreJuego.font = AssetPaths.carter__ttf;
		nombreJuego.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		nombreJuego.x = FlxG.width / 2 - nombreJuego.fieldWidth / 2;	// Centramos al medio, manteniendo la altura
		add(nombreJuego);
    }

	function agregarMenuDesplegable() {
		menuPosicionX = FlxG.width * 0.01;
		// Botón mostrar menu ->
		btnMenuDesplegar = new FlxButton(0, 0, '', btnMenuDesplegarOnClick);
		btnMenuDesplegar.loadGraphic(AssetPaths.boton_menu_desplegar__png);
		btnMenuDesplegar.setPosition(menuPosicionX,
									 FlxG.height - btnMenuDesplegar.height * 2.4);
		add(btnMenuDesplegar);
		
		menuDesplegable = new FlxSpriteGroup(menuPosicionX, btnMenuDesplegar.y);
		menuDesplegable.visible = false; // Que arranque oculto porque no sabemos qué tamaño va a tener después
		add(menuDesplegable);
		
		btnMenuContraer = new FlxButton(menuPosicionX, btnMenuDesplegar.y, '', btnMenuContraerOnClick);
		btnMenuContraer.loadGraphic(AssetPaths.boton_menu_contraer__png);
		btnMenuContraer.x = -btnMenuContraer.width;
		add(btnMenuContraer);
	}
	
	function activarClick(tween: FlxTween)
	{
		animacionEnCurso = false;
	}
	
	function desactivarClick()
	{
		animacionEnCurso = true;
	}
	
	function btnMenuDesplegarOnClick() {
		// Ocultamos el botón que muestra el menu
		if (!animacionEnCurso) {
			desactivarClick();
			FlxTween.tween(btnMenuDesplegar, { x: -btnMenuDesplegar.width }, 0.08, { complete: tweenBtnMenuDesplegarOnComplete } );
			
		}
	}
	
	function tweenBtnMenuDesplegarOnComplete(tween : FlxTween) {
		// La primera vez, el menú está oculto, así que lo posicionamos a la izquierda de la pantalla
		// Debido a que no sabíamos qué ancho podía llegar a tener
		if (menuDesplegable.visible == false) {
			menuDesplegable.x = -menuDesplegable.width;
			menuDesplegable.visible = true;
		}
		
		// Desplegamos el menu y el botón que lo contrae
		FlxTween.tween(menuDesplegable, { x: menuPosicionX }, 0.1);
		FlxTween.tween(btnMenuContraer, { x: menuPosicionX }, 0.1, { complete : activarClick });
	}
	
	function tweenBtnMenuContraerOnComplete(tween : FlxTween) {
		FlxTween.tween(btnMenuDesplegar, { x: menuPosicionX }, 0.2, { complete: activarClick });
	}

	
	function btnMenuContraerOnClick() {
		if (!animacionEnCurso) {
			desactivarClick();
			FlxTween.tween(btnMenuContraer, { x: -btnMenuContraer.width }, 0.1);
			FlxTween.tween(menuDesplegable, { x: -menuDesplegable.width }, 0.1, { complete: tweenBtnMenuContraerOnComplete } );
		}
		
	}
	
	function botonAtrasOnClick() {
		FlxG.switchState(new MenuPrincipal());
	}

	function actualizarPuntajeTotal(puntajeTotal:Int) {
		textoPuntajeTotal.text = Std.string(puntajeTotal);
	}
	
	function actualizarPuntajeParcial(puntajeParcial:Int) {
		textoPuntajeParcial.text = Std.string(puntajeParcial);
		cuadroPuntajeParcial.visible = true;
		textoPuntajeParcial.visible = true;
	}
}