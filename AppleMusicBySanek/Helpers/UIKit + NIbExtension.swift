//
//  UIKit + NIbExtension.swift
//  MusicPlayer
//
//  Created by Александр Галкин on 29.09.2021.
//

import UIKit

extension UIView {
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as! T
    }
}
