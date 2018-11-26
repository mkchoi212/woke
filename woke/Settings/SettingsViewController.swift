//
//  SettingsViewController.swift
//  woke
//
//  Created by Mike Choi on 11/4/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    static let identifier = "SettingsVC"
    @IBOutlet weak var slider: Slider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSlider()
    }
    
    @IBAction func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            rateApp()
        case 1:
            rateApp()
        case 2:
            showResetAlert()
        default:
            fatalError("Unknown cell pressed in SettingsViewController")
        }
    }
    
    func rateApp() {
        // TODO
        let appID = "app_id_here"
        let urlStr = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)"
        
        if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func showResetAlert() {
        let alert = UIAlertController(title: title, message: "Do you really want to reset your statistics?", preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "OK", style: .destructive) { _ in
            User.reset()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        _ = [ok, cancel].map{ alert.addAction($0) }
        
        present(alert, animated: true, completion: nil)
    }
}

extension SettingsViewController {
    private func setupSlider() {
         let labelTextAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white
        ]
        
        slider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 1
            formatter.maximumFractionDigits = 1
            let string = "Me"
            return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.black])
        }
        slider.setMinimumImage(UIImage(named: "dem"))
        slider.setMaximumImage(UIImage(named: "rep"))
        
        slider.imagesColor = UIColor.white.withAlphaComponent(0.8)
        slider.setMinimumLabelAttributedText(NSAttributedString(string: "", attributes: labelTextAttributes))
        slider.setMaximumLabelAttributedText(NSAttributedString(string: "", attributes: labelTextAttributes))
        slider.fraction = CGFloat(User.score() / 5.0)
        slider.shadowOffset = CGSize(width: 0, height: 10)
        slider.shadowBlur = 5
        slider.shadowColor = UIColor(white: 0, alpha: 0.1)
        slider.contentViewColor = UIColor(polarity: User.score())
        slider.valueViewColor = .white
    }
}

extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}
