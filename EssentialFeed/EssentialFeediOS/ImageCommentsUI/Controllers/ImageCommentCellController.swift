//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by Yannic Borgfeld on 05.02.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import UIKit
import EssentialFeed

public class ImageCommentCellController: CellController {
    private let model: ImageCommentViewModel
    
    public init(model: ImageCommentViewModel) {
        self.model = model
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: ImageCommentCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = model.message
        cell.authorLabel.text = model.author
        cell.dateLabel.text = model.createdAt
        return cell
    }
}
