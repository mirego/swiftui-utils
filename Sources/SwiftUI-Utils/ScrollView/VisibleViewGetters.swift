import SwiftUI

extension View {
    public func visibleViewIdentifier(_ itemId: String) -> some View {
        anchorPreference(
            key: LoadedItemsPreferenceKey.self,
            value: .bounds,
            transform: { anchor in
                [.init(itemId: itemId, bounds: anchor)]
            }
        )
    }
}

extension View {
    public func onVisibleViewIdentifiersChange(_ items: @escaping ([String]) -> Void) -> some View {
        backgroundPreferenceValue(LoadedItemsPreferenceKey.self) { loadedItems in
            ReadVisibleItemView(loadedItems: loadedItems)
        }
        .onPreferenceChange(VisibleItemsPreferenceKey.self) {
            items($0)
        }
    }

    public func onVisibleViewIdentifiersChange(_ items: Binding<[String]>) -> some View {
        onVisibleViewIdentifiersChange {
            items.wrappedValue = $0
        }
    }
}

private struct LoadedItemsPreferenceKeyPayload {
    let itemId: String
    let bounds: Anchor<CGRect>
}

private struct LoadedItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [LoadedItemsPreferenceKeyPayload] = []

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

private struct VisibleItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [String] = []

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

private struct ReadVisibleItemView: View {
    let loadedItems: [LoadedItemsPreferenceKeyPayload]

    var body: some View {
        GeometryReader { proxy in
            Color.clear.preference(
                key: VisibleItemsPreferenceKey.self,
                value: loadedItems.visibleItemIds(in: proxy)
            )
        }
    }
}

extension Collection<LoadedItemsPreferenceKeyPayload> {
    fileprivate func visibleItemIds(in proxy: GeometryProxy) -> [String] {
        let localFrame = proxy.frame(in: .local)
        return compactMap { item in
            localFrame.intersects(proxy[item.bounds]) ? item.itemId : nil
        }
    }
}
