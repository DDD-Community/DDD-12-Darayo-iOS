//
//  TimetableViewCoordinator.swift
//  DesignSystem
//
//  Created by 이정원 on 6/19/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import UIKit

public final class TimetableViewCoordinator: NSObject, UIScrollViewDelegate {
    var rowHeaderScrollView: UIScrollView?
    var columnHeaderScrollView: UIScrollView?
    var gridScrollView: UIScrollView?
    private var isScrollHandling = false
  
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isScrollHandling { return }
        isScrollHandling = true
        defer { isScrollHandling = false }

        let offset = scrollView.contentOffset
        let rowHeaderOffset = CGPoint(x: 0, y: offset.y)
        let columnHeaderOffset = CGPoint(x: offset.x, y: 0)
        let currentGridX = gridScrollView?.contentOffset.x ?? 0.0
        let currentGridY = gridScrollView?.contentOffset.y ?? 0.0

        if scrollView == gridScrollView {
            rowHeaderScrollView?.setContentOffset(rowHeaderOffset, animated: false)
            columnHeaderScrollView?.setContentOffset(columnHeaderOffset, animated: false)
        } else if scrollView == rowHeaderScrollView {
            let offset = CGPoint(x: currentGridX, y: offset.y)
            gridScrollView?.setContentOffset(offset, animated: false)
        } else if scrollView == columnHeaderScrollView {
            let offset = CGPoint(x: offset.x, y: currentGridY)
            gridScrollView?.setContentOffset(offset, animated: false)
        }
    }
}
