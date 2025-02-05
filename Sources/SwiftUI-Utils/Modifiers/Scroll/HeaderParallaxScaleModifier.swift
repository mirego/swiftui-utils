import SwiftUI

private struct HeaderParallaxScaleModifier: ViewModifier {
    let parallaxFactor: CGFloat?
    let anchor: UnitPoint
    let outterCoordinateName: String

    @State private var contentHeight: CGFloat = 0
    @State private var minY: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .readLocalFrame {
                contentHeight = $0.height
            }
            .ifLet(parallaxFactor) { content, value in
                content.offset(y: -min(0, minY * value))
            }
            .scaleEffect(scaleFactor, anchor: anchor)
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
    func headerParallaxScale(parallaxFactor: CGFloat? = 1 / 3, anchor: UnitPoint = .bottom, outterCoordinateName: String) -> some View {
        modifier(HeaderParallaxScaleModifier(parallaxFactor: parallaxFactor, anchor: anchor, outterCoordinateName: outterCoordinateName))
    }
}
