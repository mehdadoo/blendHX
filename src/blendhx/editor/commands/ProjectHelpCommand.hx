package blendhx.editor.commands;

import flash.net.URLRequest;

class ProjectHelpCommand extends Command
{
	override public function execute():Void
	{
		var urlRequest:URLRequest = new URLRequest( "https://github.com/mehdadoo/blendHX/wiki" );
		flash.Lib.getURL(urlRequest, "_blank");
		
		super.execute();
	}
}