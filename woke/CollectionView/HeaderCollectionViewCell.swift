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
        title.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return title
    }()
    
    lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel(frame: .zero)
        subtitleLabel.text = DateManager.today()
        subtitleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        subtitleLabel.textColor = .lightGray
        return subtitleLabel
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 20),
            button.widthAnchor.constraint(equalToConstant: 20)
            ])
        
        return button
    }()
    
    lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [subtitleLabel, settingsButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logoLabel, bottomStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8.0
        return stackView
    }()
    
    var settingsExpanded: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.25) {
                if self.settingsExpanded {
                    self.settingsButton.transform = CGAffineTransform.identity
                } else {
                    self.settingsButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2.0)
                }
            }
        }
    }
    
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
    
    @objc func settingsPressed() {
        settingsExpanded = !settingsExpanded
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
