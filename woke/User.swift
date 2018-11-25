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
    private static let key = "USER_SCORE"
    private static let uuid_key = "USER_UUIID"
    
    private static func scoreArray() -> [Int] {
        guard let scores = UserDefaults.standard.array(forKey: User.key) as? [Int] else {
            return []
        }
        
        return scores
    }
    
    static func score() -> Double {
        let scores = User.scoreArray()
        
        if scores.count == 0 {
            return 3.5
        } else {
            return Double(scores.reduce(0, +)) / Double(scores.count)
        }
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
    
    static func update(by score: Int) {
        var scores = User.scoreArray()
        scores.append(score)
        
        UserDefaults.standard.set(scores, forKey: User.key)
    }
    
    static func clearScores() {
        UserDefaults.standard.set([], forKey: User.key)
    }
}

extension User {
    static func uuid() -> String {
        guard let id = UserDefaults.standard.string(forKey: User.uuid_key) else {
            let new_id = UUID().uuidString
            UserDefaults.standard.set(new_id, forKey: User.uuid_key)
            return new_id
        }
        
        return id
    }
}
