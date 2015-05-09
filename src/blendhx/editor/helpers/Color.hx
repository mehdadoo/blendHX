package blendhx.editor.helpers;


class Color
{
	public static var RED:UInt = 0xcc1111;
	public static var ORANGE:UInt = 0xee5511;
	public static var GREEN:UInt = 0x11aa00;
	public static var GRAY:UInt = 0xa6a6a6;
	
	/**
	 * Returns a random color.
	 * 
	 * @param   Min        An optional FlxColor representing the lower bounds for the generated color.
	 * @param   Max        An optional FlxColor representing the upper bounds for the generated color.
	 * @param 	Alpha      An optional value for the alpha channel of the generated color.
	 * @param   GreyScale  Whether or not to create a color that is strictly a shade of grey. False by default.
	 * @return  A color value as a FlxColor.
	 */
	public static function random():Int
	{
		var R:Int = Std.int(Math.random() * 256);
		var G:Int = Std.int(Math.random() * 256);
		var B:Int = Std.int(Math.random() * 256);
		var A:Int = 256;
		
		var PACKED_COLOR = (A & 0xFF) << 24 | (R & 0xFF) << 16 | (G & 0xFF) << 8 | (B & 0xFF);
		
		return PACKED_COLOR;
	}
}