//
//  AppDelegate.swift
//  Cosmonaut
//
//  Created by Cyril Cermak on 04.01.21.
//

import UIKit
import ISSRadio
import ISSScaffold
import ISSCosmonautService
import ISSSpacesuitService
import ISSCosmonaut
import ISSSpacesuit

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
    
    private lazy var radioService = RadioService()
    
    private lazy var cosmonautHealtService: CosmonautHealthServicing = {
        return CosmonautHealthService(radio: radioService)
    }()
    
    private lazy var spacesuitService: SpacesuitService = {
        return SpacesuitService(radio: radioService)
    }()
    
    private lazy var spacesuitCoordinator: SpacesuitCoordinator = {
        return SpacesuitCoordinator(spacesuitService: spacesuitService)
    }()
    
    private lazy var cosmonautCoordinator: CosmonautCoordinator = {
        return CosmonautCoordinator(cosmonautHealthService: cosmonautHealtService)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Mapping outside link for the spacesuit for the Cosmonaut
        cosmonautCoordinator.register(outsideLink: SpacesuitCoordinator.SpacesuitLink.spacesuit,
                                      for: CosmonautCoordinator.CosmonautOutterLink.spaceSuit)
        
        appCoordinator.childCoordinators = [
            cosmonautCoordinator,
            spacesuitCoordinator
        ]
        
        appCoordinator.start()
        return true
    }

}

