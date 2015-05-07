package blendhx.editor.commands;

import blendhx.editor.events.ProjectEvent;
import blendhx.engine.assets.IAsset;
import blendhx.engine.assets.Script;
import blendhx.editor.helpers.Utils;

import flash.filesystem.*;

class AssetsNewHaxeFileCommand extends Command
{
	override public function execute():Void
	{
		var currentDirectory:File = model.currentAssetsDirectory;
		var newScript:File =  currentDirectory.resolvePath("Script.hx");
		var i:UInt = 1;
		while( newScript.exists )
		{
			newScript = currentDirectory.resolvePath("Script"+i+".hx");
			i++;
		}	
		
		var templateScript:File = File.applicationDirectory.resolvePath("templates/Script.hx");
		
		var sourceURL:String = Utils.getLocalURL(model.sourceDirectory, newScript);
		var className:String =  newScript.name.split(".")[0];
		var packageName:String = Utils.GetClassNameFromURL(sourceURL) ;
		packageName = packageName.substring(0, packageName.lastIndexOf("."));
		
		var fs:FileStream = new FileStream();
		fs.open( templateScript, FileMode.READ );
		var templateString:String = fs.readUTFBytes( fs.bytesAvailable );
		
		var template = new haxe.Template( templateString );
        templateString = template.execute({ packageName : packageName, className : className });
        
		fs.close();
		fs.open( newScript, FileMode.WRITE);
		fs.writeUTFBytes( templateString );
		fs.close();
		
		registerAsset( sourceURL );
		reloadScripts();
		
		model.selectedFileItem = null;
		
		super.execute();
	}
	
	private function reloadScripts():Void
	{
		var e:ProjectEvent = new ProjectEvent(ProjectEvent.RELOAD_SCRIPTS);
		model.dispatchEvent( e );
		e.dispose();
	}
	private function registerAsset( sourceURL:String ):Void
	{
		var script:IAsset = new Script();
		script.sourceURL = sourceURL;
		script.id = model.assets.getNewID();
		model.assets.components.push( script );
	}
}