//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by Yannic Borgfeld on 06.02.22.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class CommentsUIComposer {
    private init() {}
    
    private typealias CommentsPresentationAdapter = LoadResourcePresentationAdapter<[ImageComment], CommentsViewAdapter>

    public static func commentsComposedWith(commentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>) -> ListViewController {
        let presentationAdapter = CommentsPresentationAdapter(loader: commentsLoader)

        let commentsController = ListViewController.makeWith(
            title: ImageCommentsPresenter.title)
        commentsController.onRefresh = presentationAdapter.loadResource
        
        let presenter = LoadResourcePresenter(
            resourceView: CommentsViewAdapter(controller: commentsController),
            loadingView: WeakRefVirtualProxy(commentsController),
            errorView: WeakRefVirtualProxy(commentsController),
            mapper: { ImageCommentsPresenter.map($0) }
        )

        presentationAdapter.presenter = presenter
        return commentsController
    }
}

private extension ListViewController {
    static func makeWith(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.title = title
        return controller
    }
}
