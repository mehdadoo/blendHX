package blendhx.editor.ui.panels;

import blendhx.editor.mvc.IModel;

class PanelPool
{
	private var panels:Map<String,Panel>;

	public function new()
	{
		panels = new Map<String,Panel>();
		
		panels.set("Transform"   , new TransformPanel()    );
		panels.set("Camera"      , new CameraPanel()       );
		panels.set("MeshRenderer", new MeshRendererPanel() );
		panels.set("Material"    , new MaterialPanel()     );
		panels.set("AddComponent", new AddComponentPanel() );
		panels.set("AssetInfo"   , new AssetInfoPanel()    );
		panels.set("ScriptFile"  , new ScriptFilePanel()   );
		//panels.set("Panel"       , new Panel("Unknown Panel", 200) );
	}
	
	public function getPanel( name:String ):Panel
	{
		if ( !panels.exists(name) )
			panels.set( name, new ScriptComponentPanel(name, 200, true, true) );
			
		return panels.get( name );
	}	
}