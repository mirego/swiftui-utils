import SwiftUI

public extension View {
    func readLocalFrame(_ reader: @escaping (CGRect) -> Void) -> some View {
        background(LocalFrameGetter())
            .onPreferenceChange(LocalFramePreferenceKey.self) {
                reader($0)
            }
    }

    func readGlobalFrame(_ reader: @escaping (CGRect) -> Void) -> some View {
        background(GlobalFrameReader())
            .onPreferenceChange(GlobalFramePreferenceKey.self) {
                reader($0)
            }
    }

    func readNamedFrame(coordinateName: String, _ reader: @escaping (CGRect) -> Void) -> some View {
        background(NamedFrameReader(coordinateName: coordinateName))
            .onPreferenceChange(NamedFramePreferenceKey.self) {
                reader($0)
            }
    }
}

private struct LocalFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { }

    typealias Value = CGRect
}

private struct LocalFrameGetter: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: LocalFramePreferenceKey.self, value: geometry.frame(in: .local))
        }
    }
}

private struct GlobalFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { }
}

private struct GlobalFrameReader: View {
    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: GlobalFramePreferenceKey.self,
                    value: proxy.frame(in: .global)
                )
        }
    }
}

private struct NamedFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { }
}

private struct NamedFrameReader: View {
    let coordinateName: String

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: NamedFramePreferenceKey.self,
                    value: proxy.frame(in: .named(coordinateName))
                )
        }
    }
}
