//
//  UIViewController + Storyboard.swift
//  AppleMusicBySanek
//
//  Created by Александр Галкин on 22.09.2021.
//

import AVKit
import UIKit

extension UIViewController {
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        if let vc = storyboard.instantiateInitialViewController() as? T {
            return vc
        } else {
            fatalError("Error: No initial viewController in \(name) storyboard!")
        }
    }
}

extension CMTime {
    func toString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "no data"}
        let total = Int(CMTimeGetSeconds(self))
        let seconds = total % 60
        let minutes = total / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
