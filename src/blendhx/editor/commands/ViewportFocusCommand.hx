package blendhx.editor.commands;

class ViewportFocusCommand extends Command
{
	override public function execute():Void
	{
		model.editorCamera.controller.focus( model.selectedEntity.transform);
		
		super.execute();
	}
}