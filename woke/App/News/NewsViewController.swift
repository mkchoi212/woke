//
//  NewsViewController.swift
//  woke
//
//  Created by Mike Choi on 10/28/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import UIKit
import GTSheet

class NewsViewController: UIViewController{
    static let identifier = "NewsVC"
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension NewsViewController: HalfSheetAppearanceProtocol {
    var cornerRadius: CGFloat {
        return 8.0
    }
}

extension NewsViewController: HalfSheetPresentableProtocol {
    
    var managedScrollView: UIScrollView? {
        return scrollView
    }
    
    var dismissMethod: [DismissMethod] {
        return [.tap, .swipe]
    }
    
    var sheetHeight: CGFloat? {
        return nil
    }
}
