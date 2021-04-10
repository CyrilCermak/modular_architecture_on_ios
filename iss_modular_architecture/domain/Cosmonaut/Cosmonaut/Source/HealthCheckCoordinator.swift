//
//  HealthCheckCoordinator.swift
//  ISSCosmonaut
//
//  Created by Cyril Cermak on 10.04.21.
//

import UIKit
import Combine
import ISSUIComponents
import ISSCosmonautService

/// Not publicly exposed coordinator that is used internally from the CosmonautCoordinator
class HealthCheckCoordinator: NavigationCoordinator {
    enum HealthCheckLink: DeepLink { case healthCheck, heartBeat }
    
    lazy var navigationController: UINavigationController = UINavigationController()
    
    var childCoordinators: [Coordinator] = []
    public var finish: ((DeepLink?) -> Void)?
    private let cosmonautHealthService: CosmonautHealthServicing
    private lazy var subscriptions = Set<AnyCancellable>()
    
    init(cosmonautHealthService: CosmonautHealthServicing) {
        self.cosmonautHealthService = cosmonautHealthService
    }
    
    func start() {
        presentHealthCheck()
    }
    
    func start(link: DeepLink) -> Bool {
        guard let link = link as? HealthCheckLink else { return false }
        
        switch link {
        case .healthCheck:
            presentHealthCheck()
        case .heartBeat:
            pushHeartBeat()
        }
        
        return true
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
