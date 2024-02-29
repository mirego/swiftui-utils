import SwiftUI

struct OnVisibleView: View {
    private let scrollViewCoordinateName = "TEST_SCROLL"

    @State private var scrollViewFrame = CGRect()

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    ForEach(1..<20, id: \.self) { number in
                        ItemView(
                            number: number,
                            scrollViewFrame: $scrollViewFrame,
                            parentSafeAreaInsets: proxy.safeAreaInsets,
                            coordinateName: scrollViewCoordinateName
                        )
                    }
                }
                .padding()
            }
            .coordinateSpace(name: scrollViewCoordinateName)
            .readLocalFrame {
                scrollViewFrame = $0
            }
        }
    }
}

struct ItemView: View {
    let number: Int
    @Binding var scrollViewFrame: CGRect
    let parentSafeAreaInsets: EdgeInsets
    let coordinateName: String

    @State private var isVisible = false

    var body: some View {
        Text("\(number)")
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.red)
            )
            .onVisible(
                parentFrame: $scrollViewFrame,
                parentSafeAreaInsets: parentSafeAreaInsets,
                coordinateName: coordinateName
            ) { isVisible in
                if isVisible {
                    print("On visible \(number)")
                } else {
                    print("On not visible \(number)")
                }
            }
            .onVisible(
                parentFrame: $scrollViewFrame,
                parentSafeAreaInsets: parentSafeAreaInsets,
                coordinateName: coordinateName,
                onVisible: $isVisible
            )
            .onChange(of: isVisible) { isVisible in
                if isVisible {
                    print("\(number) visible at \(Date())")
                } else {
                    print("\(number) not visible at \(Date())")
                }
            }
    }
}

#Preview {
    OnVisibleView()
}
