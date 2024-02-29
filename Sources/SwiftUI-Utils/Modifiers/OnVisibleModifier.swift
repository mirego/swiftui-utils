import SwiftUI

private struct OnVisibleModifier: ViewModifier {
    @Binding var parentFrame: CGRect
    let parentSafeAreaInsets: EdgeInsets
    let coordinateName: String
    @Binding var onVisible: Bool
    let callback: (Bool) -> Void

    @State private var viewFrame = CGRect()
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .readNamedFrame(coordinateName: coordinateName) { viewFrame in
                self.viewFrame = viewFrame
                updateVisiblity()
            }
    }

    private var effectiveInFrame: CGRect {
        CGRect(x: parentFrame.minX, y: parentFrame.minY, width: parentFrame.width, height: parentFrame.height + parentSafeAreaInsets.top + parentSafeAreaInsets.bottom)
    }

    private var effectiveLocalFrame: CGRect {
        CGRect(x: viewFrame.minX, y: viewFrame.minY + parentSafeAreaInsets.top, width: viewFrame.width, height: viewFrame.height)
    }

    private func updateVisiblity() {
        let newIsVisible = effectiveInFrame.intersects(effectiveLocalFrame)
        if !isVisible && newIsVisible {
            callback(true)
            onVisible = true
            isVisible = true
        } else if isVisible && !newIsVisible {
            callback(false)
            onVisible = false
            isVisible = false
        }
    }
}

public extension View {
    func onVisible(
        parentFrame: Binding<CGRect>,
        parentSafeAreaInsets: EdgeInsets,
        coordinateName: String,
        callback: @escaping  (Bool) -> Void
    ) -> some View {
        modifier(
            OnVisibleModifier(
                parentFrame: parentFrame,
                parentSafeAreaInsets: parentSafeAreaInsets,
                coordinateName: coordinateName,
                onVisible: .constant(false),
                callback: callback
            )
        )
    }

    func onVisible(
        parentFrame: Binding<CGRect>,
        parentSafeAreaInsets: EdgeInsets,
        coordinateName: String,
        onVisible: Binding<Bool>
    ) -> some View {
        modifier(
            OnVisibleModifier(
                parentFrame: parentFrame,
                parentSafeAreaInsets: parentSafeAreaInsets,
                coordinateName: coordinateName,
                onVisible: onVisible,
                callback: { _ in }
            )
        )
    }
}
