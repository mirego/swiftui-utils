import SwiftUI

public extension View {
    func readSize(_ size: Binding<CGSize>) -> some View {
        background(FrameGetter(coordinateSpace: .local))
            .onPreferenceChange(FramePreferenceKey.self) {
                size.wrappedValue = $0.size
            }
    }

    func readLocalFrame(_ frame: Binding<CGRect>) -> some View {
        background(FrameGetter(coordinateSpace: .local))
            .onPreferenceChange(FramePreferenceKey.self) {
                frame.wrappedValue = $0
            }
    }

    func readLocalFrame(_ reader: @escaping (CGRect) -> Void) -> some View {
        background(FrameGetter(coordinateSpace: .local))
            .onPreferenceChange(FramePreferenceKey.self) {
                reader($0)
            }
    }

    func readGlobalFrame(_ frame: Binding<CGRect>) -> some View {
        background(FrameGetter(coordinateSpace: .global))
            .onPreferenceChange(FramePreferenceKey.self) {
                frame.wrappedValue = $0
            }
    }

    func readGlobalFrame(_ reader: @escaping (CGRect) -> Void) -> some View {
        background(FrameGetter(coordinateSpace: .global))
            .onPreferenceChange(FramePreferenceKey.self) {
                reader($0)
            }
    }

    func readNamedFrame(coordinateName: String, _ reader: @escaping (CGRect) -> Void) -> some View {
        background(FrameGetter(coordinateSpace: .named(coordinateName)))
            .onPreferenceChange(FramePreferenceKey.self) {
                reader($0)
            }
    }

    func readNamedFrame(coordinateName: String, _ frame: Binding<CGRect>) -> some View {
        background(FrameGetter(coordinateSpace: .named(coordinateName)))
            .onPreferenceChange(FramePreferenceKey.self) {
                frame.wrappedValue = $0
            }
    }
}

private struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { }

    typealias Value = CGRect
}

private struct FrameGetter: View {
    let coordinateSpace: CoordinateSpace

    var body: some View {
        GeometryReader { geometry in
            Color.clear.preference(
                key: FramePreferenceKey.self,
                value: geometry.frame(in: coordinateSpace)
            )
        }
    }
}
