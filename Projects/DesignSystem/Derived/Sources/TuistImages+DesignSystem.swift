import SwiftUI

public extension Image {
    private init(_ name: String) {
        self.init(name, bundle: Bundle.module)
    }
    
    static let iconBell = Self("icon_bell")
    static let iconCalendar = Self("icon_calendar")
    static let iconCalendarMode = Self("icon_calendar_mode")
    static let iconChecked = Self("icon_checked")
    static let iconGridMode = Self("icon_grid_mode")
    static let iconHeart = Self("icon_heart")
    static let iconHeartFill = Self("icon_heart_fill")
    static let iconHome = Self("icon_home")
    static let iconList = Self("icon_list")
    static let iconMyPage = Self("icon_my_page")
    static let iconPicture = Self("icon_picture")
    static let iconPlus = Self("icon_plus")
    static let iconTimetable = Self("icon_timetable")
    static let iconUnchecked = Self("icon_unchecked")
    static let sampleFestival = Self("sample_festival")
}
