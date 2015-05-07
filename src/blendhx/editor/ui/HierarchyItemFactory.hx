package blendhx.editor.ui;

import blendhx.engine.components.IComposite;
import blendhx.editor.mvc.IModel;

class HierarchyItemFactory
{
	private static var pool:Array<HierarchyItem> = [];
	

	public static function Reset()
	{
		for(h in pool)
		{
			if(h.entity != null)
			{
				h.container.removeUIComponent(h);
				h.entity = null;
			}
		}
	}
				
	//create child hierarchy items
	public static function Create( model:IModel, entity:IComposite, depth:UInt = -1 ):HierarchyItem 
	{
		var hierarchyItem:HierarchyItem = null;
		
		for( h in pool)
		{
			if (h.entity == null)
			{
				hierarchyItem = h;
				break;
			}
		}
		
		if(hierarchyItem == null)
		{
			hierarchyItem = new HierarchyItem(model);
			pool.push(hierarchyItem);
		}
	
		hierarchyItem.initialize( entity, depth + 1 );
		
		//trace(entity.name + ", " +pool.length);
		
		return hierarchyItem;
	}
}