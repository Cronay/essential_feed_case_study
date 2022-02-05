//
//  ImageCommentCell.swift
//  EssentialFeediOS
//
//  Created by Yannic Borgfeld on 05.02.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import UIKit

public final class ImageCommentCell: UITableViewCell {
    @IBOutlet private(set) public var messageLabel: UILabel!
    @IBOutlet private(set) public var authorLabel: UILabel!
    @IBOutlet private(set) public var dateLabel: UILabel!
}
