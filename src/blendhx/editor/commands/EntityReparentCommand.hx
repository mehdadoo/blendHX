package blendhx.editor.commands;


import blendhx.engine.components.IComposite;

import blendhx.editor.events.HierarchyEvent;

class EntityReparentCommand extends CommandWithUndo
{
	override public function execute():Void
	{
		var hierarchyEvent:HierarchyEvent = cast event;
		
		var entity:IComposite = model.selectedEntity;
		var newParent:IComposite = hierarchyEvent.entity;

		
		if( isIllegal(entity, newParent) )
		{
			dispose();
			return;
		}
		
		values.set("newParent", hierarchyEvent.entity);
		values.set("oldParent", entity.parent);
		values.set("entity", entity);
		
		entity.parent.removeChild(entity);
		newParent.addChild(entity);
		
		super.execute();
	}
	
	//dont reparent an entity as a child of it's children
	private function isIllegal(entity:IComposite, newParent:IComposite):Bool
	{
		var parent:IComposite = newParent.parent;
		
		while(parent!=null)
		{
			if(parent == entity)
			{
				return true;
			}
			parent = parent.parent;
		}
		
		return false;
	}
	
	override public function undo():Void
	{
		var entity:IComposite = values.get("entity");
		var oldParent:IComposite = values.get("oldParent");
		
		entity.parent.removeChild(entity);
		oldParent.addChild(entity);
		
		super.undo();
	}
	
	override public function redo():Void
	{
		var newParent:IComposite = values.get("newParent");
		var entity:IComposite = values.get("entity");
		
		entity.parent.removeChild(entity);
		newParent.addChild(entity);
		
		super.redo();
	}
}