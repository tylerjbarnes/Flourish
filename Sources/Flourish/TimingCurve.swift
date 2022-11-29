import SwiftUI

/// The duration and interpolation of an animation.
public struct TimingCurve {
    
    /// The leading control handle's x position.
    var c0x: Double
    
    /// The leading control handle's y position.
    var c0y: Double
    
    /// The trailing control handle's x position.
    var c1x: Double
    
    /// The trailing control handle's y position.
    var c1y: Double
    
    /// The duration of the animation in seconds.
    var duration: Double
    
    public init(
        _ c0x: Double,
        _ c0y: Double,
        _ c1x: Double,
        _ c1y: Double,
        duration: Double? = nil
    ) {
        self.c0x = c0x
        self.c0y = c0y
        self.c1x = c1x
        self.c1y = c1y
        self.duration = duration ?? 0.35
    }
    
    /// A standard default animation for all of Flourish.
    public static var standard = ease()
    
    /// A timing curve with linear interpolation for both leading and trailing.
    public static func linear(_ duration: Double? = nil) -> TimingCurve {
        TimingCurve(0, 0, 1, 1, duration: duration)
    }
    
    /// A timing curve with eased interpolation for both leading and trailing.
    public static func ease(
        _ duration: Double? = nil,
        intensity: Double = 0.5
    ) -> TimingCurve {
        TimingCurve(intensity, 0, 1 - intensity, 1, duration: duration)
    }
}


// MARK: Interpolation

extension TimingCurve {
    
    /// Get a SwiftUI animation based on the timing curve, optionally modifying duration.
    func asAnimation(duration: Double? = nil) -> SwiftUI.Animation {
        .timingCurve(c0x, c0y, c1x, c1y, duration: duration ?? self.duration)
    }
}
