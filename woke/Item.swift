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


struct Item {
    
    var title: String
    var url: URL
    var author: String
    var dateModified: String
    var sourceTitle: String
    var polarity: String
    var body: String
    var imageURL: URL?
    var image: UIImage?
    
    func heightForTitle(_ font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: title).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(rect.height)
    }
}

extension Item : Equatable {
    init(itemDict: Dictionary<String, Any>) {
        let title = itemDict["title"] as? String ?? ""
        let authorArray = itemDict["authors"] as? Array<String> ?? []
        var author: String = "Unnamed"
        if authorArray.count > 0 {
            author = authorArray[0]
        }
        let dateModified = itemDict["date_modify"] as? String ?? ""
        let polarityScore = itemDict["polarityScore"] as! Dictionary<String, Any>
        let sourceTitle = polarityScore["sourceUrl"] as? String ?? ""
        let polarity = polarityScore["allSidesBias"] as? String ?? ""
        
        let urlText = itemDict["url"] as? String ?? ""
        let url = URL(string: urlText)!
        
        let imageUrlText = itemDict["image_url"] as? String ?? ""
        let imageUrl = URL(string: imageUrlText)
        
        let body = itemDict["text"] as! String
        
        self.init(title: title, url: url, author: author, dateModified: dateModified, sourceTitle: sourceTitle, polarity: polarity, body: body, imageURL: imageUrl, image: nil)
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        switch (lhs, rhs) {
        case (let leftItem, let rightItem): return leftItem.title == rightItem.title
        }
    }
}

extension UIImage {
    static func random(i: Int) -> UIImage? {
        let index = i % 4
        let height: CGFloat = 150 + CGFloat(arc4random_uniform(250))
        let rect = CGRect(x: 0, y: 0, width: 300, height: height)
        UIGraphicsBeginImageContext(rect.size)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color(index).withAlphaComponent(0.9).cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
