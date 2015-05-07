package blendhx.engine.components;

interface IComposite extends IComponent
{
	#if editor
	@:isVar public var collapseInHierarchy(get, set):Bool;
	#end
	
	public var children: Array<IComponent>;
	public function addChild(child:IComponent):Void;
	public function removeChild(child:IComponent):Void;
	public function getChild( componentType:Class<IComponent> ):IComponent;
}