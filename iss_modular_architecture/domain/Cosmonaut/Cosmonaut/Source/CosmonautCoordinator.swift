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


class ComsonautViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = CosmonautView(frame: UIScreen.main.bounds)
    }
}

class CosmonautView: UIView {
    
    private let animationView = ISSAnimationView(animation: Animation(name: "cosmonaut",
                                                                   bundle: CosmonautModule.resourceBundle))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(animationView.snp.width)
            make.center.equalToSuperview()
        }
    }
}
