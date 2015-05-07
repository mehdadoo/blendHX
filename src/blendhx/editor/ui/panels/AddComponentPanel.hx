package blendhx.editor.ui.panels;

import blendhx.editor.ui.controls.TextInput;
import blendhx.editor.ui.controls.ControlBase;
import blendhx.editor.ui.controls.Button;
import blendhx.editor.ui.controls.ObjectInput;
import blendhx.editor.ui.controls.Label;

import blendhx.editor.events.ComponentEvent;
import blendhx.editor.events.HierarchyEvent;

class AddComponentPanel extends Panel
{
	private var sourceURL:ObjectInput;
	private var renameInput:TextInput;
	
	public function new() 
	{
		super("Add Script", 200, false, false);
	}
	
	override private function initialize()
	{
		sourceURL = new ObjectInput( "Script File",30, null, this, 1, 1,
									ControlBase.ROUND_BOTH,  ObjectInput.SCRIPT);
		new Button( "Add", 60, addComponent, this);
	}

    private function addComponent()
    {
		var e:ComponentEvent = new ComponentEvent(ComponentEvent.NEW);
		e.sourceURL = sourceURL.value;
		dispatchEvent(e);
    }

}
