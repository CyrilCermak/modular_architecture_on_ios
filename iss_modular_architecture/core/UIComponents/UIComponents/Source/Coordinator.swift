//
//  Coordinator.swift
//  ISSUIComponents
//
//  Created by Cyril Cermak on 14.02.21.
//
// https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps
// https://www.strv.com/blog/how-to-supercharge-coordinators-engineering

import Foundation
import UIKit


public protocol DeepLink {}

public protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func start(link: DeepLink) -> Bool
}

public protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get set }
}

public protocol TabBarCoordinator: Coordinator {
    var tabBarController: UITabBarController { get set }
    var tabViewController: TabBarViewController { get }
}

public protocol TabBarViewController: UIViewController {
    var tabBarImage: UIImage { get }
}
