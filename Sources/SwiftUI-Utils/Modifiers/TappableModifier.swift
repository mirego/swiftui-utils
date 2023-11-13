import SwiftUI

private struct TappableModifier: ViewModifier {
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        if let action = action {
            Button {
                action()
            } label: {
                content
            }
        } else {
            content
        }
    }
}

public extension View {
    func tappable(_ action: (() -> Void)?) -> some View {
        modifier(TappableModifier(action: action))
    }
}
