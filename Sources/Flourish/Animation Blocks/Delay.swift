/// Introduces a delay for sequenced animations.
public struct Delay: FlourishAnimation {
    
    public var duration: Double
    
    public init(_ duration: Double) { self.duration = duration }
    
    public var triggers: [Trigger] { [] }
}
