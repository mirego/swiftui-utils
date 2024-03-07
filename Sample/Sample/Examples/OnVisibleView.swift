import SwiftUI

struct OnVisibleView: View {
    private let scrollViewCoordinateName = "TEST_SCROLL"

    @State private var scrollViewFrame = CGRect()

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    ForEach(1..<20, id: \.self) { number in
                        ItemView(number: number)
                    }
                }
                .padding()
            }
            .coordinateSpace(name: scrollViewCoordinateName)
            .readLocalFrame {
                scrollViewFrame = $0
            }
            .environment(
                \.scrollViewContextData,
                 ScrollViewContextData(
                    frame: $scrollViewFrame,
                    safeAreaInsets: proxy.safeAreaInsets,
                    coordinateSpaceName: scrollViewCoordinateName
                 )
            )
        }
    }
}

struct ItemView: View {
    let number: Int

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
            .onVisible() { isVisible in
                if isVisible {
                    print("On visible \(number)")
                } else {
                    print("On not visible \(number)")
                }
            }
            .onVisible(onVisible: $isVisible)
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
