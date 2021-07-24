interface SpriteOffsetting
{
	public var animOffsets:Map<String, Array<Float>>;
	public function addOffset(name:String, x:Float = 0, y:Float = 0):Void;
	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void;
}
