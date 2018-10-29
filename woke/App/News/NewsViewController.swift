//
//  NewsViewController.swift
//  woke
//
//  Created by Mike Choi on 10/28/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import UIKit
import GTSheet

class NewsViewController: UIViewController, HalfSheetPresentableProtocol{
    static let identifier = "NewsVC"
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var topVCTransitionStyle: HalfSheetTopVCTransitionStyle {
        return .slide
    }
    
    lazy var topVC: UIViewController = {
        return DismissBarVC.instance(tintColor: .white)
    }()
    
    var managedScrollView: UIScrollView? {
        return scrollView
    }
    
    var dismissMethod: [DismissMethod] {
        return [.tap, .swipe]
    }
    
    var sheetHeight: CGFloat? {
        return UIScreen.main.bounds.height * 0.90
    }
}

extension NewsViewController: HalfSheetAppearanceProtocol, HalfSheetTopVCProviderProtocol {
    var cornerRadius: CGFloat {
        return 8.0
    }
}
