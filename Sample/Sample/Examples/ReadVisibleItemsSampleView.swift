import SwiftUI
import SwiftUIUtils

struct ReadVisibleItemsSampleView: View {
    private let sampleItems = (0 ..< 100).map { "\($0)" }

    @State private var visibleItems: [String] = []

    var body: some View {
        VStack {
            Text("Visible items:")
            Text("\(visibleItems.joined(separator: ", "))")

            ScrollView {
                LazyVStack {
                    ForEach(sampleItems, id: \.self) { item in
                        Text(item)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.mint, in: RoundedRectangle(cornerRadius: 8))
                            .visibleViewIdentifier(item)
                    }
                }
                .padding()
            }
            .onVisibleViewIdentifiersChange($visibleItems)
        }
    }
}

#Preview {
    ReadVisibleItemsSampleView()
}
