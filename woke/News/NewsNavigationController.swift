//
//  NewsNavigationController.swift
//  woke
//
//  Created by Mike Choi on 10/28/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import UIKit
import GTSheet

class NewsNavigationController: UINavigationController, HalfSheetTopVCProviderProtocol {
    static let identifier = "NewsNC"
    var items: [Item]?
    var selectedIdx: Int?
    var category: String?
    
    var topVCTransitionStyle: HalfSheetTopVCTransitionStyle {
        return .slide
    }
    
    lazy var topVC: UIViewController = {
        return DismissBarVC.instance(tintColor: .white)
    }()
}

extension NewsNavigationController: HalfSheetPresentableProtocol {
    var managedScrollView: UIScrollView? {
        return (viewControllers.last as? HalfSheetPresentableProtocol)?.managedScrollView
    }
    
    var dismissMethod: [DismissMethod] {
        return [.tap, .swipe]
    }
    
    var sheetHeight: CGFloat? {
        return UIScreen.main.bounds.height * 0.88
    }
}
