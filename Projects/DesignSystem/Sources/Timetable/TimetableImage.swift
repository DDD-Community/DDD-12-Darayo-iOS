//
//  TimetableImage.swift
//  DesignSystem
//
//  Created by 이정원 on 7/12/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

extension UIImage {
    @MainActor
    static func timetable(_ timetable: Timetable) -> UIImage {
        let extendedTimetableView = ExtendedTimetableView(timetable: timetable)
        let controller = UIHostingController(rootView: extendedTimetableView.ignoresSafeArea())
        controller.view.bounds.size = controller.view.intrinsicContentSize
        let renderer = UIGraphicsImageRenderer(size: controller.view.bounds.size)
        
        return renderer.image { _ in
            controller.view.drawHierarchy(
                in: controller.view.bounds,
                afterScreenUpdates: true
            )
        }
    }
}

extension Timetable: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .png) {
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("Timetable.png")
            try? await UIImage.timetable($0).pngData()?.write(to: url)
            return .init(url)
        }
    }
}
