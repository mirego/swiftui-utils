import SwiftUI

struct RootView: View {
    enum Navigation {
        case scrollToTop
        case scaleOnScroll
        case headerParallaxScale
        case scrollThreshold
        case onVisible
    }

    private struct Section {
        let title: String
        let navigation: Navigation
    }

    private let sections = [
        Section(title: "Scroll To Top", navigation: .scrollToTop),
        Section(title: "Scale On Scroll", navigation: .scaleOnScroll),
        Section(title: "Header Parallax Scale", navigation: .headerParallaxScale),
        Section(title: "Scroll Threshold", navigation: .scrollThreshold),
        Section(title: "On Visible", navigation: .onVisible)
    ]

    @State var navigation: Navigation?


    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                Text("SwiftUI-Utils")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.bottom, 16)

                ForEach(sections.indices, id: \.self) { index in
                    Text(sections[index].title)
                        .tappable {
                            navigation = sections[index].navigation
                        }
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
        .sheet(isPresented: $navigation.isActive(.scrollThreshold)) {
            ScrollThresholdView()
        }
        .fullScreenCover(isPresented: $navigation.isActive(.headerParallaxScale)) {
            HeaderParallaxScaleView()
        }
        .sheet(isPresented: $navigation.isActive(.onVisible)) {
            OnVisibleView()
        }
    }
}

#Preview {
    RootView()
}
