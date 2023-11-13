import SwiftUI

public extension Binding where Value: Equatable {
    func isActive<T>(_ choice: Value) -> Binding<Bool> where T? == Value {
        return Binding<Bool> {
            self.wrappedValue == choice
        } set: { newValue in
            if !newValue {
                self.wrappedValue = nil
            }
        }
    }
}
