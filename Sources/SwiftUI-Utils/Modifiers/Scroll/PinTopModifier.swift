import SwiftUI

public enum PinTopAnchor {
    case top
    case center
    case bottom
}

private struct PinTop: ViewModifier {
    let offset: CGFloat
    let anchor: PinTopAnchor
    let isReversed: Bool
    let outterCoordinateName: String
    let percentageCompleted: Binding<CGFloat>

    private struct FrameData {
        let referenceY: CGFloat
        let viewHeight: CGFloat
    }

    @State private var frameData: FrameData = FrameData(referenceY: 0, viewHeight: 0)

    func body(content: Content) -> some View {
        content
            .offset(y: isReversed ? -max(0, frameData.referenceY - offset) : -min(0, frameData.referenceY - offset))
            .readNamedFrame(coordinateName: outterCoordinateName) { frame in
                switch anchor {
                case .top:
                    frameData = FrameData(referenceY: frame.minY, viewHeight: frame.height)
                case .center:
                    frameData = FrameData(referenceY: frame.midY, viewHeight: frame.height)
                case .bottom:
                    frameData = FrameData(referenceY: frame.maxY, viewHeight: frame.height)
                }
            }
            .onChange(of: percentage) { newValue in
                percentageCompleted.wrappedValue = newValue
            }
    }

    private var percentage: CGFloat {
        if abs(offset) > 0 {
            let viewOrigin: CGFloat
            switch anchor {
            case .top:
                viewOrigin = 0
            case .center:
                viewOrigin = frameData.viewHeight / 2
            case .bottom:
                viewOrigin = frameData.viewHeight
            }
            return max(0, min(1, 1 - abs(max(0, (frameData.referenceY - offset)) / (viewOrigin - offset))))
        } else {
            return 0
        }
    }
}

public extension View {
    func pinTop(offset: CGFloat, anchor: PinTopAnchor = .top, isReversed: Bool = false, outterCoordinateName: String, percentageCompleted: Binding<CGFloat> = .constant(0)) -> some View {
        modifier(PinTop(offset: offset, anchor: anchor, isReversed: isReversed, outterCoordinateName: outterCoordinateName, percentageCompleted: percentageCompleted))
    }
}
