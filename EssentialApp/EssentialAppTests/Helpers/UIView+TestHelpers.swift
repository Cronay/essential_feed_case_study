//
//  File.swift
//  EssentialFeediOSTests
//
//  Created by Cronay on 29.11.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
