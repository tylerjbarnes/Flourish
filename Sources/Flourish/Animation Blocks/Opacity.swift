/// Animates to full opacity.
public struct Opacity: FlourishAnimation, Retimeable {
    
    /// The withered opacity.
    var opacity: Double
    
    /// The animation timing curve.
    var timingCurve: TimingCurve
    
    public var duration: Double { timingCurve.duration }
    
    public init(_ opacity: Double = 0, _ timingCurve: TimingCurve = .standard) {
        self.opacity = opacity
        self.timingCurve = timingCurve
    }

    public var triggers: [Trigger] {
        [.init(property: .opacity, value: opacity, timingCurve: timingCurve)]
    }
}
