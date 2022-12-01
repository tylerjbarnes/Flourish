/// Animates to zero translation along the x-axis.
public struct TranslateX: FlourishAnimation, Retimeable {
    
    /// The withered translation.
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
            property: .translateX,
            value: translation,
            timingCurve: timingCurve
        )]
    }
}
