import SwiftUI

private struct OverScrollScaleModifier: ViewModifier {
    let outterCoordinateName: String

    @State private var contentHeight: CGFloat = 0
    @State private var minY: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .readLocalFrame {
                contentHeight = $0.height
            }
            .scaleEffect(scaleFactor, anchor: .bottom)
            .readNamedFrame(coordinateName: outterCoordinateName) { frame in
                minY = frame.minY
            }
    }

    private var contentOffset: CGFloat {
        -max(0, minY)
    }

    private var scaleFactor: CGFloat {
        1 + (-contentOffset / max(1, contentHeight))
    }
}

public extension View {
    func overScrollScale(outterCoordinateName: String) -> some View {
        modifier(OverScrollScaleModifier(outterCoordinateName: outterCoordinateName))
    }
}
