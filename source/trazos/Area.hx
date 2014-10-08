package trazos;
import flixel.util.FlxPoint;

/**
 * ...
 * @author ...
 */
class Area
{
	var puntoA : FlxPoint;
	var puntoB : FlxPoint;
	
	//                     X 
	//    |------------------
	//    |   ptoA
	//    |    .-------|
	//    |    | Area  |
	//    |    |       |
	//    |    |-------.
	//    |            ptoB
	//  Y |                   
	//
	//	El puntoA SIEMPRE debe estar más arriba a la izquierda que el puntoB
	//		Toda la lógica del ejercicio supone esto para calcular el área
	//		tanto de inicio del trazo como del fin del trazo.
	//		Siempre debe cumplirse que:
	//		ptoA.x < ptoB.x
	//		ptoA.y < ptoB.y
	
	public function new(puntoSupIzq : FlxPoint, puntoInfDer : FlxPoint) {
		puntoA = puntoSupIzq;
		puntoB = puntoInfDer;
	}
	
	public function puntoDentroArea(punto : FlxPoint) {
		if (punto.x < puntoB.x &&
			punto.x > puntoA.x &&
			punto.y < puntoB.y &&
			punto.y > puntoA.y) {
				
				return true;
		}
		else {
			return false;
		}
	}
	
}