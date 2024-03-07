import SwiftUI

private struct OnVisibleModifier: ViewModifier {
    @Binding var onVisible: Bool
    let callback: (Bool) -> Void

    @Environment(\.scrollViewContextData) var scrollViewContextData

    @State private var viewFrame = CGRect()
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .ifLet(scrollViewContextData) { view, scrollViewContextData in
                view.readNamedFrame(coordinateName: scrollViewContextData.coordinateSpaceName) { viewFrame in
                    self.viewFrame = viewFrame
                    updateVisiblity()
                }
            }
    }

    private var effectiveInFrame: CGRect {
        guard let scrollViewContextData else { return .zero }
        return CGRect(
            x: scrollViewContextData.frame.wrappedValue.minX,
            y: scrollViewContextData.frame.wrappedValue.minY,
            width: scrollViewContextData.frame.wrappedValue.width,
            height: scrollViewContextData.frame.wrappedValue.height + scrollViewContextData.safeAreaInsets.top + scrollViewContextData.safeAreaInsets.bottom
        )
    }

    private var effectiveLocalFrame: CGRect {
        guard let scrollViewContextData else { return .zero }
        return CGRect(
            x: viewFrame.minX,
            y: viewFrame.minY + scrollViewContextData.safeAreaInsets.top,
            width: viewFrame.width,
            height: viewFrame.height
        )
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
        callback: @escaping  (Bool) -> Void
    ) -> some View {
        modifier(
            OnVisibleModifier(
                onVisible: .constant(false),
                callback: callback
            )
        )
    }

    func onVisible(
        onVisible: Binding<Bool>
    ) -> some View {
        modifier(
            OnVisibleModifier(
                onVisible: onVisible,
                callback: { _ in }
            )
        )
    }
}

struct ScrollViewContextDataKey: EnvironmentKey {
    static let defaultValue: ScrollViewContextData? = nil
}

public extension EnvironmentValues {
    var scrollViewContextData: ScrollViewContextData? {
        get { self[ScrollViewContextDataKey.self] }
        set { self[ScrollViewContextDataKey.self] = newValue }
    }
}

public struct ScrollViewContextData {
    let frame: Binding<CGRect>
    let safeAreaInsets: EdgeInsets
    let coordinateSpaceName: String

    public init(frame: Binding<CGRect>, safeAreaInsets: EdgeInsets, coordinateSpaceName: String) {
        self.frame = frame
        self.safeAreaInsets = safeAreaInsets
        self.coordinateSpaceName = coordinateSpaceName
    }
}
