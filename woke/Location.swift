//
//    MIT License
//
//    Copyright (c) 2017 Touchwonders B.V.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.


import UIKit


enum Location: Equatable {
    case collection(String)
    case home
    
    var controller: UIViewController {
        switch self {
        case .home: return HomeCollectionViewController()
        case .collection(let category): return CollectionViewController(with: category)
        }
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        switch (lhs, rhs) {
        case (.collection, .home):
            return false
        case (.home, .collection):
            return false
        case (.home, .home):
            return true
        case (.collection, .collection):
            return true
        }
    }
}

extension Location {
    func title() -> String {
        switch self {
        case .collection: return "collection"
        case .home: return "home"
        }
    }
}
