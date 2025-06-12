import SwiftUI

public extension Image {
    private init(_ name: String) {
        self.init(name, bundle: Bundle.module)
    }
    
}
