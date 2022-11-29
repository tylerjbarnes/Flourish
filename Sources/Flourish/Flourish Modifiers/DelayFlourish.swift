import SwiftUI

/// Adds a delay for all flourishes in the view's descendant hierarchy.
struct DelayFlourish: ViewModifier {
    @Environment(\.delayFlourish) var previousDelay
    
    /// The number of seconds to delay.
    var delay: Double
    
    func body(content: Content) -> some View {
        content.environment(\.delayFlourish, previousDelay + delay)
    }
}


// MARK: View Extension

public extension View {
    
    /// Adds a delay for all flourishes in the view's descendant hierarchy.
    func delayFlourish(_ delay: Double) -> some View {
        modifier(DelayFlourish(delay: delay))
    }
}


// MARK: Environment

/// Defines an additive delay for all flourishes in its descendant hierarchy.
private struct DelayFlourishKey: EnvironmentKey {
    static let defaultValue = CGFloat.zero
}

public extension EnvironmentValues {
    
    /// Defines an additive delay for all flourishes in its descendant hierarchy.
    var delayFlourish: CGFloat {
        get { self[DelayFlourishKey.self] }
        set { self[DelayFlourishKey.self] = newValue }
    }
}
