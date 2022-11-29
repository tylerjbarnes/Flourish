extension Comparable {
    
    /// A constrained copy of the number within the given limits.
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
    
    /// A constrained copy of the number above or equal to the given minimum.
    func clamped(toAtLeast lowerBound: Self) -> Self {
        max(self, lowerBound)
    }
    
    /// A constrained copy of the number below or equal to the given maximum.
    func clamped(toAtMost upperBound: Self) -> Self {
        min(self, upperBound)
    }
}
