package blendhx.editor.commands;

import blendhx.editor.helpers.Utils;

import flash.filesystem.*;

class AssetsNewShaderCommand extends Command
{
	override public function execute():Void
	{
		var currentDirectory:File = model.currentAssetsDirectory;
		var newScript:File =  currentDirectory.resolvePath("Shader.hx");
		var i:UInt = 1;
		while( newScript.exists )
		{
			newScript = currentDirectory.resolvePath("Shader"+i+".hx");
			i++;
		}
			
		
		var templateScript:File = File.applicationDirectory.resolvePath("templates/Shader.hx");
		
		var localURL:String = Utils.getLocalURL(model.sourceDirectory, newScript);
		var className:String =  newScript.name.split(".")[0];
		var packageName:String = Utils.GetClassNameFromURL(localURL) ;
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
		
		model.selectedFileItem = null;
		
		super.execute();
	}
}