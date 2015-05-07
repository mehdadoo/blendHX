package blendhx.editor.ui.panels;

import blendhx.engine.assets.Assets;
import blendhx.engine.assets.Material;

import blendhx.editor.helpers.Color;
import blendhx.editor.ui.controls.*;
import blendhx.editor.events.MaterialEvent;


import hxsl.Shader;


class MaterialPanel extends Panel
{
	private var material:Material;
	private var shaderPropertiesStringCopy:String;
	private var property_controls:Array<ControlBase> = [];
	private var shader_control:ObjectInput;
	
	public function new() 
	{
		super("Material", 200, false, false);
	}
	
	
	override private function initialize()
	{
		super.initialize();
	}
	
	override public function update()
	{
		var fileItem:FileItem = model.selectedFileItem;
		var material_id:UInt = model.assets.getID( fileItem.sourceURL );
		
		//flawly the material file is not in the assets
		if(material_id == 0)
		{
			trace("Please delete the selected material, it does not exist in the assets", Color.RED);
			return;
		}	
		material = model.assets.get( Assets.MATERIAL,  material_id);
		
		//Shader editor-properties have not changed, no need to recreate the user interface controls
		if( haveEditorPropertiesChanged() )
			recreateControls();
			
		updateControlValues();
	}
	
	private function updateControlValues():Void
	{
		var editorProperties:Array<String> = material.shader.editorProperties;
		var properties:Map<String, Dynamic> = material.properties;
		
		for (i in 0...property_controls.length)
		{
			property_controls[ i ].value = properties.get(editorProperties[i*2]);
		}
	}
	
	private function updateShader() 
	{
		//save shader change to the material
		updateModel();
		//recreate the controls according to the new shader
		recreateControls();
		updateControlValues();
		//save the default values of the controls again to the material, so the shader renders correctly
		updateModel();
	}
	override private function updateModel() 
	{
		var editorProperties:Array<String> = material.shader.editorProperties;
		var length:Int = Std.int( editorProperties.length / 2 );
		var properties:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		for (i in 0...property_controls.length)
			properties.set( editorProperties[i*2] , property_controls[ i ].value );
			
		var e:MaterialEvent = new MaterialEvent( MaterialEvent.CHANGE );
		e.material = material;
		e.shaderURL = shader_control.value;
		e.properties = properties;
		
		dispatchEvent( e );
	};
	
	private function recreateControls()
	{
		property_controls = [];
		removeUIComponents();
		shaderPropertiesStringCopy = material.shader.editorProperties.toString();
		var editorProperties:Array<String> = material.shader.editorProperties;
		var length:Int = Std.int( editorProperties.length / 2 );
		var input_y:Int = 80;
		var input:ControlBase;
		
		new Label( "Shader:" , 30, null, this);
		shader_control = new ObjectInput( material.shaderURL, 50, updateShader, this, 1, 1, ObjectInput.SCRIPT);

		for (i in 0...length)
		{
			new Label( editorProperties[i*2]+":", input_y, null, this, 1, 2);
			
			switch ( editorProperties[ (i*2) +1] )
			{
				case "Float":
					input = new NumberInput( editorProperties[i*2] , input_y, updateModel, this, 2, 2, NumberInput.ROUND_BOTH);
				case "Texture":
					input = new ObjectInput( "textures/defaultTexture.png" ,input_y+=20, updateModel, this, 1, 1, ControlBase.ROUND_BOTH,  ObjectInput.IMAGE);
				case "Color":
					input = new TextInput( "0xffeeee", input_y, updateModel, this, 2, 2);
				default:
					trace("Unknown shader property type: "+editorProperties[ (i*2) +1]);
					continue;
			}
			
			property_controls.push(input);
			input_y += 30;
		}
		
		//new Button("Save", input_y, updateModel, this);
	}
	
	private function haveEditorPropertiesChanged():Bool
	{
		if( material == null || material.shader == null )
			return false;
			
		return shaderPropertiesStringCopy != material.shader.editorProperties.toString();
	}
}