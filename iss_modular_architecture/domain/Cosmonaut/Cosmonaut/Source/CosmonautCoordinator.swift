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
    public enum CosmonautLink: DeepLink {
        case cosmonautDashboard
    }
    
    public lazy var navigationController: UINavigationController = UINavigationController()
    
    public var childCoordinators: [Coordinator] = []
    private let cosmonautHealthService: CosmonautHealthServicing
    
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
            return childCoordinators.map({ $0.start(link: link) }).contains(false)
        }
        
        switch cosmonautLink {
        case .cosmonautDashboard:
            navigationController.popToRootViewController(animated: true)
        }
        
        return true
    }
    
    private func makeCosmonautViewController() -> UIViewController {
        let comsonautVC = ComsonautViewController()
        comsonautVC.output.sink { [weak self] (action) in
            switch action {
            case .spaceSuit: break
            //Handling inner child coordinators link
            case .healtCheck:
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
