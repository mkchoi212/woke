//
//  User.swift
//  woke
//
//  Created by Mike Choi on 11/4/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import Foundation

struct User {
    static let shared = User()
    let key = "USER_SCORE"
    
    static let score: Int = {
        guard let score = UserDefaults.standard.value(forKey: User.shared.key) as? Int else {
            User.save(score: 0)
            return 0
        }
        
       return score
    }()
    
    static func save(score: Int) {
        UserDefaults.standard.set(0, forKey: User.shared.key)
    }
}
