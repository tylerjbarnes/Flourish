import SwiftUI

/// An assembler that toggles assembly upon tap.
public struct PreviewFlourishGroup<Content: View>: View {

    /// The content for projection in the assembler.
    var content: Content
    
    public init(
        isFlourishing: Bool = true,
        @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
        _shouldFlourish = .init(initialValue: isFlourishing)
    }
    
    /// The state of assembly.
    @State private var shouldFlourish: Bool
    
    public var body: some View {
        VStack {
            content.flourishWhen(shouldFlourish)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture { shouldFlourish.toggle() }
    }
}

struct PreviewAssembler_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFlourishGroup {
            VStack(alignment: .trailing, spacing: 20) {
                
                Text("Hello")
                    .font(.largeTitle)
                    .flourish {
                        TranslateX(-40)
                        Opacity()
                    }
                    .delayWither(0.05)
                
                Text("there")
                    .font(.largeTitle)
                    .flourish {
                        TranslateX(-40)
                        Opacity()
                    }
                    .delayFlourish(0.05)
            }
        }
    }
}
