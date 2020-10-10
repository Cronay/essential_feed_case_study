//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Cronay on 08.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import UIKit
import EssentialFeed

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) -> FeedImageDataLoaderTask
}

public final class FeedViewController: UITableViewController {
    private var feedLoader: FeedLoader?
    private var imageLoader: FeedImageDataLoader?
    private var tableModel = [FeedImage]()
    private var tasks = [IndexPath: FeedImageDataLoaderTask]()

    public convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader?) {
        self.init()
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(FeedImageCell.self, forCellReuseIdentifier: "FeedImageCell")
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }

    @objc private func load() {
        refreshControl?.beginRefreshing()
        feedLoader?.load() { [weak self] result in
            if let feed = try? result.get() {
                self?.tableModel = feed
                self?.tableView.reloadData()
            }
            self?.refreshControl?.endRefreshing()
        }
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath) as! FeedImageCell
        let model = tableModel[indexPath.row]
        cell.locationLabel.text = model.location
        cell.descriptionLabel.text = model.description
        cell.locationContainer.isHidden = model.location == nil
        tasks[indexPath] = imageLoader?.loadImageData(from: model.url)
        return cell
    }

    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
        tasks[indexPath] = nil
    }
}
