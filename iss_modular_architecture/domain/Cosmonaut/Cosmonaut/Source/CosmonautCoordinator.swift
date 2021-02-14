//
//  CosmonautCoordinator.swift
//  CosmonautTests
//
//  Created by Cyril Cermak on 14.02.21.
//

import UIKit
import ISSUIComponents
import SnapKit

public class CosmonautCoordinator: NavigationCoordinator {
    public enum CosmonautLink {
        case none
    }
    
    public lazy var navigationController: UINavigationController = UINavigationController()
    
    public var childCoordinators: [Coordinator] = []
    
    public init() {}
    
    public func start() {
        navigationController.setViewControllers([
            makeCosmonautViewController()
        ], animated: false)
    }
    
    public func start(link: DeepLink) -> Bool {
        guard let link = link as? CosmonautLink else { return false }
        
        return true
    }
    
    private func makeCosmonautViewController() -> UIViewController {
        return ComsonautViewController()
    }
}
