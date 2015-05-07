package blendhx.editor.events;

class ProgressEvent extends DisposableEvent
{
	public static inline var PROGRESS:String = "progress";
	public static inline var SCRIPTS_COMPILED:String = "scripts compiled";

	public var progress:UInt;
	public var total:UInt;
	
	public var text:String;
	public var isEndless:Bool;

	public function new(type:String, progress:UInt = 1, total:UInt = 1, text:String = null)
	{
		super(type);

		this.progress = progress;
		this.total = total;
		this.text = text;
	}
}
