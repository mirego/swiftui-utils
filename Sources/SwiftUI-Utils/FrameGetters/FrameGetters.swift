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
    
    func read(
        _ keyPath: KeyPath<CGRect, CGFloat>,
        in coordinateSpace: CoordinateSpace = .local,
        _ reader: @escaping (CGFloat) -> Void
    ) -> some View {
        background(SingleDimensionGetter(coordinateSpace: coordinateSpace, keyPath: keyPath))
            .onPreferenceChange(SingleDimensionPreferenceKey.self) {
                reader($0)
            }
    }
    
    func read(
        _ keyPath: KeyPath<CGRect, CGFloat>,
        in coordinateSpace: CoordinateSpace = .local,
        _ dimension: Binding<CGFloat>
    ) -> some View {
        background(SingleDimensionGetter(coordinateSpace: coordinateSpace, keyPath: keyPath))
            .onPreferenceChange(SingleDimensionPreferenceKey.self) {
                dimension.wrappedValue = $0
            }
    }
    
    func read(
        _ keyPath: KeyPath<CGRect, CGFloat>,
        in coordinateSpace: CoordinateSpace = .local,
        _ dimension: Binding<CGFloat?>
    ) -> some View {
        background(SingleDimensionGetter(coordinateSpace: coordinateSpace, keyPath: keyPath))
            .onPreferenceChange(SingleDimensionPreferenceKey.self) {
                dimension.wrappedValue = $0
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

private struct SingleDimensionPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { }
}

private struct SingleDimensionGetter: View {
    let coordinateSpace: CoordinateSpace
    let keyPath: KeyPath<CGRect, CGFloat>

    var body: some View {
        GeometryReader { geometry in
            Color.clear.preference(
                key: SingleDimensionPreferenceKey.self,
                value: geometry.frame(in: coordinateSpace)[keyPath: keyPath]
            )
        }
    }
}
