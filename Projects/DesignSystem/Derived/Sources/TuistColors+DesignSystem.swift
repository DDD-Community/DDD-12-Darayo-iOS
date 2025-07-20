import UIKit
import SwiftUI

public extension Color {
    private init(_ name: String) {
        self.init(name, bundle: Bundle.module)
    }
    
    static let background1 = Self("Background1")
    static let background2 = Self("Background2")
    static let background3 = Self("Background3")
    static let font = Self("Font")
    static let gradientSplash1 = Self("GradientSplash1")
    static let gradientSplash2 = Self("GradientSplash2")
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

public extension UIColor {
    static func named(_ name: String) -> UIColor {
        UIColor(named: name, in: .module, compatibleWith: nil) ?? UIColor()
    }
    
    static let background1 = UIColor.named("Background1")
    static let background2 = UIColor.named("Background2")
    static let background3 = UIColor.named("Background3")
    static let font = UIColor.named("Font")
    static let gradientSplash1 = UIColor.named("GradientSplash1")
    static let gradientSplash2 = UIColor.named("GradientSplash2")
    static let grey1 = UIColor.named("Grey1")
    static let grey2 = UIColor.named("Grey2")
    static let grey3 = UIColor.named("Grey3")
    static let grey4 = UIColor.named("Grey4")
    static let grey5 = UIColor.named("Grey5")
    static let grey6 = UIColor.named("Grey6")
    static let point1 = UIColor.named("Point1")
    static let point2 = UIColor.named("Point2")
    static let point3 = UIColor.named("Point3")
    static let warning = UIColor.named("Warning")
}
