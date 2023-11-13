import SwiftUI

private struct FadeOutOnScrollModifier: ViewModifier {
    let fullOpacityAbove: CGFloat
    let zeroOpacityBelow: CGFloat
    let coordinateName: String
    let outterCoordinateName: String

    @State private var originY: CGFloat = 0
    @State private var outterMinY: CGFloat = 0
    @State private var contentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .readNamedFrame(coordinateName: coordinateName) {
                originY = $0.minY
            }
            .readNamedFrame(coordinateName: outterCoordinateName) { frame in
                outterMinY = frame.minY
            }
    }

    private var opacity: CGFloat {
        let relativeMinY = originY - outterMinY
        if relativeMinY < fullOpacityAbove {
            return 1
        } else if relativeMinY > zeroOpacityBelow {
            return 0
        } else {
            return 1 - ((relativeMinY - fullOpacityAbove) / (zeroOpacityBelow - fullOpacityAbove))
        }
    }
}

public extension View {
    func fadeOutOnScroll(
        fullOpacityAbove: CGFloat,
        zeroOpacityBelow: CGFloat,
        coordinateName: String,
        outterCoordinateName: String
    ) -> some View {
        modifier(
            FadeOutOnScrollModifier(
                fullOpacityAbove: fullOpacityAbove,
                zeroOpacityBelow: zeroOpacityBelow,
                coordinateName: coordinateName,
                outterCoordinateName: outterCoordinateName
            )
        )
    }
}
