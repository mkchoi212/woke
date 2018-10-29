//
//  DateManager.swift
//  woke
//
//  Created by Mike Choi on 10/28/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import Foundation

struct DateManager {
    static let shared = DateManager()
    static let formatter = DateFormatter()
    
    static func today() -> String {
        formatter.dateFormat = "MMMM dd"
        return formatter.string(from: Date())
    }
}
