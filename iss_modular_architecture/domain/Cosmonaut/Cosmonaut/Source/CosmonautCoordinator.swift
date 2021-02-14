//
//  CosmonautCoordinator.swift
//  CosmonautTests
//
//  Created by Cyril Cermak on 14.02.21.
//

import UIKit
import ISSUIComponents

public class CosmonautCoordinator: NavigationCoordinator {
    public enum CosmonautLink {
        case none
    }
    
    public lazy var navigationController: UINavigationController = { UINavigationController(rootViewController: makeCosmonautViewController()) }()
    
    public var childCoordinators: [Coordinator] = []
    
    public init() {}
    
    public func start() {
    }
    
    public func start(link: DeepLink) -> Bool {
        guard let link = link as? CosmonautLink else { return false }
        
        return true
    }
    
    private func makeCosmonautViewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        return vc
    }
}
