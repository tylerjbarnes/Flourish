/// Layers multiple animations in parallel.
public struct Parallel: FlourishAnimation, Retimeable {
    
    /// The animation timing curve to apply to all children.
    var timingCurve: TimingCurve
    
    /// The animations to layer together.
    var animations: [any FlourishAnimation]
    
    public var duration: Double { animations.map(\.duration).max() ?? 0 }
    
    // Initialize without overriding timing.
    public init(
        @FlourishBuilder _ animations: () -> [any FlourishAnimation]
    ) {
        self.animations = animations()
        timingCurve = .standard
    }
    
    // Initialize and override timing.
    public init(
        _ timingCurve: TimingCurve = .standard,
        @FlourishBuilder _ animations: () -> [any FlourishAnimation]
    ) {
        self.animations = animations().map { animation in
            if let retimeableAnimation = animation as? Retimeable {
                return retimeableAnimation.retimed(to: timingCurve)
            } else {
                return animation
            }
        }
        self.timingCurve = timingCurve
    }

    public var triggers: [Trigger] { animations.flatMap(\.triggers) }
}
