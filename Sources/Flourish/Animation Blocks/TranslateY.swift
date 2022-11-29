/// Animates to zero translation along the y-axis.
public struct TranslateY: FlourishAnimation, Retimeable {
    
    /// The withered scale.
    var translation: Double = 0
    
    /// The animation timing curve.
    var timingCurve: TimingCurve
    
    public var duration: Double { timingCurve.duration }
    
    public init(_ translation: Double = 0, _ timingCurve: TimingCurve = .standard) {
        self.translation = translation
        self.timingCurve = timingCurve
    }

    public var triggers: [Trigger] {
        [.init(
            property: .translateY,
            value: translation,
            timingCurve: timingCurve
        )]
    }
}
