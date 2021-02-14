//
//  AppCoordinator.swift
//  ISSScaffold
//
//  Created by Cyril Cermak on 14.02.21.
//

import UIKit
import ISSUIComponents

public class AppCoordinator: Coordinator {
    
    public lazy var tabBarController: UITabBarController = {
       return UITabBarController()
    }()
    
    public var childCoordinators: [Coordinator] = []
    
    private let configuration: Configuration
    private let window: UIWindow
    
    public init(window: UIWindow, configuration: Configuration) {
        self.configuration = configuration
        self.window = window
    }
    
    public func start() {
        
        switch configuration.style {
        case .navigation:
            if let navigationCoordinator = childCoordinators.first as? NavigationCoordinator {
                window.rootViewController = navigationCoordinator.navigationController
            } else {
                fatalError("No NavigationCoordinator found for initial screen")
            }
        case .tabBar:
            childCoordinators.forEach { (coordinator) in
                // Setting up the tab bar with root tab view controllers
                if let coordinator = coordinator as? TabBarCoordinator {
                    coordinator.tabBarController = tabBarController
                    tabBarController.addChild(coordinator.tabBarController)
                }
            }
            
            window.rootViewController = tabBarController
        }
        
        window.makeKeyAndVisible()
        
        childCoordinators.first?.start()
    }
    
    public func start(link: DeepLink) -> Bool {
        
        if let link = link as? AppLink {
            switch link {
            case .menu:
                if let menuCoordinator = configuration.menuCoordinator {
                    menuCoordinator.start()
                    return true
                }
            }
            return false
        }
        
        return childCoordinators.first(where: { return $0.start(link: link) }) != nil
    }
}

extension AppCoordinator {
    public struct Configuration {
        public enum PresentatinStyle {
            case tabBar, navigation
        }
        
        public var style: PresentatinStyle
        public var menuCoordinator: Coordinator?
        
        public init(style: PresentatinStyle, menuCoordinator: Coordinator?) {
            self.style = style
            self.menuCoordinator = menuCoordinator
        }
    }
    
    public enum AppLink: DeepLink {
        case menu
    }
}
