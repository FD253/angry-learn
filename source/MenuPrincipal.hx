package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;
import MenuCoordinacionVisomotriz;
import MenuRitmoLector;
import MenuTrazos;

class MenuPrincipal extends BaseMenu
{

	override public function create():Void 
	{
		super.create();
		
		var selectorNiveles = new FlxSpriteGroup(0, 0);
		selectorNiveles.updateHitbox();
		
		var fondo = new FlxSprite(0, 0, AssetPaths.fondo_lista_juegos__png);
		selectorNiveles.add(fondo);
		
		selectorNiveles.setPosition((FlxG.width - selectorNiveles.width) - 70, 65);
		add(selectorNiveles);
		
		// Sólo por ahora seguimos con los botones de prueba
		agregarBoton("RITMO LECTOR", MenuRitmoLector);
		agregarBoton("COORDINACIÓN VISOMOTRIZ", MenuCoordinacionVisomotriz);
		agregarBoton("TRAZOS", MenuTrazos);
		ordenarBotones();

	}
	
}