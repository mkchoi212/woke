//
//  CollectionViewCell.swift
//  woke
//
//  Created by Mike Choi on 10/28/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import UIKit
import Transition

class CollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CollectionViewCell"
    
    lazy var container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 6
        container.clipsToBounds = true
        return container
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        return titleLabel
    }()
    
    var item: Item? = nil {
        didSet {
            guard let item = item else { return }
            image.image = item.image
            titleLabel.text = item.title
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.rightAnchor.constraint(equalTo: contentView.rightAnchor)
            ])
        
        container.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
            image.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0),
            image.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            image.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 0)
            ])
        
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 5),
            titleLabel.leftAnchor.constraint(equalTo: container.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: container.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0)
            ])
    }
}
