import SwiftUI

struct OpacityButtonStyle: ButtonStyle {
    let opacity: CGFloat
    let isPressedStateEnable: Bool
    let isPressed: Binding<Bool>

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity((configuration.isPressed && isPressedStateEnable) ? opacity : 1)
            .onChange(of: configuration.isPressed) { newValue in
                isPressed.wrappedValue = newValue
            }
    }
}

extension ButtonStyle where Self == OpacityButtonStyle {
    static func opacity(_ opacity: CGFloat = 0.7, isPressedStateEnable: Bool = true, isPressed: Binding<Bool> = .constant(false)) -> OpacityButtonStyle {
        OpacityButtonStyle(opacity: opacity, isPressedStateEnable: isPressedStateEnable, isPressed: isPressed)
    }
}
