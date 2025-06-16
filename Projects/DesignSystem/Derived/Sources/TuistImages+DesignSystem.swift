import SwiftUI

public extension Image {
    private init(_ name: String) {
        self.init(name, bundle: Bundle.module)
    }
    
    static let iconCalendar = Self("icon_calendar")
    static let iconList = Self("icon_list")
    static let iconPlus = Self("icon_plus")
}
