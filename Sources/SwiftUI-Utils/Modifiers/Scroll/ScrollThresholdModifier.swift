import SwiftUI

private struct ScrollThresholdModifier: ViewModifier {
    let thresholds: [ScrollThreshold]
    let outterCoordinateName: String

    func body(content: Content) -> some View {
        content
            .readNamedFrame(coordinateName: outterCoordinateName) { frame in
                thresholds.forEach { threshold in
                    threshold.value.wrappedValue = threshold.condition(-frame.minY)
                }
            }
    }
}

public struct ScrollThreshold {
    let value: Binding<Bool>
    let condition: (CGFloat) -> Bool
}

public extension View {
    /// This modifier needs to be used on the full content of the ScrollView
    func scrollThresholdModifier(outterCoordinateName: String, value: Binding<Bool>, condition: @escaping (CGFloat) -> Bool) -> some View {
        modifier(
            ScrollThresholdModifier(
                thresholds: [ScrollThreshold(value: value, condition: condition)],
                outterCoordinateName: outterCoordinateName
            )
        )
    }

    /// This modifier needs to be used on the full content of the ScrollView
    func scrollThresholdsModifier(outterCoordinateName: String, thresholds: [ScrollThreshold]) -> some View {
        modifier(ScrollThresholdModifier(thresholds: thresholds, outterCoordinateName: outterCoordinateName))
    }
}
