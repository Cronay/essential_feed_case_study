//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by Yannic Borgfeld on 05.02.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import UIKit
import EssentialFeed

public class ImageCommentCellController: NSObject, CellController {
    private let model: ImageCommentViewModel
    
    public init(model: ImageCommentViewModel) {
        self.model = model
    }
        
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImageCommentCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = model.message
        cell.authorLabel.text = model.author
        cell.dateLabel.text = model.createdAt
        return cell
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {}
}
