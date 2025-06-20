//
//  TimetableView.swift
//  DesignSystem
//
//  Created by 이정원 on 6/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import UIKit
import SwiftUI

public struct TimetableView: UIViewRepresentable {
    private let timetable: Timetable
    
    public init(timetable: Timetable) {
        self.timetable = timetable
    }
    
    public func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        configureContainerView(containerView, context)
        return containerView
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        uiView.subviews.forEach { $0.removeFromSuperview() }
        configureContainerView(uiView, context)
    }
    
    public func makeCoordinator() -> TimetableViewCoordinator {
        TimetableViewCoordinator()
    }
}

private extension TimetableView {
    struct SubViewGroup {
        let scrollViewGroup: ScrollViewGroup
        let contentViewGroup: ContentViewGroup
        let borderGroup: BorderGroup
    }
    
    struct ScrollViewGroup {
        let rowHeader: UIScrollView
        let columnHeader: UIScrollView
        let grid: UIScrollView
    }
    
    struct ContentViewGroup {
        let rowHeader: UIView
        let columnHeader: UIView
        let grid: UIView
    }
    
    struct BorderGroup {
        let rowBorder: UIView
        let columnBorder: UIView
    }
}

private extension TimetableView {
    func configureContainerView(_ containerView: UIView, _ context: Context) {
        let subViewGroup = makeSubViewGroup()
        let scrollViewGroup = subViewGroup.scrollViewGroup
        let contentViewGroup = subViewGroup.contentViewGroup
        let borderGroup = subViewGroup.borderGroup
        
        configureDelegates(context, scrollViewGroup)
        addSubViews(containerView, subViewGroup)
        configureScrollViewLayouts(containerView, scrollViewGroup)
        configureContentViewLayouts(scrollViewGroup, contentViewGroup)
        configureBorderLayouts(scrollViewGroup, borderGroup)
    }

    
    func makeSubViewGroup() -> SubViewGroup {
        return SubViewGroup(
            scrollViewGroup: makeScrollViewGroup(),
            contentViewGroup: makeContentViewGroup(),
            borderGroup: makeBorderGroup()
        )
    }
    
    func makeScrollViewGroup() -> ScrollViewGroup {
        return ScrollViewGroup(
            rowHeader: makeScrollView(),
            columnHeader: makeScrollView(),
            grid: makeScrollView()
        )
    }
    
