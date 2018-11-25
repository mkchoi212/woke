//
//  NewsViewController.swift
//  woke
//
//  Created by Mike Choi on 10/28/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import UIKit
import GTSheet
import Alamofire

enum Tag: Int {
    case like, dislike
}

class NewsViewController: UIViewController{
    static let identifier = "NewsVC"
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    lazy var item: Item? = {
        let nc = (self.navigationController as? NewsNavigationController)
        guard let parentItem = nc!.item else {
            return nil
        }
        return parentItem
    }()

    lazy var likeButton: UIBarButtonItem = {
        let likeButton = FaveButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35),
                                    faveIconNormal: UIImage(named: "thumbs-up"))
        likeButton.tag = Tag.like.rawValue
        
        likeButton.delegate = self
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 35),
            likeButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        likeButton.selectedColor = #colorLiteral(red: 0.007762347814, green: 0.4766914248, blue: 0.9985215068, alpha: 1)
        return UIBarButtonItem(customView: likeButton)
    }()
    
    lazy var dislikeButton: UIBarButtonItem = {
        let dislikeButton = FaveButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35),
                                    faveIconNormal: UIImage(named: "thumbs-down"))
        dislikeButton.tag = Tag.dislike.rawValue
        
        dislikeButton.delegate = self
        NSLayoutConstraint.activate([
            dislikeButton.widthAnchor.constraint(equalToConstant: 35),
            dislikeButton.heightAnchor.constraint(equalToConstant: 35)
            ])
        
        dislikeButton.selectedColor = #colorLiteral(red: 0.9995418191, green: 0.2292047143, blue: 0.1865143478, alpha: 1)
        return UIBarButtonItem(customView: dislikeButton)
    }()
    
    lazy var shareButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action , target: self, action: #selector(shareArticle))
    }()
    
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
        
        navigationItem.leftBarButtonItems = [likeButton, dislikeButton, shareButton]
        navigationItem.rightBarButtonItem = nextButton
        
        self.titleLabel.text = item?.title
        self.authorLabel.text = item?.author
        self.dateLabel.text = item?.dateModified
        self.mainTextLabel.text = item?.body
        
    }
    
    @objc func showNextArticle() {
        
    }
    
    @objc func shareArticle(sender:UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let textToShare = "Check out this news article!"
        if item == nil {
            return
        }
        
        let objectsToShare = [textToShare, item!.url] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        //Excluded Activities
        activityVC.excludedActivityTypes = [UIActivityType.saveToCameraRoll]
        
        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true, completion: nil)
    }
}

extension NewsViewController: FaveButtonDelegate {
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        // TODO
        if !selected {
            return
        }
        
        let tag = faveButton.tag
        if tag == Tag.like.rawValue {
            User.update(by: 1)
        } else if tag == Tag.dislike.rawValue {
            User.update(by: 1)
        }
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
