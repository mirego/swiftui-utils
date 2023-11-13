import SwiftUI

struct PinTopView: View {
    private let scrollViewCoordinateName = "PinTopView.ScrollView"

    private let navigationBarHeight: CGFloat = 48

    @State private var percentageCompleted: CGFloat = 0
    @State private var headerHeight: CGFloat = 0

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .padding(.trailing, 16)
                    .padding(.horizontal, 16 * (1 - percentageCompleted))
                    .frame(height: navigationBarHeight)
            }
            .zIndex(2)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    header()
                        .pinTop(offset: navigationBarHeight, anchor: .bottom, outterCoordinateName: scrollViewCoordinateName, percentageCompleted: $percentageCompleted)
                        .pinTop(offset: 0, anchor: .top, isReversed: true, outterCoordinateName: scrollViewCoordinateName)
                        .zIndex(2)

                    content()
                        .padding(.horizontal, 16)
                        .zIndex(1)
                }
            }
            .backport.scrollTargetBehaviorResetUnder(offset: headerHeight - navigationBarHeight)
            .coordinateSpace(name: scrollViewCoordinateName)
            .zIndex(1)
        }
    }

    private func header() -> some View {
        VStack(spacing: 0) {
            Text("Title")
                .foregroundColor(.white)
                .pinTop(offset: 16, outterCoordinateName: scrollViewCoordinateName)
        }
        .padding(.vertical, 64)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 16 * (1 - percentageCompleted)).fill(Color.accent))
        .padding(.horizontal, 16 * (1 - percentageCompleted))
        .readLocalFrame {
            headerHeight = $0.height
        }
    }

    @ViewBuilder
    private func content() -> some View {
        ForEach(0..<10) { _ in
            Rectangle()
                .frame(height: 100)
                .foregroundColor(.red)
        }
    }
}

#Preview {
    PinTopView()
}
