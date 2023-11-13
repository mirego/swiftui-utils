import SwiftUI

private struct ScaleOnScrollModifier: ViewModifier {
    let finalScale: CGFloat
    let noScaleBefore: CGFloat
    let fullScaleOver: CGFloat
    let coordinateName: String
    let outterCoordinateName: String

    @State private var originY: CGFloat = 0
    @State private var outterMinY: CGFloat = 0
    @State private var contentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .scaleEffect(scaleFactor)
            .readNamedFrame(coordinateName: coordinateName) {
                originY = $0.minY
            }
            .readNamedFrame(coordinateName: outterCoordinateName) { frame in
                outterMinY = frame.minY
            }
    }

    private var scaleFactor: CGFloat {
        let relativeMinY = originY - outterMinY
        if relativeMinY < noScaleBefore {
            return 1
        } else if relativeMinY > fullScaleOver {
            return finalScale
        } else {
            let result = 1 + ((finalScale - 1) * ((relativeMinY - noScaleBefore) / (fullScaleOver - noScaleBefore)))
            return result
        }
    }
}

public extension View {
    func scaleOnScroll(
        finalScale: CGFloat,
        noScaleBefore: CGFloat,
        fullScaleOver: CGFloat,
        coordinateName: String,
        outterCoordinateName: String
    ) -> some View {
        modifier(
            ScaleOnScrollModifier(
                finalScale: finalScale,
                noScaleBefore: noScaleBefore,
                fullScaleOver: fullScaleOver,
                coordinateName: coordinateName,
                outterCoordinateName: outterCoordinateName
            )
        )
    }
}
