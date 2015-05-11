package blendhx.editor.commands;

import blendhx.engine.components.IComposite;

class EntityDuplicateCommand extends CommandWithUndo
{
	override public function execute():Void
	{
		//don't delete the root of hierarchy
		if(model.entities == model.selectedEntity)
		{
			dispose();
			return;
		}
		
		
		var entity:IComposite = model.selectedEntity;
		var duplicate:IComposite = cast entity.clone();
		entity.parent.addChild( duplicate );
		
		values.set("parent", entity.parent);
		values.set("entity", duplicate);
		
		
		super.execute();
	}
	
	override public function undo():Void
	{
		var entity:IComposite = values.get("entity");
		var parent:IComposite = values.get("parent");
		
		parent.removeChild(entity);
		//entity.dispose();
		
		super.undo();
	}
	
	override public function redo():Void
	{
		var entity:IComposite = values.get("entity");
		var parent:IComposite = values.get("parent");
		
		parent.addChild(entity);
		

		super.redo();
	}
}