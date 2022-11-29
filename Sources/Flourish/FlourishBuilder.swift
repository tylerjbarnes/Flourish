/// Allows expressive composition of Flourish animations.
@resultBuilder public struct FlourishBuilder {
    
    /// Collect provided animations into an array.
    public static func buildBlock(
        _ components: FlourishAnimation...
    ) -> [any FlourishAnimation] { components }
}
