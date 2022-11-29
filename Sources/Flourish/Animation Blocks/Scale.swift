/// Animates to 1.0 scale.
public struct Scale: FlourishAnimation, Retimeable {
    
    /// The withered scale.
    var scale: Double = 0
    
    /// The animation timing curve.
    var timingCurve: TimingCurve
    
    public var duration: Double { timingCurve.duration }
    
    public init(_ scale: Double = 0, _ timingCurve: TimingCurve = .standard) {
        self.scale = scale
        self.timingCurve = timingCurve
    }

    public var triggers: [Trigger] {
        [.init(property: .scale, value: scale, timingCurve: timingCurve)]
    }
}
