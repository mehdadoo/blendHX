package blendhx.engine;

import flash.system.ApplicationDomain;
import flash.Vector;

class Utils
{
    public static function GetClassNameFromURL(url:String):String
    {
    	var className:String = StringTools.replace(url, "/", ".");
    	className = className.substring(0, className.length - 3);
    	return className;
    }
	
	
	public static function registerClassAliases():Void
	{
		haxe.remoting.AMFConnection.registerClassAlias("flash.geom.Matrix3D", flash.geom.Matrix3D);	
		haxe.remoting.AMFConnection.registerClassAlias("com.adobe.utils.PerspectiveMatrix3D", com.adobe.utils.PerspectiveMatrix3D);	
	 	haxe.remoting.AMFConnection.registerClassAlias("flash.geom.Vector3D", flash.geom.Vector3D);	
	
		haxe.remoting.AMFConnection.registerClassAlias("haxe.ds.StringMap", haxe.ds.StringMap);
		
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.Scene", blendhx.engine.Scene);
		
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.assets.IAsset", blendhx.engine.assets.IAsset);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.assets.Script", blendhx.engine.assets.Script);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.assets.Texture", blendhx.engine.assets.Texture);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.assets.Mesh", blendhx.engine.assets.Mesh);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.assets.Material", blendhx.engine.assets.Material);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.assets.Scripts", blendhx.engine.assets.Scripts);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.assets.Assets", blendhx.engine.assets.Assets);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.assets.Sound", blendhx.engine.assets.Sound);
		
		
		
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.components.IComponent", blendhx.engine.components.IComponent);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.components.IComposite", blendhx.engine.components.IComposite);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.components.Component", blendhx.engine.components.Component);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.components.Entity", blendhx.engine.components.Entity);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.components.Transform", blendhx.engine.components.Transform);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.components.Camera", blendhx.engine.components.Camera);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.components.MeshRenderer", blendhx.engine.components.MeshRenderer);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.components.Script", blendhx.engine.components.Script);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.components.Sound", blendhx.engine.components.Sound);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.components.SoundStatus", blendhx.engine.components.SoundStatus);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.components.Lamp", blendhx.engine.components.Lamp);
		 
		
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.engine.presets.GridFloorMesh", blendhx.engine.presets.GridFloorMesh);
	}
	
	public static function registerScriptClassAliases(domain:ApplicationDomain):Void
	{
		var classNames:Vector<String> = domain.getQualifiedDefinitionNames();
		
		for(className in classNames)
		{
			var theClass = domain.getDefinition(className);
			var baseClass = Type.getSuperClass( theClass );
			if( Std.string(baseClass) == "[class Component]" || Std.string(baseClass) == "[class Shader]")
			{
				haxe.remoting.AMFConnection.registerClassAlias(className, theClass);
			}
		}
	}
}
