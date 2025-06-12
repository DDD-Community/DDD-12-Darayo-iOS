import SwiftUI

public extension Color {
    private init(_ name: String) {
        self.init(name, bundle: Bundle.module)
    }
    
    static let background1 = Self("Background1")
    static let background2 = Self("Background2")
    static let background3 = Self("Background3")
    static let font = Self("Font")
    static let grey1 = Self("Grey1")
    static let grey2 = Self("Grey2")
    static let grey3 = Self("Grey3")
    static let grey4 = Self("Grey4")
    static let grey5 = Self("Grey5")
    static let grey6 = Self("Grey6")
    static let point1 = Self("Point1")
    static let point2 = Self("Point2")
    static let point3 = Self("Point3")
    static let warning = Self("Warning")
}
