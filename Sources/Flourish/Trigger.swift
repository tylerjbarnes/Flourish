/// A timed animation trigger of a single Flourish property.
public struct Trigger {
    
    /// The property to animate.
    var property: FlourishProperty
    
    /// The start value of the property when flourishing and the end value when withering.
    var value: Double
    
    /// The animation start time.
    var time: Double = 0
    
    /// The duration and interpolation of the animation.
    var timingCurve: TimingCurve = .linear()
    
    /// The duration of the animation.
    var duration: Double { timingCurve.duration }
}
