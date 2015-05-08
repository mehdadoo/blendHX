package blendhx.editor.ui.panels;

//import blendhx.engine.assets.Script;
import blendhx.engine.assets.Assets;
import blendhx.engine.components.Script;

import blendhx.editor.ui.controls.*;
import blendhx.editor.events.ScriptEvent;
import blendhx.editor.helpers.ObjectType;

class ScriptComponentPanel extends Panel
{
	private var componentProperties:Array<String> = [];
	private var property_controls:Array<ControlBase> = [];
	private var script:Script;
	private var asset:blendhx.engine.assets.Script;
	private var defaultProperties:Map<String, Dynamic>;
	
	public function new(title:String, _width:Float, hasCheckbox:Bool = false, hasRemoveButton:Bool = false) 
	{
		super( title, _width, hasCheckbox, hasRemoveButton );
		
		defaultProperties = new Map<String, Dynamic>();
		defaultProperties.set( "Float",  0.0);
		defaultProperties.set( "String", "text");
		defaultProperties.set( "Color",  "0xff6677");
	}
	
	override public function update()
	{
		//if in edit mode, panel will show the Script wrapper properties
		//else it will show the component properties
		if( untyped __is__(component, Script) )
		{
			script = cast component;
			asset = cast script.asset;
		}
		else
		{
			var id:UInt = model.assets.getID( component.name );
			asset = model.assets.get( Assets.COMPONENT, id);
			script = null;
		}
		
		title = asset.sourceURL;
		
		//Component editor properties have not changed, no need to recreate the user interface controls
		if( asset.classDefinition == null || haveEditorPropertiesChanged() )
			recreateControls();
		
		var length:Int = Std.int( property_controls.length / 2 );
		
		
		
		for (i in 0...length)
		{
			var value:Dynamic;
			if( script != null )
				value = script.properties.get( componentProperties[i*2] );
			else
				value = Reflect.field( component, componentProperties[i*2]);
			
			if(value == null)
				value = defaultProperties.get( componentProperties[(i*2)+1] );
				
			property_controls[i*2+1].value = value;
		}
	}
	
	
	
	override private function updateModel() 
	{
		var propertieslength:Int = Std.int( property_controls.length / 2 );
		var length:Int = Std.int( componentProperties.length / 2 );
		
		//when controls are created, this is called unfairly, that shouldn't. we wont resume when loop at redraw is still running
		if( length != propertieslength)
			return;
			
			
		var values:Array<Dynamic> = [];
		
			
		for (i in 0...length)
		{
			var value = property_controls[ (i*2) +1].value;
			
			if(script == null)
			{
				Reflect.setField(component, componentProperties[ i * 2 ], value);
			}
			else
				values.push( value );
		}
		
		if(script == null)
			return;
			
		var e:ScriptEvent = new ScriptEvent( ScriptEvent.CHANGE );
		e.component = component;
		e.values = values;
		e.componentProperties = componentProperties;
		
		dispatchEvent( e ); 
	}
	
	private function recreateControls()
	{
		//trace("recreateControls");
		removeUIComponents();
		
		
		componentProperties = asset.classFields;

		var length:Int = Std.int( componentProperties.length / 2 );
		var input_y:Int = 30;
		var input:ControlBase;
		property_controls = [];
		
		if( asset.classDefinition == null)
			property_controls.push( new Label( "Script asset is missing", input_y, null, this, 1, 2) );
			
		for (i in 0...length)
		{
			switch ( componentProperties[ (i*2) +1] )
			{
				case "Float":
					input = new NumberInput(componentProperties[i*2] , input_y, updateModel, this, 2, 2, NumberInput.ROUND_BOTH);
				case "Entity":
					input = new ObjectInput( componentProperties[i*2],input_y, updateModel, this, 2, 2, ControlBase.ROUND_BOTH,  ObjectType.ENTITY);
				case "Color":
					input = new TextInput( "0xffffff", input_y, updateModel, this, 2, 2);
				case "String":
					input = new TextInput( "text", input_y, updateModel, this, 2, 2);
				default:
					continue;
			}
			
			property_controls.push( new Label( componentProperties[i*2]+":", input_y, null, this, 1, 2) );
			property_controls.push(input);
			input_y += 30;
		}
	}
	
	private function haveEditorPropertiesChanged():Bool
	{
		return componentProperties.toString() != asset.classFields.toString();
	} 
	
	
}