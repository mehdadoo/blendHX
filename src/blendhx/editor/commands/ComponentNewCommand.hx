package blendhx.editor.commands;

import blendhx.engine.assets.Assets;
import blendhx.engine.assets.IAsset;
import blendhx.engine.components.*;
import blendhx.editor.events.ComponentEvent;

class ComponentNewCommand extends CommandWithUndo
{
	override public function execute():Void
	{
		var componentEvent:ComponentEvent = cast event;
		var component:IComponent = null;
		
		switch (componentEvent.sourceURL)
		{
			case "Camera":
				component = new Camera();
			case "MeshRenderer":
				component = new MeshRenderer();
			default:
			{
				var id:UInt = model.assets.getID( componentEvent.sourceURL );
				if( id != 0)
				{
					var scriptAsset:IAsset = model.assets.get( Assets.COMPONENT, id );
					component = new Script( scriptAsset );
				}
			}
		}
		
		if(component == null)
		{
			//do not register in the undo history
			dispose();
			return;
		}
		
		
		
		values.set("component", component);
		values.set("entity", model.selectedEntity);
		model.selectedEntity.addChild(component);
		
		super.execute();
		
	}
	
	override public function undo():Void
	{
		var entity:IComposite = values.get("entity");
		var component:IComponent = values.get("component");
		entity.removeChild(component);
		//component.dispose();
		super.undo();
	}
	
	override public function redo():Void
	{
		var entity:IComposite = values.get("entity");
		var component:IComponent = values.get("component");
		entity.addChild(component);
		
		super.redo();
	}
}