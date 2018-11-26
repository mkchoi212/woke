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
import LoadingPlaceholderView

enum Tag: Int {
    case like, dislike
}

class NewsViewController: UIViewController {
    static let identifier = "NewsVC"
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    lazy var idx: Int = {
        let nc = (self.navigationController as! NewsNavigationController)
        return nc.selectedIdx!
    }()
    
    var item: Item? {
        get {
            if idx >= items.count {
                return nil
            } else {
                return items[idx]
            }
        }
    }
    
    lazy var items: [Item] = {
        let nc = (self.navigationController as? NewsNavigationController)
        return nc!.items!
    }()
    
    lazy var category: String = {
        let nc = (self.navigationController as! NewsNavigationController)
        return nc.category!
    }()
    
    lazy var loadingPlaceholderView: LoadingPlaceholderView = {
        var placeholder = LoadingPlaceholderView()
        placeholder.gradientColor = .white
        placeholder.backgroundColor = .white
        return placeholder
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
        let labelText = "NEXT IN\n\(category.uppercased())"
        label.attributedText = labelText.attributedString(nonBoldRange: NSRange(location: 8, length: category.count), fontSize: 12)
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
    
    var shouldRefresh: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItems = [likeButton, dislikeButton, shareButton]
        navigationItem.rightBarButtonItem = nextButton

        
        setupNewsView()
    }
    
    func setupNewsView() {
        guard let cur = item else {
            dismiss(animated: true, completion: nil)
            return
        }
        titleLabel.text = cur.title
        authorLabel.text = "\(cur.author), \(cur.sourceTitle)"
        dateLabel.text = cur.dateModified
        mainTextLabel.text = cur.body
        
        let history = User.historyDictionary()
        guard let userOpinion = history[cur.articleId!] else {
            _ = [likeButton, dislikeButton].map{ ($0.customView as? FaveButton)?.setSelected(selected: false, animated: false) }
            return
        }
        
        if userOpinion {
            (likeButton.customView as? FaveButton)?.setSelected(selected: true, animated: false)
        } else {
            (dislikeButton.customView as? FaveButton)?.setSelected(selected: true, animated: false)
        }
    }
    
    @objc func showNextArticle() {
        loadingPlaceholderView.cover(view, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.idx += 1
            self?.setupNewsView()
            self?.loadingPlaceholderView.uncover(animated: true)
        }
    }
    
    @objc func shareArticle(sender:UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let textToShare = "Check out this news article!"
        
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
        if !selected {
            return
        }
        
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "RefreshFeed"),object: nil))
        
        let tag = faveButton.tag
        let parameters: [String: Any] = [
            "uuid" : User.uuid(),
            "articleId": item!.articleId!
        ]
        
        
        if tag == Tag.like.rawValue {
            User.save(article: item!.articleId!, status: true)
            Alamofire.request("http://woke-api.loluvw.xyz:3000/loveArticle", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    if !response.result.isSuccess {
                        return
                    }
                    guard let responseDict = response.result.value as? [String:Any] else {
                        return
                    }
                    let newEstimatedBias = responseDict["estimatedBias"] as! Double
                    User.set(score: newEstimatedBias)
                    print(newEstimatedBias)
            }
        } else if tag == Tag.dislike.rawValue {
            User.save(article: item!.articleId!, status: false)
            Alamofire.request("http://woke-api.loluvw.xyz:3000/hateArticle", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    if !response.result.isSuccess {
                        return
                    }
                    
                    guard let responseDict = response.result.value as? [String:Any] else {
                        return
                    }
                    let newEstimatedBias = responseDict["estimatedBias"] as! Double
                    User.set(score: newEstimatedBias)
                    print(newEstimatedBias)
            }
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
