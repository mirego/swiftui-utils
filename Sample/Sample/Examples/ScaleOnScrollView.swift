import SwiftUI

struct ScaleOnScrollView: View {
    private let scrollViewCoordinateName = "ScaleOnScrollView.ScrollView"
    private let vStackCoordinateName = "ScaleOnScrollView.VStack"

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 100) {
                Rectangle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
                    .scaleOnScroll(
                        finalScale: 0.5,
                        noScaleBefore: 0,
                        fullScaleOver: 50,
                        coordinateName: vStackCoordinateName,
                        outterCoordinateName: scrollViewCoordinateName
                    )
                    .padding(.top, 100)

                Rectangle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                    .scaleOnScroll(
                        finalScale: 2,
                        noScaleBefore: 50,
                        fullScaleOver: 100,
                        coordinateName: vStackCoordinateName,
                        outterCoordinateName: scrollViewCoordinateName
                    )

                Rectangle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .scaleOnScroll(
                        finalScale: 3,
                        noScaleBefore: 100,
                        fullScaleOver: 300,
                        coordinateName: vStackCoordinateName,
                        outterCoordinateName: scrollViewCoordinateName
                    )
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 700)
            .coordinateSpace(name: vStackCoordinateName)
        }
        .coordinateSpace(name: scrollViewCoordinateName)
    }
}
#Preview {
    ScaleOnScrollView()
}
