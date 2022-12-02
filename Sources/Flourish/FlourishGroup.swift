import SwiftUI

/// Manages flourish animation for all descendants of the host view by providing environment values.
struct FlourishGroup: ViewModifier {
    
    // MARK: API
    
    /// The view hierarchy should be in flourished state.
    var isFlourishing: Bool
    
    /// Initialize with an initial flourished state.
    init(_ isFlourishing: Bool) {
        self.isFlourishing = isFlourishing
        _state = .init(
            initialValue: FlourishState(isFlourishing: isFlourishing)
        )
        hostViewShouldExist = isFlourishing
    }
    
    func body(content: Content) -> some View {
        VStack {
            if hostViewShouldExist { content }
        }
        .onPreferenceChange(FlourishDurationKey.self,
                            perform: setFlourishDuration)
        .onPreferenceChange(WitherDurationKey.self,
                            perform: setWitherDuration)
        .environment(\.flourishState, state)
        .onChange(of: isFlourishing, perform: triggerTransition)
    }
    
    
    // MARK: Flourish State
    
    /// The state of the flourish timeline to provide for all descendants to trigger their animations.
    @State private var state: FlourishState
    
    /// The host view should be rendered into the hierarchy because it is not fully withered.
    @State private var hostViewShouldExist: Bool
    
    /// Triggers the removal of the host view upon completion of withering.
    @State private var destructionTimer: Timer?
    
    
    // MARK: Descendant Duration Data
    
    /// The total duration of the view hierarchy's flourish animation.
    ///
    /// This is measured via preferences and used to determine when all descendants are fully withered
    /// and it's therefore safe to remove the host view from the hierarchy.
    @State private var flourishDuration = CGFloat.zero
    
    /// The total duration of the view hierarchy's wither animation.
    @State private var witherDuration = CGFloat.zero
    
    /// Update duration and set initial playhead when descendants report duration preferences.
    private func setFlourishDuration(to duration: CGFloat) {
        self.flourishDuration = duration
        state.playhead = state.isFlourishing ? duration : 0
    }
    
    /// Update duration when descendants report asymmetric wither duration preferences.
    private func setWitherDuration(to duration: CGFloat) {
        self.witherDuration = duration
    }
    
    // MARK: Animation Actions
    
    /// Trigger a flourish or wither and mark the transition start time.
    private func triggerTransition(shouldFlourish: Bool) {
        
        // Cancel any impending destruction
        destructionTimer?.invalidate()
        
        // Update the playhead to the start point of this transition
        updatePlayhead(isStartingFlourish: shouldFlourish)
        
        // Trigger a flourish or wither
        if shouldFlourish { triggerFlourish() } else { triggerWither() }
    }
    
    /// Set the playhead position to the flourish start or wither end.
    private func updatePlayhead(isStartingFlourish: Bool) {
        state.playhead = isStartingFlourish ? 0 : witherDuration
    }
    
    // Add the host view to the hierarchy then trigger flourish animations.
    private func triggerFlourish() {
        hostViewShouldExist = true
        DispatchQueue.main.async { state.isFlourishing = true }
    }
    
    // Trigger wither animations, then upon completion, remove the host view.
    private func triggerWither() {
        DispatchQueue.main.async { state.isFlourishing = false }
        destructionTimer = Timer.scheduledTimer(
            withTimeInterval: state.playhead,
            repeats: false,
            block: { _ in hostViewShouldExist = false }
        )
    }
}


// MARK: View Extension

public extension View {
    
    /// Apply a flourish group to the host using the provided boolean as its `isFlourishing` state.
    func flourishWhen(_ isFlourishing: Bool) -> some View {
        modifier(FlourishGroup(isFlourishing))
    }
}
