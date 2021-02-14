//
//  AppDelegate.swift
//  Cosmonaut
//
//  Created by Cyril Cermak on 04.01.21.
//

import UIKit
import ISSScaffold
import ISSCosmonaut

struct CosmonautConfiguration {
    lazy var appCoordinator: AppCoordinator.Configuration = {
        return AppCoordinator.Configuration(style: .navigation,
                                            menuCoordinator: nil)
    }()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = UIWindow()
    
    private var configuration = CosmonautConfiguration()
    
    private lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(window: window!,
                              configuration: configuration.appCoordinator)
    }()
    
    private lazy var cosmonautCoordinator = CosmonautCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        appCoordinator.childCoordinators = [
            cosmonautCoordinator
        ]
        
        appCoordinator.start()
        return true
    }

}

