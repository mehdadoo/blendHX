package blendhx.editor.commands;

class ProjectRedoCommand extends Command
{
	override public function execute():Void
	{
		var command:CommandWithUndo = CommandWithUndo.redoStack.pop();
		command.redo();
		
		super.execute();
	}
}