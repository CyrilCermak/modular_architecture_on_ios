//
//  CosmonautModule.swift
//  CosmonautTests
//
//  Created by Cyril Cermak on 14.02.21.
//

import Foundation

class CosmonautModule {
    static var resourceBundle: Bundle = {
        var bundleUrl = Bundle(for: CosmonautModule.self).bundleURL
        bundleUrl.appendPathComponent("Resource.bundle")
        return Bundle(url: bundleUrl)!
    }()
}
