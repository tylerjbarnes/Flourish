import SwiftUI

/// Models the latest transition point to happen in a Flourish group's state.
///
/// This is not a live object in the sense of being updated with each animation frame.
/// Instead, it is only updated when the `isFlourishing` state changes.
///
/// This model exists to notate important metadata about the moment that `isFlourishing` changes,
/// namely the position of the virtual playhead at the moment the change occurs.
struct FlourishState {
    
    /// The flourishes in the group should move to their flourished states.
    var isFlourishing = false
    
    /// The number of seconds elapsed in the timeline from withered to flourished
    /// as recorded at the moment that `isFlourishing` changed.
    var playhead: Double = 0
}


// MARK: - Environment Value

private struct FlourishStateKey: EnvironmentKey {
    static let defaultValue = FlourishState()
}

extension EnvironmentValues {
  var flourishState: FlourishState {
    get { self[FlourishStateKey.self] }
    set { self[FlourishStateKey.self] = newValue }
  }
}
