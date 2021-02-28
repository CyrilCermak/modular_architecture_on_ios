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

public class CosmonautCoordinator: NavigationCoordinator {
    public enum CosmonautLink {
        case none
    }
    
    public lazy var navigationController: UINavigationController = UINavigationController()
    
    public var childCoordinators: [Coordinator] = []
    private let cosmonautHealthService: CosmonautHealthServicing
    
    public init(cosmonautHealthService: CosmonautHealthServicing) {
        self.cosmonautHealthService = cosmonautHealthService
    }
    
    private lazy var subscriptions = Set<AnyCancellable>()
    
    public func start() {
        navigationController.setViewControllers([
            makeCosmonautViewController()
        ], animated: false)
    }
    
    public func start(link: DeepLink) -> Bool {
        // Handling deep links
        guard let link = link as? CosmonautLink else { return false }
        
        return true
    }
    
    private func makeCosmonautViewController() -> UIViewController {
        let comsonautVC = ComsonautViewController()
        comsonautVC.output.sink { [weak self] (action) in
            switch action {
            case .spaceSuit: break
            case .healtCheck:
                self?.presentHealthCheck()
            }
        }
        .store(in: &subscriptions)
        
        return comsonautVC
    }
    
    private func presentHealthCheck() {
        let healtModel = ComsonautHealthCheckViewModel(service: cosmonautHealthService)
        let healthVC = ComsonautHealthCheckViewController(viewModel: healtModel)
        healthVC.output
            .sink { [weak healthVC, weak self] (action) in
                switch action {
                case .close: healthVC?.dismiss(animated: true, completion: nil)
                case .heartBeat: self?.pushHeartBeat()
                }
            }
            .store(in: &subscriptions)
        
        navigationController.present(UINavigationController(rootViewController: healthVC), animated: true)
    }
    
    private func pushHeartBeat() {
        let heartBeatVC = CosmonautHeartBeatViewController()
        if let healthNavigation = navigationController.presentedViewController as? UINavigationController {
            healthNavigation.pushViewController(heartBeatVC, animated: true)
            return
        }
        
        navigationController.pushViewController(heartBeatVC, animated: true)
    }
}
