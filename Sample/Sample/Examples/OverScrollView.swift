import SwiftUI

struct OverScrollView: View {
    private let scrollViewCoordinateName = "ScaleOnScrollView.ScrollView"
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
                AsyncImage(url: URL(string: "https://picsum.photos/1200/1200")) { imagePhase in
                    imagePhase.image?
                        .resizable()
                        .scaledToFill()
                }
                .frame(height: 300)
                .clipped()
                .overScrollScale(outterCoordinateName: scrollViewCoordinateName)
            }
            .coordinateSpace(name: scrollViewCoordinateName)
            .ignoresSafeArea(edges: .top)
            .zIndex(1)
        }
    }
}

#Preview {
    OverScrollView()
}
