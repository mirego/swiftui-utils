import SwiftUI

private struct ScrollPercentageModifier: ViewModifier {
    let percentages: [ScrollPercentage]
    let outterCoordinateName: String

    func body(content: Content) -> some View {
        content
            .readNamedFrame(coordinateName: outterCoordinateName) { frame in
                let offset = -frame.minY
                percentages.forEach { percentage in
                    guard percentage.startValue < percentage.endValue else {
                        percentage.percentage.wrappedValue = 0
                        return
                    }

                    if offset <= percentage.startValue {
                        percentage.percentage.wrappedValue = 0
                    } else if offset >= percentage.endValue {
                        percentage.percentage.wrappedValue = 1
                    } else {
                        percentage.percentage.wrappedValue = (offset - percentage.startValue) / (percentage.endValue - percentage.startValue)
                    }
                }
            }
    }
}

public struct ScrollPercentage {
    let percentage: Binding<CGFloat>
    let startValue: CGFloat
    let endValue: CGFloat
}

public extension View {
    /// This modifier needs to be used on the full content of the ScrollView
    func scrollPercentageModifier(
        percentage: Binding<CGFloat>,
        startValue: CGFloat,
        endValue: CGFloat,
        outterCoordinateName: String
    ) -> some View {
        modifier(
            ScrollPercentageModifier(
                percentages: [ScrollPercentage(percentage: percentage, startValue: startValue, endValue: endValue)],
                outterCoordinateName: outterCoordinateName
            )
        )
    }

    /// This modifier needs to be used on the full content of the ScrollView
    func scrollPercentagesModifier(outterCoordinateName: String, percentages: [ScrollPercentage]) -> some View {
        modifier(ScrollPercentageModifier(percentages: percentages, outterCoordinateName: outterCoordinateName))
    }
}
