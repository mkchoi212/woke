//
//  HeaderCollectionViewCell.swift
//  woke
//
//  Created by Mike Choi on 10/28/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: CollectionViewCell {
    
    lazy var logoLabel: UILabel = {
        let title = UILabel(frame: .zero)
        title.text = "woke"
        title.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        return title
    }()
    
    lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel(frame: .zero)
        subtitleLabel.text = DateManager.today()
        subtitleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        subtitleLabel.textColor = .lightGray
        return subtitleLabel
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logoLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _ = container.subviews.map { $0.removeFromSuperview() }
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0),
            stackView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0),
            stackView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 0)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
