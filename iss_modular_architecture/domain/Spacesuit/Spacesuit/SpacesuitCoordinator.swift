//
//  SpacesuitCoordinator.swift
//  ISSSpacesuit
//
//  Created by Cyril Cermak on 10.04.21.
//

import UIKit
import Combine
import ISSUIComponents
import ISSSpacesuitService

/// Main navigation coordinator for the Cosmonaut app
public class SpacesuitCoordinator: NavigationCoordinator {
    public enum SpacesuitLink: DeepLink { case spacesuit }
    
    private let spacesuitService: SpacesuitServicing
    private var subscriptions: Set<AnyCancellable> = []
    
    public lazy var navigationController: UINavigationController = UINavigationController()
    public var childCoordinators: [Coordinator] = []
    public var finish: ((DeepLink?) -> Void)?
    
    public init(spacesuitService: SpacesuitServicing) {
        self.spacesuitService = spacesuitService
    }
    
    public func start() {
        presentSpacesuit()
    }
    
    public func start(link: DeepLink) -> Bool {
        // Handling deep links
        guard let spacesuitLink = link as? SpacesuitLink else {
            return false
        }
        
        switch spacesuitLink {
        case .spacesuit:
            presentSpacesuit()
        }
        
        return true
    }
    
    private func presentSpacesuit() {
        let spacesuitVM = SpacesuitViewModel(service: spacesuitService)
        let spacesuitVC = SpacesuitViewController(viewModel: spacesuitVM)
        spacesuitVC.output
            .sink { [weak spacesuitVC] (action) in
                switch action {
                case .close: spacesuitVC?.dismiss(animated: true, completion: nil)
                }
            }.store(in: &subscriptions)
        
        navigationController.present(UINavigationController(rootViewController: spacesuitVC),
                                     animated: true,
                                     completion: nil)
    }
}
