package blendhx.editor.ui.spaces;

import blendhx.editor.ui.headers.AssetsHeader;
import blendhx.editor.events.AssetsEvent;
import blendhx.editor.helpers.Utils;
import blendhx.editor.helpers.ObjectType;
import blendhx.editor.mvc.IModel;

import flash.display.Graphics;
import flash.errors.IllegalOperationError;
import flash.errors.Error;
import flash.events.ErrorEvent;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.filesystem.File;


class AssetsSpace extends Space
{
	private var colomnWidth:Float = 300;
	private var rows:Int = 0;
	private var colomns:Int = 0;
	
	private var fileItemPool:Array<FileItem> = [];
	
	public function new(model:IModel) 
	{
		super(model, 100, 0x454545);
		
		addHeader( new AssetsHeader( model ) );
	}
	
	
	override public function update()
	{
		if(model.currentAssetsDirectory != null)
			populate();
	}

	private function getItemFromPool(file:File, sourceURL:String)
	{
		var item:FileItem;
			
		if( fileItemPool[uiComponents.length] == null)
		{
			item = new FileItem(); 
			
			fileItemPool.push(item);
		}
		
		item = fileItemPool[ uiComponents.length];
		item.initialize(file, sourceURL);
		
		return item;
	}

	private function populate()
	{
		
		for(item in fileItemPool)
			if(item.parent!=null)
				removeChild( item );
		
		uiComponents = [];

		
		var files   :Array<File> = model.currentAssetsDirectory.getDirectoryListing();
		var fileItem:FileItem;
		
		
		if ( model.currentAssetsDirectory.nativePath !=  model.sourceDirectory.nativePath)
		{
			
			fileItem = getItemFromPool(null, null);
			addUIComponent( fileItem );
		}
		
		var selectedFileURL:String = "";
		if ( model.selectedFileItem != null)
			selectedFileURL = model.selectedFileItem.sourceURL;
		
		for(file in files)
		{
			var sourceURL:String = Utils.getLocalURL(model.sourceDirectory, file);
		
			fileItem = getItemFromPool(file, sourceURL);
			fileItem.selected = (sourceURL == selectedFileURL);

			addUIComponent( fileItem );
		}
	
		repositionUIComponents();
	}

	

	override public function repositionUIComponents()
	{
		var startY  :Float = (header == null ? 0 : header._height);
		var row     :Int = 0;
		var colomn  :Int = 0;
		
		for(uiComponent in uiComponents)
		{
			uiComponent.x = colomn * colomnWidth + padding/2;
			uiComponent.y = startY + row * padding;
			
			row++;
			
			if(row >= rows)
			{
				colomn ++;
				row = 0;
			}
		}
	}
	
	override public function redraw()
	{
		super.redraw();
		
		rows    = 0;
		colomns = 0;
		
		var startY  :Float = (header == null ? 0 : header._height);
		var prevRows:Int = rows;
		var gridY   :Float  = startY ;
		var gridX   :Float = colomnWidth;
		
		
		var g:Graphics = graphics;
		g.beginFill(0x4c4c4c);
		while(gridY  < _height)
		{
			g.drawRect(2, gridY + padding, _width-4, padding);
			gridY += padding * 2;
			rows += 2;
		}
		g.endFill();
		rows -= 1;	
		
		
		
		while(gridX < _width)
		{
			g.lineStyle(1      , 0x2e2e2e  );
			g.moveTo   (gridX  , startY);
			g.lineTo   (gridX  , _height   );
			g.lineStyle(1      , 0x6a6a6a  );
			g.moveTo   (gridX+1, startY);
			g.lineTo   (gridX+1, _height   );
			gridX += colomnWidth;
			colomns ++;
		}

	}

}