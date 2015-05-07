package blendhx.editor.commands;

import blendhx.engine.components.IComposite;
import blendhx.engine.components.Entity;

class EntityNewCommand extends CommandWithUndo
{
	override public function execute():Void
	{
		var entity:IComposite = model.selectedEntity;
		var child:IComposite = new Entity("Empty");
		
		values.set("parent", entity);
		values.set("entity", child);
		
		entity.addChild( child );
		
		super.execute();
	}
	
	override public function undo():Void
	{
		var entity:IComposite = values.get("entity");
		var parent:IComposite = values.get("parent");
		
		parent.removeChild( entity );
		//entity.dispose();
		super.undo();
	}
	
	override public function redo():Void
	{
		var entity:IComposite = values.get("entity");
		var parent:IComposite = values.get("parent");
		
		parent.addChild( entity );
		
		super.redo();
	}
}