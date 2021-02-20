//
//  CosmonautViewController.swift
//  ISSCosmonaut
//
//  Created by Cyril Cermak on 14.02.21.
//

import UIKit
import SnapKit
import Combine
import ISSUIComponents

class ComsonautViewController: UIViewController {
    
    private let cosmonautView = CosmonautView(frame: .zero)
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
    }
    
    override func loadView() {
        self.view = cosmonautView
    }
    
    private func bindView() {
        cosmonautView.healthCheckTapped
            .sink { (tapped) in
                print("Health check Tapped")
            }.store(in: &subscriptions)
        
        cosmonautView.spacesuitTapped
            .sink { (tapped) in
                print("Spacesuit Tapped")
            }.store(in: &subscriptions)
    }
}

class CosmonautView: UIView {
    
    var healthCheckTapped: AnyPublisher<Void, Never> {
        return healthCheckButton.tapped.eraseToAnyPublisher()
    }
    
    var spacesuitTapped: AnyPublisher<Void, Never> {
        return spaceSuitButton.tapped.eraseToAnyPublisher()
    }
    
    private let animationView = ISSAnimationView(animation: Animation(name: "cosmonaut",
                                                                   bundle: CosmonautModule.resourceBundle))
    private let spaceSuitButton: ISSButton = {
        let btn = ISSButton(title: "Spacesuite", style: .blue)
        return btn
    }()
    
    private let healthCheckButton: ISSButton = {
        let btn = ISSButton(title: "Health Check", style: .pink)
        return btn
    }()
    
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
        [animationView, spaceSuitButton, healthCheckButton].forEach({ addSubview($0) })
        
        animationView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(animationView.snp.width)
            make.center.equalToSuperview()
        }
        
        spaceSuitButton.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(healthCheckButton)
            make.bottom.equalTo(healthCheckButton.snp.top).offset(-16)
        }
        
        healthCheckButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(46)
        }
    }
}