    func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        return scrollView
    }
    
    func makeContentViewGroup() -> ContentViewGroup {
        let schedules = timetable.schedules
        let start = schedules.start.hour
        let end = schedules.end.hour
        
        let timeHeaderView = TimeHeaderView(start: start, end: end)
        let stageHeaderView = StageHeaderView(stages: timetable.stages)
        let timetableGridView = TimetableGridView(schedules: schedules)
        
        return ContentViewGroup(
            rowHeader: makeContentView(timeHeaderView),
            columnHeader: makeContentView(stageHeaderView),
            grid: makeContentView(timetableGridView)
        )
    }
    
    func makeContentView<Content: View>(_ content: Content) -> UIView {
        let controller = UIHostingController(rootView: content)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.backgroundColor = .clear
        return controller.view
    }
    
    func makeBorderGroup() -> BorderGroup {
        return BorderGroup(
            rowBorder: makeBorderView(),
            columnBorder: makeBorderView()
        )
    }
    
    func makeBorderView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(Color.grey6)
        return view
    }
    
    func configureDelegates(_ context: Context, _ group: ScrollViewGroup) {
        let coordinator = context.coordinator
        group.rowHeader.delegate = coordinator
        group.columnHeader.delegate = coordinator
        group.grid.delegate = coordinator
        coordinator.rowHeaderScrollView = group.rowHeader
        coordinator.columnHeaderScrollView = group.columnHeader
        coordinator.gridScrollView = group.grid
    }
    
    func addSubViews(
        _ containerView: UIView,
        _ subViewGroup: SubViewGroup
    ) {
        let scrollViewGroup = subViewGroup.scrollViewGroup
        let contentViewGroup = subViewGroup.contentViewGroup
        let borderGroup = subViewGroup.borderGroup
        
        scrollViewGroup.rowHeader.addSubview(contentViewGroup.rowHeader)
        scrollViewGroup.columnHeader.addSubview(contentViewGroup.columnHeader)
        scrollViewGroup.grid.addSubview(contentViewGroup.grid)
        
        containerView.addSubview(scrollViewGroup.rowHeader)
        containerView.addSubview(scrollViewGroup.columnHeader)
        containerView.addSubview(scrollViewGroup.grid)
        containerView.addSubview(borderGroup.rowBorder)
        containerView.addSubview(borderGroup.columnBorder)
    }
    
    func configureScrollViewLayouts(
        _ containerView: UIView,
        _ group: ScrollViewGroup
    ) {
        let rowHeader = group.rowHeader
        let columnHeader = group.columnHeader
        let grid = group.grid
        
        NSLayoutConstraint.activate([
            rowHeader.topAnchor.constraint(equalTo: columnHeader.bottomAnchor, constant: -1),
            rowHeader.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            rowHeader.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            rowHeader.widthAnchor.constraint(equalToConstant: 50),
            
            columnHeader.topAnchor.constraint(equalTo: containerView.topAnchor),
            columnHeader.leadingAnchor.constraint(equalTo: rowHeader.trailingAnchor),
            columnHeader.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            columnHeader.heightAnchor.constraint(equalToConstant: 34),
            
            grid.topAnchor.constraint(equalTo: columnHeader.bottomAnchor),
            grid.leadingAnchor.constraint(equalTo: rowHeader.trailingAnchor),
            grid.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            grid.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    func configureContentViewLayouts(
        _ scrollViewGroup: ScrollViewGroup,
        _ contentViewGroup: ContentViewGroup
    ) {
        let rowHeader = scrollViewGroup.rowHeader
        let columnHeader = scrollViewGroup.columnHeader
        let grid = scrollViewGroup.grid
        
        let rowHeaderContent = contentViewGroup.rowHeader
        let columnHeaderContent = contentViewGroup.columnHeader
        let gridContent = contentViewGroup.grid
        
        NSLayoutConstraint.activate([
            gridContent.topAnchor.constraint(equalTo: grid.contentLayoutGuide.topAnchor),
            gridContent.leadingAnchor.constraint(equalTo: grid.contentLayoutGuide.leadingAnchor),
            gridContent.trailingAnchor.constraint(equalTo: grid.contentLayoutGuide.trailingAnchor),
            gridContent.bottomAnchor.constraint(equalTo: grid.contentLayoutGuide.bottomAnchor),
            
            rowHeaderContent.topAnchor.constraint(equalTo: rowHeader.contentLayoutGuide.topAnchor),
            rowHeaderContent.leadingAnchor.constraint(equalTo: rowHeader.contentLayoutGuide.leadingAnchor),
            rowHeaderContent.trailingAnchor.constraint(equalTo: rowHeader.contentLayoutGuide.trailingAnchor),
            rowHeaderContent.bottomAnchor.constraint(equalTo: rowHeader.contentLayoutGuide.bottomAnchor),
            rowHeaderContent.widthAnchor.constraint(equalTo: rowHeader.frameLayoutGuide.widthAnchor),
            
            columnHeaderContent.topAnchor.constraint(equalTo: columnHeader.contentLayoutGuide.topAnchor),
            columnHeaderContent.leadingAnchor.constraint(equalTo: columnHeader.contentLayoutGuide.leadingAnchor),
            columnHeaderContent.trailingAnchor.constraint(equalTo: columnHeader.contentLayoutGuide.trailingAnchor),
            columnHeaderContent.bottomAnchor.constraint(equalTo: columnHeader.contentLayoutGuide.bottomAnchor),
            columnHeaderContent.heightAnchor.constraint(equalTo: columnHeader.frameLayoutGuide.heightAnchor),
        ])
        
        if timetable.schedules.count > 3 {
            let count = CGFloat(timetable.schedules.count)
            let width = 86.0 * count + 8.0 * (count + 1)
            
            NSLayoutConstraint.activate([
                gridContent.widthAnchor.constraint(equalToConstant: width),
                columnHeaderContent.widthAnchor.constraint(equalToConstant: width),
            ])
        } else {
            NSLayoutConstraint.activate([
                gridContent.widthAnchor.constraint(equalTo: grid.frameLayoutGuide.widthAnchor),
                columnHeaderContent.widthAnchor.constraint(equalTo: columnHeader.frameLayoutGuide.widthAnchor),
            ])
        }
    }
    
    func configureBorderLayouts(
        _ scrollViewGroup: ScrollViewGroup,
        _ borderGroup: BorderGroup
    ) {
        let rowBorder = borderGroup.rowBorder
        let columnBorder = borderGroup.columnBorder
        let rowHeader = scrollViewGroup.rowHeader
        let columnHeader = scrollViewGroup.columnHeader
        
        NSLayoutConstraint.activate([
            rowBorder.topAnchor.constraint(equalTo: columnHeader.topAnchor),
            rowBorder.bottomAnchor.constraint(equalTo: rowHeader.bottomAnchor),
            rowBorder.trailingAnchor.constraint(equalTo: columnHeader.leadingAnchor),
            rowBorder.widthAnchor.constraint(equalToConstant: 1),
            
            columnBorder.leadingAnchor.constraint(equalTo: rowHeader.trailingAnchor),
            columnBorder.trailingAnchor.constraint(equalTo: columnHeader.trailingAnchor),
            columnBorder.bottomAnchor.constraint(equalTo: columnHeader.bottomAnchor),
            columnBorder.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
}
