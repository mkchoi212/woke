//
//  HomeCollectionViewController.swift
//  woke
//
//  Created by Mike Choi on 11/20/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

struct Category {
    let name: String
    let description: String
    
    static let all = [
        Category(name: "world", description: "World"),
        Category(name: "domestic", description: "Domestic"),
        Category(name: "trump", description: "Trump"),
        Category(name: "technology", description: "Technology"),
        Category(name: "entertainment", description: "Entertainment")
    ]
}

class HomeCollectionViewController: UIViewController, Animatable {
    static let margin: CGFloat = 10.0
    
    var header: CollectionViewCell?
    var targetFrame: CGRect = .zero
    var selectedImage: UIImageView?
    
    lazy var homeLayout: UICollectionViewLayout = {
        var layout = CollectionViewLayout()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        let margin = type(of: self).margin
        header = HeaderCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
        guard let banner = header else { return }
        
        (banner as? HeaderCollectionViewCell)?.delegate = self
        banner.translatesAutoresizingMaskIntoConstraints = false
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
        
        banner.layoutIfNeeded()
        view.layoutIfNeeded()
        
        view.insertSubview(collectionView, belowSubview: banner)
        
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
        return false
    }
}

extension HomeCollectionViewController: UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.all.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = CollectionViewCell.reuseIdentifier
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = Category.all[indexPath.row]
        cell.image.image = UIImage(named: category.name)
        cell.titleLabel.text = category.description
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header?.layer.transform = CATransform3DMakeTranslation(0, -scrollView.contentOffset.y - scrollView.contentInset.top, 0)
    }
}

extension HomeCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let category = Category.all[safe: indexPath.item] else {
            return
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? Displayable else {
            return
        }
        
        targetFrame = view.convert(cell.image.frame, from: cell.image)
        selectedImage?.image = UIImage(named: category.name)
        app?.router.go(to: .collection(category.name))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CollectionViewCell, let category = Category.all[safe: indexPath.item] else {
            return
        }
        
        cell.image.image = UIImage(named: category.name)
        cell.titleLabel.text = category.description
    }
}

extension HomeCollectionViewController: CollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView:UICollectionView, heightForItemAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return 150
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return 60
    }
}

extension HomeCollectionViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navigationController = app?.router.navigationController {
            return navigationController.viewControllers.count > 1
        }
        return false
    }
}

extension HomeCollectionViewController: Modalable {
    func modallyPresent(view: UIViewController) {
        present(view, animated: true, completion: nil)
    }
}
