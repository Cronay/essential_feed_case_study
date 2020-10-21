//
//  UIImageView+Animations.swift
//  EssentialFeediOS
//
//  Created by Cronay on 21.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage

        guard newImage != nil else { return }

        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
