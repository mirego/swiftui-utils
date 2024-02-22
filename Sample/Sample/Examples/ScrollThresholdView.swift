import SwiftUI

struct ScrollThresholdView: View {
    private let scrollViewCoordinateName = "ScrollThresholdView.ScrollView"

    @State private var showDivider = false
    @State private var headerScrolledPercentage: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            Text("Title!!")
                .padding(.vertical)
                .opacity((1 - headerScrolledPercentage))

            Divider()
                .background(Color.black)
                .opacity(showDivider ? 1 : 0)

            ScrollView {
                VStack {
                    ForEach(0..<10, id: \.self) { index in
                        Text("\(index)")
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red.opacity(0.2))
                            )
                    }
                }
                .padding(.vertical)
                .scrollThresholdModifier(
                    outterCoordinateName: scrollViewCoordinateName,
                    value: $showDivider
                ) {
                    $0 > 16
                }
                .scrollPercentageModifier(
                    percentage: $headerScrolledPercentage,
                    startValue: 0,
                    endValue: 100,
                    outterCoordinateName: scrollViewCoordinateName
                )
            }
            .padding(.horizontal)
            .coordinateSpace(name: scrollViewCoordinateName)
        }
    }
}

#Preview {
    ScrollThresholdView()
}
