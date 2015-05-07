package blendhx.editor.ui.spaces;
import blendhx.editor.ui.controls.Label;
import blendhx.editor.ui.headers.Header;

import blendhx.engine.components.IComposite;
import blendhx.engine.components.IComponent;

import blendhx.editor.ui.headers.AssetsHeader;
import blendhx.editor.mvc.IModel;
import blendhx.editor.ui.panels.PanelPool;
import blendhx.editor.ui.panels.Panel;
import blendhx.editor.helpers.ObjectType;

class PropertiesSpace extends Space 
{
	private var pool:PanelPool = new PanelPool();

	
	override public function update()
	{
		//nothing interesting to the properties space has changed in model
		if( model.lastSelectedObject == ObjectType.FOLDER )
			return;
		
		//clear properties panel
		for (uiComponent in uiComponents)
			removeChild(uiComponent);
		uiComponents = [];
		
		
		if( model.lastSelectedObject == ObjectType.ENTITY )
			showEntityProperties();
		else
			showAssetProperties();
		
		super.update();
	}
	
	private function showAssetProperties()
	{
		var panel:Panel;
		
		switch ( model.selectedFileItem.type )
		{
			case ObjectType.MATERIAL:
				panel = pool.getPanel( "Material"   );
				
			case ObjectType.SCRIPT:
				panel = pool.getPanel( "ScriptFile" );
				
			default:
				panel = pool.getPanel( "AssetInfo"  );
		}

		panel.model = model;
		addUIComponent( panel );
	}
	
	private function showEntityProperties()
	{
		var components:Array<IComponent> = model.selectedEntity.children;
		
		if(components == null)
			return;
		
		for (component in components)
		{
			if( untyped __is__(component, IComposite) )
				continue;
				
			var panel:Panel = pool.getPanel( component.name );
			
			if(panel != null)
			{
				panel.enabled = component.enabled;
				panel.component = component;
				panel.model = model;
				addUIComponent(panel);
			}
		}
		
		var panel:Panel = pool.getPanel( "AddComponent" );
		panel.model = model;
		addUIComponent( panel );
	
		super.update();
	}
}