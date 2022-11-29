import SwiftUI

/// Adds a delay for all withers in the view's descendant hierarchy.
struct DelayWither: ViewModifier {
    @Environment(\.delayWither) var previousDelay
    
    /// The number of seconds to delay.
    var delay: Double
    
    func body(content: Content) -> some View {
        content.environment(\.delayWither, previousDelay + delay)
    }
}


// MARK: View Extension

public extension View {
    
    /// Adds a delay for all withers in the view's descendant hierarchy.
    func delayWither(_ delay: Double) -> some View {
        modifier(DelayWither(delay: delay))
    }
}


// MARK: Environment

/// Defines an additive delay for all withers in its descendant hierarchy.
private struct DelayWitherKey: EnvironmentKey {
    static let defaultValue = CGFloat.zero
}

extension EnvironmentValues {
    
    /// Defines an additive delay for all withers in its descendant hierarchy.
    var delayWither: CGFloat {
        get { self[DelayWitherKey.self] }
        set { self[DelayWitherKey.self] = newValue }
    }
}
