package blendhx.editor.commands;

class ProjectUndoCommand extends Command
{
	override public function execute():Void
	{
		var command:CommandWithUndo = CommandWithUndo.undoStack.pop();
		command.undo();
		
		super.execute();
	}
}