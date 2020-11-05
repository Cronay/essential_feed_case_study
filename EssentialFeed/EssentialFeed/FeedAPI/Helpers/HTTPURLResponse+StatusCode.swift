//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Cronay on 05.11.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
