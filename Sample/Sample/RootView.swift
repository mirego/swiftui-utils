import SwiftUI

struct RootView: View {
    enum Navigation {
        case scrollToTop
        case scaleOnScroll
        case headerParallaxScale
    }

    @State var navigation: Navigation?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                Text("SwiftUI-Utils")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.bottom, 16)

                Text("Scroll To Top")
                    .tappable {
                        navigation = .scrollToTop
                    }

                Text("Scale On Scroll")
                    .tappable {
                        navigation = .scaleOnScroll
                    }

                Text("Header Parallax Scale")
                    .tappable {
                        navigation = .headerParallaxScale
                    }
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity)
        .fullScreenCover(isPresented: $navigation.isActive(.scrollToTop)) {
            PinTopView()
        }
        .sheet(isPresented: $navigation.isActive(.scaleOnScroll)) {
            ScaleOnScrollView()
        }
        .fullScreenCover(isPresented: $navigation.isActive(.headerParallaxScale)) {
            HeaderParallaxScaleView()
        }
    }
}

#Preview {
    RootView()
}
