import SwiftUI

private struct BorderModifier<S>: ViewModifier where S: InsettableShape {
    let shape: S
    let color: Color
    let width: CGFloat
    let disabledOpacity: CGFloat

    @Environment(\.isEnabled) private var isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                shape
                    .strokeBorder(color.opacity(isEnabled ? 1 : disabledOpacity), lineWidth: width)
            }
    }
}

public extension View {
    func border(_ shape: some InsettableShape, color: Color, width: CGFloat = 1, disabledOpacity: CGFloat = 0.7) -> some View {
        modifier(BorderModifier(shape: shape, color: color, width: width, disabledOpacity: disabledOpacity))
    }
}
