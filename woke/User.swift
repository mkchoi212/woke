//
//  User.swift
//  woke
//
//  Created by Mike Choi on 11/4/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//
// User score ranges from 1.0 to 6.0 [1, 2, 3, 4, 5, 6]
// with default score being 3.5 (moderate)
//

import Foundation

struct User {
    static let key = "USER_SCORE"
    
    static func score() -> Double {
        let score = UserDefaults.standard.double(forKey: User.key)
        return score == 0.0 ? 3.5 : score
    }
    
    static func save(score: Double) {
        UserDefaults.standard.set(score, forKey: User.key)
    }
    
    static func stringRepresentation() -> String {
        switch User.score() {
        case 1.0 ..< 2.0:
            return "left"
        case 2.0 ..< 3.0:
            return "leftCenter"
        case 3.0 ..< 4.0:
            return "center"
        case 4.0 ..< 5.0:
            return "rightCenter"
        case 5.0 ... 6.0:
            return "right"
        default:
            fatalError("Invalid user score range")
        }
    }
    
    static func decimalRepresentation(of description: String) -> Double {
        switch description {
        case "left":
            return 1.0
        case  "leftCenter":
            return 2.0
        case "center":
            return 3.0
        case "rightCenter":
            return 4.0
        case "right":
            return 5.0
        default:
            fatalError("Invalid user score range")
        }
    }
    
    static func update(by weight: Double) -> Double {
        let oldScore = User.score()
        let scalingFactor = 0.1
        
        let bias = (weight - oldScore) * scalingFactor
        var newScore = oldScore + bias
        
        newScore = max(newScore, 1.0)
        newScore = min(newScore, 6.0)
        
        User.save(score: newScore)
        return newScore
    }
}
