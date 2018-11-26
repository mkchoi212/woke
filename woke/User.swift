//
//  User.swift
//  woke
//
//  Created by Mike Choi on 11/4/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//
// User score ranges from 0.0 to 4.0 [0, 1, 2, 3, 4]
// with default score being 2.0 (moderate)
//

import Foundation

struct User {
    private static let key = "USER_SCORE"
    private static let written = "SCORE_WRITTEN"
    private static let uuid_key = "USER_UUIID"
    
    static func score() -> Double {
        let defaults = UserDefaults.standard
        
        let isWritten = defaults.bool(forKey: User.written)
        return isWritten ? defaults.double(forKey: User.key) : 2.0
    }
    
    static func stringRepresentation() -> String {
        switch User.score() {
        case 0.0 ..< 1.0:
            return "left"
        case 1.0 ..< 2.0:
            return "leftCenter"
        case 2.0 ..< 3.0:
            return "center"
        case 3.0 ..< 4.0:
            return "rightCenter"
        case 4.0 ... 5.0:
            return "right"
        default:
            fatalError("Invalid user score range")
        }
    }
    
    static func decimalRepresentation(of description: String) -> Double {
        switch description {
        case "left":
            return 0.0
        case  "left-center":
            return 1.0
        case "center":
            return 2.0
        case "right-center":
            return 3.0
        case "right":
            return 4.0
        default:
            fatalError("Invalid user score range")
        }
    }
    
    static func set(score: Double) {
        UserDefaults.standard.set(true, forKey: User.written)
        UserDefaults.standard.set(score, forKey: User.key)
    }
    
    static func reset() {
        UserDefaults.standard.set(false, forKey: User.written)
        UserDefaults.standard.set(0.0, forKey: User.key)
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
