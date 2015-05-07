package blendhx.editor.mvc;

import blendhx.editor.ui.UIComposite;

class UICompositeView extends UIComposite implements IView
{
	public var model:IModel;
	
	public function update():Void
	{
		for (uiComponent in uiComponents)
		{
			var view:IView = cast uiComponent;
			view.update();
		}

	}
}