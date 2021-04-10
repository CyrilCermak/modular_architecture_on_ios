//
//  CosmonautCoordinator.swift
//  CosmonautTests
//
//  Created by Cyril Cermak on 14.02.21.
//

import UIKit
import Combine
import SnapKit
import ISSUIComponents
import ISSCosmonautService

/// Main navigation coordinator for the Cosmonaut app
public class CosmonautCoordinator: NavigationCoordinator {
    public enum CosmonautLink: DeepLink { case dashboard }
    public enum CosmonautOutterLink: DeepLink { case spaceSuit }
    
    public lazy var navigationController: UINavigationController = UINavigationController()
    
    public var childCoordinators: [Coordinator] = []
    public var finish: ((DeepLink?) -> Void)?
    private let cosmonautHealthService: CosmonautHealthServicing
    private lazy var registeredLinks = [CosmonautOutterLink: DeepLink]()
    
    public init(cosmonautHealthService: CosmonautHealthServicing) {
        self.cosmonautHealthService = cosmonautHealthService
        
        addChildCoordinators()
    }
    
    private lazy var subscriptions = Set<AnyCancellable>()
    
    public func start() {
        navigationController.setViewControllers([
            makeCosmonautViewController()
        ], animated: false)
    }
    
    public func start(link: DeepLink) -> Bool {
        // Handling deep links
        guard let cosmonautLink = link as? CosmonautLink else {
            // Searching for inner childs whether they can handle the link
            return childCoordinators.map({ $0.start(link: link) }).contains(true)
        }
        
        switch cosmonautLink {
        case .dashboard:
            navigationController.popToRootViewController(animated: true)
        }
        
        return true
    }
    
    public func register(outsideLink: DeepLink, for innerLink: DeepLink) {
        guard let innerLink = innerLink as? CosmonautOutterLink else {
            fatalError("Mapping link must be supported by the Coordinator")
        }
        
        registeredLinks[innerLink] = outsideLink
    }
    
    private func makeCosmonautViewController() -> UIViewController {
        let comsonautVC = ComsonautViewController()
        comsonautVC.output.sink { [weak self] (action) in
            switch action {
            case .spaceSuit:
                // Handling outter unknown link to this module
                let outterLink = self?.registeredLinks[CosmonautOutterLink.spaceSuit]
                self?.finish?(outterLink)
            case .healtCheck:
                // Handling private inner link to childs
                _ = self?.childCoordinators
                    .first(where: { $0.start(link: HealthCheckCoordinator.HealthCheckLink.healthCheck)})
            }
        }
        .store(in: &subscriptions)
        
        return comsonautVC
    }
    
    private func addChildCoordinators() {
        let healthCheck = HealthCheckCoordinator(cosmonautHealthService: cosmonautHealthService)
        // Sharing the same navigation stack
        healthCheck.navigationController = navigationController
        childCoordinators.append(healthCheck)
    }
}
