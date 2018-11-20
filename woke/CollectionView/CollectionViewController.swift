//
//  CollectionViewController.swift
//  woke
//
//  Created by Mike Choi on 10/28/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import UIKit
import AVFoundation
import GTSheet
import Alamofire

protocol Modalable {
    func modallyPresent(view: UIViewController)
}

class CollectionViewController: UIViewController {
    
    static let margin: CGFloat = 10.0
    
    var items: [Item] = []
    var selected: Item?
    var selectedImage: UIImageView?
    var header: CollectionViewCell?
    var targetFrame: CGRect = .zero
    
    var transitionManager: HalfSheetPresentationManager!
    
    lazy var homeLayout: UICollectionViewLayout = {
        var layout = CollectionViewLayout()
        layout.delegate = self
        return layout
    }()
    
    lazy var articleLayout: UICollectionViewLayout = {
        var layout = ArticleViewLayout()
        layout.delegate = self
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: homeLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = nil
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        collectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: ArticleCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    var category: String?
    
    convenience init(with category: String? = nil) {
        self.init()
        self.category = category
        self.selectedImage?.image = UIImage(named: category!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        let parameters: [String: Any] = [
            "topic" : category!,
            "collectionSize" : 10,
            "polarity" : "left",
        ]
    
        Alamofire.request("http://woke-api.loluvw.xyz:3000/getCollection", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if response.result.isSuccess {
                    if let responseArray = response.result.value as? [Any] {
                        for item in responseArray {
                            if let itemDict = item as? Dictionary<String, Any> {
                                let item = Item(itemDict: itemDict)
                                self.items.append(item)
                            }
                        }
                    }
                    else {
                        print("Could not unwrap response.")
                    }
                }
                else {
                    print("Request failed")
                    print(response)
                }
                self.collectionView.reloadData()
        }
        
        let margin = type(of: self).margin
        
        header = CollectionViewCell(frame: .zero)
        guard let header = header else { return }
        header.translatesAutoresizingMaskIntoConstraints = false
        header.item = selected
        header.container.backgroundColor = nil
        header.image.layer.cornerRadius = 6
        header.titleLabel.font = UIFont.systemFont(ofSize: 16)
        header.titleLabel.textColor = .black
        header.image.image = UIImage(named: category!)
        view.addSubview(header)
        
        //let boundingRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - (2 * margin), height: CGFloat(MAXFLOAT))
        //let height = AVMakeRect(aspectRatio: selected.image.size, insideRect: boundingRect).height
        // TODO MASSIVE HACK
        let height: CGFloat = 150.0
        var contentInset = collectionView.contentInset
        contentInset.top += height
        collectionView.contentInset = contentInset
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: margin),
            header.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: margin),
            header.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: -margin),
            header.heightAnchor.constraint(equalToConstant: height)
            ])
        
        collectionView.collectionViewLayout = articleLayout
        header.layoutIfNeeded()
        view.layoutIfNeeded()
        
        view.insertSubview(collectionView, belowSubview: header)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 10),
            collectionView.leftAnchor.constraint(equalTo: view.safeLeftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeRightAnchor)
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    var hasFocus: Bool {
        return selected != nil
    }
}

extension CollectionViewController: HalfSheetPresentingProtocol {
    func display(item: Item) {
        guard let nc = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: NewsNavigationController.identifier) as? NewsNavigationController else {
            return
        }
        
        nc.item = item
        presentUsingHalfSheet(nc)
    }
}

extension CollectionViewController: UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = ArticleCollectionViewCell.reuseIdentifier
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header?.layer.transform = CATransform3DMakeTranslation(0, -scrollView.contentOffset.y - scrollView.contentInset.top, 0)
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = items[safe: indexPath.item] else {
            return
        }
        
        display(item: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard var cell = cell as? Displayable, let item = items[safe: indexPath.item] else {
            return
        }
        cell.item = item
        
        guard let imageURL = item.imageURL, item.image == nil else {
            return
        }
        
        Alamofire.request(imageURL, method: .get).validate().responseData(completionHandler: { (responseData) in
            if responseData.error != nil {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: responseData.data!)
                cell.item?.image = image
                cell.image.image = UIImage(data: responseData.data!)
            }
        })
    }
}

extension CollectionViewController: CollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView:UICollectionView, heightForItemAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let item = items[indexPath.item]
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        if item.image == nil {
            return 100.0
        }
        
        let rect = AVMakeRect(aspectRatio: item.image!.size, insideRect: boundingRect)
        if selected == nil {
            return rect.height
        } else {
            let font = UIFont.systemFont(ofSize: 12)
            return max(item.heightForTitle(font, width: width), ArticleCollectionViewCell.imageSize)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let item = items[indexPath.item]
        let font = UIFont.systemFont(ofSize: 12)
        let height = item.heightForTitle(font, width: width)
        return height + 20
    }
}

extension CollectionViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navigationController = app?.router.navigationController {
            return navigationController.viewControllers.count > 1
        }
        return false
    }
}

extension CollectionViewController: Modalable {
    func modallyPresent(view: UIViewController) {
        present(view, animated: true, completion: nil)
    }
}
