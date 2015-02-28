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
	
	override public function create() {
		super.create();
		
		// Botón para ir atrás (Al menú de juego)
		var botonAtras = new FlxButton(7, 7, botonAtrasOnClick);
		botonAtras.loadGraphic(AssetPaths.boton_atras__png);
		add(botonAtras);
		
		agregarMenuDesplegable();
	}
	
	function agregarMenuDesplegable() {
		// Botón mostrar menu ->
		btnMenuDesplegar = new FlxButton(5, FlxG.height - 125, '', btnMenuDesplegarOnClick);
		btnMenuDesplegar.loadGraphic(AssetPaths.boton_menu_desplegar__png);
		add(btnMenuDesplegar);
		
		menuDesplegable = new FlxSpriteGroup(0, btnMenuDesplegar.y);
		menuDesplegable.visible = false; // Que arranque oculto porque no sabemos qué tamaño va a tener después
		add(menuDesplegable);
		
		btnMenuContraer = new FlxButton(5, btnMenuDesplegar.y, '', btnMenuContraerOnClick);
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
		FlxTween.tween(menuDesplegable, { x: 5 }, 0.1);
		FlxTween.tween(btnMenuContraer, { x: 5 }, 0.1);
	}
	
	function tweenBtnMenuContraerOnComplete(tween : FlxTween) {
		FlxTween.tween(btnMenuDesplegar, {x: 5}, 0.2);
	}

	
	function btnMenuContraerOnClick() {
		FlxTween.tween(btnMenuContraer, { x: -btnMenuContraer.width }, 0.1);
		FlxTween.tween(menuDesplegable, { x: -menuDesplegable.width }, 0.1, {complete: tweenBtnMenuContraerOnComplete});
		
	}
	
	function botonAtrasOnClick() {
		FlxG.switchState(new MenuPrincipal());
	}
	
}