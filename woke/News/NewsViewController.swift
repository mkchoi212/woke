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
    
    lazy var likeButton: UIBarButtonItem = {
        let likeButton = FaveButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35),
                                    faveIconNormal: UIImage(named: "heart"))
        likeButton.delegate = self
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 35),
            likeButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        return UIBarButtonItem(customView: likeButton)
    }()
    
    lazy var shareButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action , target: self, action: #selector(shareArticle))
    }()
    
    // TODO REPLACE MAGICAL FRAME NUMBERS
    lazy var nextButton: UIBarButtonItem = {
        let button =  UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "next_arrow"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 25)
        button.addTarget(self, action: #selector(showNextArticle), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: -110, y: -12, width: 100, height: 40))
        let categoryName = "CATEGORY"
        let labelText = "NEXT IN\n\(categoryName)"
        label.attributedText = labelText.attributedString(nonBoldRange: NSRange(location: 8, length: categoryName.count), fontSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.textColor = .black
        button.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 100),
            label.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 18),
            button.heightAnchor.constraint(equalToConstant: 18),
        ])
        
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItems = [likeButton, shareButton]
        navigationItem.rightBarButtonItem = nextButton
    }
    
    @objc func showNextArticle() {
        
    }
    
    @objc func shareArticle(sender:UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let textToShare = "Check out this news article!"
        
        if let articleLink = URL(string: "http://cnn.com") {
            let objectsToShare = [textToShare, articleLink] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivityType.saveToCameraRoll]
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}

extension NewsViewController: FaveButtonDelegate {
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        print(selected)
    }
}

extension NewsViewController: HalfSheetAppearanceProtocol, HalfSheetPresentableProtocol {
    
    var cornerRadius: CGFloat {
        return 8.0
    }
    
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
