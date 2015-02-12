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
		
		var selectorNiveles = new FlxSpriteGroup(Math.round(FlxG.width * 0.5), Math.round(FlxG.height * 0.14));
		selectorNiveles.updateHitbox();
		
		var fondo = new FlxSprite(0, 0, AssetPaths.fondo_lista_juegos__png);
		fondo.setGraphicSize(Math.round(FlxG.width * 0.40), 0);
		fondo.updateHitbox();
		selectorNiveles.add(fondo);
		
		add(selectorNiveles);
		
		// Sólo por ahora seguimos con los botones de prueba
		agregarBoton("RITMO LECTOR", MenuRitmoLector);
		agregarBoton("COORDINACIÓN VISOMOTRIZ", MenuCoordinacionVisomotriz);
		agregarBoton("TRAZOS", MenuTrazos);
		ordenarBotones();
		
	}
	
}