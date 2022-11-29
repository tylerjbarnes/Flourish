/// A view property animatable via flourish and wither.
enum FlourishProperty: CaseIterable {
    case opacity
    case translateX
    case translateY
    case rotate
    case scale
    
    /// The identity value of the property, set when fully flourished.
    var defaultValue: Double {
        switch self {
        case .opacity:
            return 1
        case .translateX:
            return 0
        case .translateY:
            return 0
        case .rotate:
            return 0
        case .scale:
            return 1
        }
    }
}
