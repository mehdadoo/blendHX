package blendhx.editor.ui.spaces;

import blendhx.engine.components.IComposite;

import blendhx.editor.ui.UIComponent;

import flash.display.Graphics;

class HierarchySpace extends Space
{
	
	override public function update()
	{
		recreateChildren();
		super.update();
	}

	//create child hierarchy items
	private function recreateChildren() 
	{
		removeUIComponents();
		
		var entity:IComposite = model.entities;
		
		HierarchyItemFactory.Reset();
		
		var hierarchyItem:UIComponent = HierarchyItemFactory.Create(model, entity);
		
		addUIComponent( hierarchyItem );
	}
	
	
	override public function redraw()
	{
		super.redraw();	
		
		var g:Graphics = graphics;
		g.lineStyle(0, 0, 0);
		g.beginFill(0x787878);
		
		var gridY:Float = 2;
		
		while(gridY < _height)
		{
			g.drawRect(2, gridY, _width-3, padding);
			gridY += padding * 2;
		}
			
		g.endFill();
	}
}