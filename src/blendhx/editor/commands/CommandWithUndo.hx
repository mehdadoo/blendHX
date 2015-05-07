package blendhx.editor.commands;

class CommandWithUndo extends Command
{
	public static var undoStack:Array<CommandWithUndo> = new Array<CommandWithUndo>();
	public static var redoStack:Array<CommandWithUndo> = new Array<CommandWithUndo>();
	public static var locked:Bool = false;
	
	private var values:Map<String, Dynamic> = new Map<String, Dynamic>();
	
	
	
	override public function execute():Void
	{
		if(!locked)
			undoStack.push( this );
		else
			super.execute();
	}
	
	public static function undoAvailable():Bool
	{
		if(locked)
			return false;
			
		return undoStack.length > 0;
	}
	public static function redoAvailable():Bool
	{
		if(locked)
			return false;
			
		return redoStack.length > 0;
	}
	
	public function undo():Void
	{
		redoStack.push( this );
	}
	
	public function redo():Void
	{
		undoStack.push( this );
	}
	override public function dispose()
	{
		values = null;
		super.dispose();
	}
}