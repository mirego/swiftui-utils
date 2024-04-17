import SwiftUI

public struct OverlayButtonStyle<S>: ButtonStyle where S: Shape {
    let backgroundShape: S
    let color: Color
    let isPressedStateEnable: Bool
    let isPressed: Binding<Bool>

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .contentShape(backgroundShape)
            .overlay {
                backgroundShape.fill(
                    color.opacity((isPressedStateEnable && configuration.isPressed) ? 1 : 0)
                )
            }
            .onChange(of: configuration.isPressed) { newValue in
                isPressed.wrappedValue = newValue
            }
    }
}

public extension ButtonStyle where Self == OpacityButtonStyle {
    static func overlay<S>(shape: S, color: Color = .black.opacity(0.1), isPressedStateEnable: Bool = true, isPressed: Binding<Bool> = .constant(false)) -> OverlayButtonStyle<S> where S: Shape {
        OverlayButtonStyle(backgroundShape: shape, color: color, isPressedStateEnable: isPressedStateEnable, isPressed: isPressed)
    }
}
