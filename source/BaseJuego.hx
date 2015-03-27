package ;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;

import flixel.tweens.FlxTween;



class BaseJuego extends BaseEstado
{
	
	var menuDesplegable : FlxSpriteGroup; // En cada juego en particular, hacer .add del fondo y las cosas que van en él
	var btnMenuDesplegar : FlxButton;
	var btnMenuContraer : FlxButton;
	
	var menuPosicionX : Float;
	
	override public function create() {
		super.create();
		
		// Botón para ir atrás (Al menú de juego)
		var botonAtras = new FlxButton(encabezado.height * 0.4, // 40% del alto de la barra naranja superior
									   FlxG.width * 0.015,	// 1.5% del ancho del juego
									   botonAtrasOnClick);
		botonAtras.loadGraphic(AssetPaths.boton_atras__png);
		add(botonAtras);
		
		var barraProgreso = new FlxSprite(0, 14, AssetPaths.barra_progreso_fondo__png);
		barraProgreso.x = FlxG.width - barraProgreso.width - 7;
		add(barraProgreso);
		
		agregarMenuDesplegable();
	}
	
	function agregarMenuDesplegable() {
		menuPosicionX = FlxG.width * 0.01;
		// Botón mostrar menu ->
		btnMenuDesplegar = new FlxButton(0, 0, '', btnMenuDesplegarOnClick);
		btnMenuDesplegar.loadGraphic(AssetPaths.boton_menu_desplegar__png);
		btnMenuDesplegar.setPosition(menuPosicionX,
									 FlxG.height - btnMenuDesplegar.height - FlxG.height * 0.2);
		add(btnMenuDesplegar);
		
		menuDesplegable = new FlxSpriteGroup(menuPosicionX, btnMenuDesplegar.y);
		menuDesplegable.visible = false; // Que arranque oculto porque no sabemos qué tamaño va a tener después
		add(menuDesplegable);
		
		btnMenuContraer = new FlxButton(menuPosicionX, btnMenuDesplegar.y, '', btnMenuContraerOnClick);
		btnMenuContraer.loadGraphic(AssetPaths.boton_menu_contraer__png);
		btnMenuContraer.x = -btnMenuContraer.width;
		add(btnMenuContraer);
	}
	
	function btnMenuDesplegarOnClick() {
		// Ocultamos el botón que muestra el menu
		FlxTween.tween(btnMenuDesplegar, {x: -btnMenuDesplegar.width}, 0.08, {complete: tweenBtnMenuDesplegarOnComplete});
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
		FlxTween.tween(btnMenuContraer, { x: menuPosicionX }, 0.1);
	}
	
	function tweenBtnMenuContraerOnComplete(tween : FlxTween) {
		FlxTween.tween(btnMenuDesplegar, {x: menuPosicionX}, 0.2);
	}

	
	function btnMenuContraerOnClick() {
		FlxTween.tween(btnMenuContraer, { x: -btnMenuContraer.width }, 0.1);
		FlxTween.tween(menuDesplegable, { x: -menuDesplegable.width }, 0.1, {complete: tweenBtnMenuContraerOnComplete});
		
	}
	
	function botonAtrasOnClick() {
		FlxG.switchState(new MenuPrincipal());
	}
	
}