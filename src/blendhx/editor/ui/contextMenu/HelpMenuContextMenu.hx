package blendhx.editor.ui.contextMenu;

import blendhx.editor.ui.controls.ControlBase;
import blendhx.editor.ui.controls.ContextMenuButton;
import blendhx.editor.ui.controls.ImageButton;

import blendhx.editor.events.ProjectEvent;

import flash.net.URLRequest;

class HelpMenuContextMenu extends ContextMenu
{
	public function new() 
	{
		super();
		
		addUIComponent( new Seperator() );
		new ContextMenuButton("Website homepage", 0, openGithubPage, this, 1, 1,
							  ControlBase.ROUND_NONE, ImageButton.WEBPAGE);
		new ContextMenuButton("Wiki                              F1", 0, openWiki, this, 1, 1,
							  ControlBase.ROUND_NONE, ImageButton.WEBPAGE);
		addUIComponent( new Seperator() );
		new ContextMenuButton("Report a bug", 0, reportBug, this, 1, 1,
							  ControlBase.ROUND_NONE, ImageButton.WEBPAGE);
		addUIComponent( new Seperator() );
	}
	
	private function openGithubPage()
	{
		var urlRequest:URLRequest = new URLRequest( "https://github.com/mehdadoo/blendhx" );
		flash.Lib.getURL(urlRequest, "_blank");
		
		dispose();
	}
	
	private function reportBug()
	{
		var urlRequest:URLRequest = new URLRequest( "https://github.com/mehdadoo/blendhx/issues" );
		flash.Lib.getURL(urlRequest, "_blank");
		
		dispose();
	}
	
	private function openWiki()
	{
		var e:ProjectEvent = new ProjectEvent(ProjectEvent.HELP);
		dispatchEvent(e);
		
		dispose();
	}
}