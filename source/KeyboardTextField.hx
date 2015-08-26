package ;

import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;


class KeyboardTextField extends TextField
{
	public static function getKeyboardField() : KeyboardTextField{
		var textfield = new KeyboardTextField();
		textfield.defaultTextFormat = new TextFormat("Carter One", 32);
		//textfield.setTextFormat(new TextFormat(null, 32));
		textfield.type = TextFieldType.INPUT;
        textfield.textColor = 0x000000;
        textfield.border = true;
        textfield.borderColor = 0xFFFF00;
        textfield.background = true;
        textfield.backgroundColor = 0xFFFFFF;
        textfield.width = 200;
        textfield.height = 40;
        #if (android)
		textfield.needsSoftKeyboard = true;
		//textfield.moveForSoftKeyboard = true;
		#end
		return textfield;
	}
}