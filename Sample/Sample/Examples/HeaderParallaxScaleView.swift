import SwiftUI

struct HeaderParallaxScaleView: View {
    private let scrollViewCoordinateName = "HeaderParallaxScaleView.ScrollView"
    private let navigationBarHeight: CGFloat = 48

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .padding(.trailing, 16)
                    .frame(height: navigationBarHeight)
            }
            .zIndex(2)
            .frame(maxWidth: .infinity, alignment: .trailing)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    AsyncImage(url: URL(string: "https://picsum.photos/1200/1200")) { imagePhase in
                        imagePhase.image?
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(height: 300)
                    .clipped()
                    .headerParallaxScale(outterCoordinateName: scrollViewCoordinateName)

                    VStack {
                        ForEach(0..<6, id: \.self) { _ in
                            Rectangle()
                                .foregroundColor(.black)
                                .frame(height: 200)
                        }
                    }
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white)
                }
            }
            .coordinateSpace(name: scrollViewCoordinateName)
            .ignoresSafeArea(edges: .top)
            .zIndex(1)
        }
    }
}

#Preview {
    HeaderParallaxScaleView()
}
