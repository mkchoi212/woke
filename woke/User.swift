//
//  User.swift
//  woke
//
//  Created by Mike Choi on 11/4/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//
// User score ranges from -2.0 to 3.0 [-2, -1, 0, 1, 2, 3]
// with default score being 0 (moderate)
//

import Foundation

struct User {
    static let shared = User()
    static let key = "USER_SCORE"
    
    static let score: Double = {
        return UserDefaults.standard.double(forKey: User.key)
    }()
    
    static func save(score: Double) {
        UserDefaults.standard.set(score, forKey: User.key)
    }
    
    static func stringRepresentation() -> String {
        switch User.score {
        case -2.0 ..< -1.0:
            return "left"
        case -1.0 ..< 0.0:
            return "leftCenter"
        case 0.0 ..< 1.0:
            return "center"
        case 1.0 ..< 2.0:
            return "rightCenter"
        case 2.0 ... 3.0:
            return "right"
        default:
            fatalError("Invalid user score range")
        }
    }
    
    static func decimalRepresentation(of description: String) -> Double {
        switch description {
        case "left":
            return -2.0
        case  "leftCenter":
            return -1.0
        case "center":
            return 0.0
        case "rightCenter":
            return 1.0
        case "right":
            return 2.0
        default:
            fatalError("Invalid user score range")
        }
    }
    
    static func update(by weight: Double) {
        let oldScore = User.score
        let scalingFactor = 0.1
        
        let bias = weight * scalingFactor
        
        var newScore = bias + oldScore
        newScore = max(newScore, -2.0)
        newScore = min(newScore, 3.0)
        
        User.save(score: newScore)
    }
}
