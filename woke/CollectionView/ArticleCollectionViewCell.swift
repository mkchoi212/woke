//
//  ArticleCollectionViewCell.swift
//  woke
//
//  Created by Mike Choi on 11/2/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell, Displayable {
    
    static let reuseIdentifier = "ArticleCollectionViewCell"
    static let imageSize = UIScreen.main.bounds.width * 0.3
    let titleFont = UIFont.systemFont(ofSize: 12)
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: ArticleCollectionViewCell.imageSize),
            image.widthAnchor.constraint(equalToConstant: ArticleCollectionViewCell.imageSize)
            ])
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.textColor = .darkGray
        titleLabel.font = titleFont
        return titleLabel
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [image, titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12.0
        stackView.alignment = .center
        return stackView
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
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
            ])
    }
}

