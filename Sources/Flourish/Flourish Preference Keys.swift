import SwiftUI

/// Allows a view with flourish animation to expose its duration for use by the containing flourish group.
struct FlourishDurationKey: PreferenceKey {
    static var defaultValue = CGFloat.zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = [value, nextValue()].max() ?? 0
    }
}

/// Allows a view with flourish animation to expose its asymmetric
/// wither duration for use by the containing flourish group.
struct WitherDurationKey: PreferenceKey {
    static var defaultValue = CGFloat.zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = [value, nextValue()].max() ?? 0
    }
}


// MARK: View Extension

extension View {
    
    /// Provides flourish duration for use by the containing flourish group.
    func flourishDuration(_ duration: CGFloat) -> some View {
        self.preference(key: FlourishDurationKey.self, value: duration)
    }
    
    /// Provides asymmetric wither duration for use by the containing flourish group.
    func witherDuration(_ duration: CGFloat) -> some View {
        self.preference(key: WitherDurationKey.self, value: duration)
    }
}
