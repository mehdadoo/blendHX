package blendhx.engine.events;

class ProgressEvent extends Event
{
	public static inline var PROGRESS:String = "progress";

	public var progress:UInt;
	public var total:UInt;

	public function new(type:String, progress:UInt = 1, total:UInt = 1)
	{
		super(type);

		this.progress = progress;
		this.total = total;
	}
}