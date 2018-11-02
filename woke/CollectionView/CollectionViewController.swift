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

class CollectionViewController: UIViewController {
    
    static let margin: CGFloat = 10.0
    
    let items = Item.allItems()
    var selected: Item?
    var selectedImage: UIImageView?
    var header: CollectionViewCell?
    var banner: CollectionViewCell?
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
    
    convenience init(with item: Item? = nil) {
        self.init()
        selected = item
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        if let selected = selected {
            let margin = type(of: self).margin
            
            header = CollectionViewCell(frame: .zero)
            guard let header = header else { return }
            header.translatesAutoresizingMaskIntoConstraints = false
            header.item = selected
            header.container.backgroundColor = nil
            header.image.layer.cornerRadius = 6
            header.titleLabel.font = UIFont.systemFont(ofSize: 16)
            header.titleLabel.textColor = .black
            view.addSubview(header)
            
            let boundingRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - (2 * margin), height: CGFloat(MAXFLOAT))
            let height = AVMakeRect(aspectRatio: selected.image.size, insideRect: boundingRect).height
            
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
        } else {
            let margin = type(of: self).margin
            banner = HeaderCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
            guard let banner = banner else { return }
            
            banner.translatesAutoresizingMaskIntoConstraints = false
            banner.item = selected
            banner.container.backgroundColor = nil
            view.addSubview(banner)
            
            let height = CGFloat(80)
            var contentInset = collectionView.contentInset
            contentInset.top += height
            collectionView.contentInset = contentInset
            
            NSLayoutConstraint.activate([
                banner.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: margin),
                banner.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: margin),
                banner.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: -margin),
                banner.heightAnchor.constraint(equalToConstant: height)
                ])
            
            collectionView.collectionViewLayout = homeLayout
            banner.layoutIfNeeded()
            view.layoutIfNeeded()
        }
        
        if let header = header {
            view.insertSubview(collectionView, belowSubview: header)
        } else if let banner = banner {
            view.insertSubview(collectionView, belowSubview: banner)
        }
        
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var hasFocus: Bool {
        return selected != nil
    }
}

extension CollectionViewController: HalfSheetPresentingProtocol {
    func display(item: Item) {
        presentUsingHalfSheet(
            UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: NewsNavigationController.identifier)
        )
    }
}

extension CollectionViewController: UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = selected == nil ? CollectionViewCell.reuseIdentifier: ArticleCollectionViewCell.reuseIdentifier
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header?.layer.transform = CATransform3DMakeTranslation(0, -scrollView.contentOffset.y - scrollView.contentInset.top, 0)
        banner?.layer.transform = CATransform3DMakeTranslation(0, -scrollView.contentOffset.y - scrollView.contentInset.top, 0)
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = items[safe: indexPath.item] else {
            return
        }
        
        if selected == nil {
            if let cell = collectionView.cellForItem(at: indexPath) as? Displayable {
                targetFrame = view.convert(cell.image.frame, from: cell.image)
                selectedImage = cell.image
            }
            app?.router.go(to: .collection(item))
        } else {
            display(item: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if var cell = cell as? Displayable, let item = items[safe: indexPath.item] {
            cell.item = item
        }
    }
}

extension CollectionViewController: CollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView:UICollectionView, heightForItemAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let item = items[indexPath.item]
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
   
        let rect = AVMakeRect(aspectRatio: item.image.size, insideRect: boundingRect)
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
