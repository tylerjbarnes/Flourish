import SwiftUI

/// A set of sequenced and/or parallelized animatable property changes that can be interpreted
/// as a timeline either from withered to flourished or flourished to withered.
public protocol FlourishAnimation {
    
    /// The total duration of the animation.
    var duration: Double { get }
    
    /// Timed flourish property changes that comprise the animation.
    var triggers: [Trigger] { get }
}


// MARK: Retiming

/// A flourish animation that can have its timing modified.
///
/// This allows greater compositional flexibility, such as allowing Parallel to retime its children.
protocol Retimeable: FlourishAnimation {
    
    /// The animation's timing curve.
    var timingCurve: TimingCurve { get set }
    
    /// Get a copy of the animation with the new timing curve applied.
    func retimed(to timingCurve: TimingCurve) -> Self
}

extension Retimeable {
    
    func retimed(to timingCurve: TimingCurve) -> Self {
        var retimedAnimation = self
        retimedAnimation.timingCurve = timingCurve
        return retimedAnimation
    }
}
