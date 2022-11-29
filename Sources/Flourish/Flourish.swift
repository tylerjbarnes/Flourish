import SwiftUI

/// Applies a provided Flourish animation triggered by the environment's Flourish Group.
struct Flourish: ViewModifier {
    @Environment(\.flourishState) var flourishState
    @Environment(\.delayFlourish) var delayFlourish
    @Environment(\.delayWither) var delayWither
    
    // MARK: API
    
    /// The animation to apply upon change to `isFlourishing`.
    var flourishAnimation: FlourishAnimation
    
    /// An asymmetric animation to apply only when withering.
    ///
    /// If not provided, `flourishAnimation` will be played in reverse when withering.
    var witherAnimation: FlourishAnimation?
    

    func body(content: Content) -> some View {
        ZStack {
            content
                // Expose this flourish's durations to the containin group
                .flourishDuration(flourishDuration)
                .witherDuration(witherDuration)
            
                // Trigger animation state changes based on flourish state
                .onAppear(perform: applyEffectsOfInitialState)
                .onChange(of: flourishState.isFlourishing, perform: transition)
            
                // Apply flourish property states
                .opacity(flourishPropertyStates[.opacity] ?? 1)
                .offset(x: flourishPropertyStates[.translateX] ?? 0)
                
                .scaleEffect(flourishPropertyStates[.scale] ?? 1)
        }
        // Move offsetY to a containing VStack to prevent clash with offsetX
        .offset(y: flourishPropertyStates[.translateY] ?? 0)
    }
    
    
    // MARK: Duration Calculation
    
    var flourishDuration: Double { delayFlourish + flourishAnimation.duration }
    
    var witherDuration: Double {
        (witherAnimation ?? flourishAnimation).duration + delayWither
    }
    
    
    // MARK: Flourish Animation State
    
    /// A value for each flourish-animatable property of the view.
    @State private var flourishPropertyStates: [FlourishProperty: Double] = [:]

    /// Apply withered styling immediately if the view starts out in withered state.
    private func applyEffectsOfInitialState() {
        if !flourishState.isFlourishing { prepareToFlourish() }
    }
    

    // MARK: Animation Actions

    /// Flourish or wither when the environment's `isFlourishing` value changes.
    private func transition(shouldFlourish: Bool) {
        if shouldFlourish {
            prepareToFlourish()
            flourish()
        } else {
            wither()
        }
    }
    
    /// Reset each property state to its starting point for the Flourish animation.
    ///
    /// These starting points are based on the Flourish animation, not the Wither animation, even if one
    /// is present, since they need to set us up for running the Flourish animation specifically.
    private func prepareToFlourish() {
        guard flourishState.playhead == 0 else { return }
        
        for property in FlourishProperty.allCases {
            let triggers = flourishAnimation.triggers
                .filter { $0.property == property }
            
            if let trigger = triggers.first {
                flourishPropertyStates[property] = trigger.value
            }
        }
    }
    
    /// Animate all properties in the Flourish animation to flourished state.
    private func flourish() {

        // Trigger animations for each trigger in each animation property
        for property in FlourishProperty.allCases {
            let flourishTriggers = flourishAnimation.triggers
                .filter { $0.property == property }
            let witherTriggers = witherAnimation?.triggers
                .filter { $0.property == property }
            
            if flourishTriggers.isEmpty,
               let witherTriggers, !witherTriggers.isEmpty {
                
                // The flourish animation has no triggers for this property,
                // but the wither animation does.
                // Restore values with auto-generated triggers.
                
                // Define duration as remaining in the overall animation
                let duration = flourishAnimation.duration
                - flourishState.playhead
                
                // But use the curve of the wither animation
                let witherTiming = witherTriggers.last!.timingCurve
                
                withAnimation(witherTiming.asAnimation(duration: duration)) {
                    flourishPropertyStates[property] = property.defaultValue
                }
                
            } else {
             
                // The flourish animation has triggers for this property.
                // Animate them.
                for trigger in flourishTriggers {
                    
                    // Define duration as remaining after the playhead
                    let triggerStart = trigger.time + delayFlourish
                    let triggerEnd = triggerStart + trigger.duration
                    let duration = (triggerEnd - flourishState.playhead)
                        .clamped(to: 0...trigger.duration)
                    
                    // Define delay as distance from playhead to trigger start
                    let delay = (triggerStart - flourishState.playhead)
                        .clamped(toAtLeast: 0)

                    // Apply the property changes with animation
                    withAnimation(
                        trigger.timingCurve.asAnimation(duration: duration)
                            .delay(delay)
                    ) {
                        flourishPropertyStates[property] = property.defaultValue
                    }
                }
            }
        }
    }
    
    /// Animate or set all properties in the Flourish animation to withered state.
    private func wither() {

        // Trigger animations for each trigger in each animation property
        for property in FlourishProperty.allCases {
            let triggers = (
                witherAnimation?.triggers
                ?? flourishAnimation.triggers.reversed()
            ).filter { $0.property == property }
            
            for trigger in triggers {
                
                // Define duration as remaining before the playhead
                let triggerStart = trigger.time + delayWither
                let triggerEnd = triggerStart + trigger.duration
                let duration = (flourishState.playhead - triggerStart)
                    .clamped(to: 0...trigger.duration)
                
                // Define delay as distance from trigger end to playhead
                let delay = (flourishState.playhead - triggerEnd)
                    .clamped(toAtLeast: 0)

                // Apply the property changes with animation
                withAnimation(
                    trigger.timingCurve.asAnimation(duration: duration)
                        .delay(delay)
                ) {
                    flourishPropertyStates[property] = trigger.value
                }
            }
        }
    }
}


// MARK: View Extension

public extension View {
    
    /// Apply a Flourish animation to the view, triggered by a containing Flourish Group.
    func flourish(
        _ animation: FlourishAnimation = Opacity(),
        delayIn: Double = 0,
        delayOut: Double = 0
    ) -> some View {
        self
            .modifier(Flourish(flourishAnimation: animation))
            .delayFlourish(delayIn)
            .delayWither(delayOut)
    }
    
    /// Apply asymmetric Flourish animations to the view, triggered by a containing Flourish Group.
    func flourish(
        in flourishAnimation: FlourishAnimation,
        out witherAnimation: FlourishAnimation
    ) -> some View {
        modifier(Flourish(
            flourishAnimation: flourishAnimation,
            witherAnimation: witherAnimation
        ))
    }
    
    
    /// Apply parallel Flourish animations to the view, triggered by a containing Flourish Group.
    func flourish(
        delayIn: Double = 0,
        delayOut: Double = 0,
        @FlourishBuilder _ animations: () -> [any FlourishAnimation]
    ) -> some View {
        self
            .modifier(Flourish(flourishAnimation: Parallel(animations)))
            .delayFlourish(delayIn)
            .delayWither(delayOut)
    }
    
    /// Apply sequenced Flourish animations to the view, triggered by a containing Flourish Group.
    func flourishSequence(
        @FlourishBuilder _ animations: () -> [any FlourishAnimation]
    ) -> some View {
        modifier(Flourish(flourishAnimation: Sequenced(animations)))
    }
}
