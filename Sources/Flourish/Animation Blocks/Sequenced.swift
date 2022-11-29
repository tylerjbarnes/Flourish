/// Sequences animations as a timeline.
public struct Sequenced: FlourishAnimation {
    
    /// The animations to play in sequence.
    var animations: [any FlourishAnimation]
    
    public var duration: Double { animations.map(\.duration).reduce(0, +) }
    
    public init(@FlourishBuilder _ animations: () -> [any FlourishAnimation]) {
        self.animations = animations()
    }
    
    public var triggers: [Trigger] {
        var startOffset: Double = 0
        var triggers: [Trigger] = []
        
        for animation in animations {
            triggers.append(contentsOf: animation.triggers.map {
                .init(
                    property: $0.property,
                    value: $0.value,
                    time: $0.time + startOffset,
                    timingCurve: $0.timingCurve
                )
            })
            startOffset += animation.duration
        }
        
        return triggers
    }
}
