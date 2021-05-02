//
//  CosmonautView.swift
//  ISSCosmonaut
//
//  Created by Cyril Cermak on 11.04.21.
//

import UIKit
import Combine
import ISSUIComponents

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
    
    private let currentPositionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.issSubtitle
        label.textColor = UIColor.gray
        return label
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
        [currentPositionLabel, animationView, spaceSuitButton, healthCheckButton].forEach({ addSubview($0) })
        
        currentPositionLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.safeAreaInsets.right).offset(-10)
            make.top.equalTo(self.safeAreaInsets.top).offset(100)
        }
        
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
    
    func set(position: String) {
        currentPositionLabel.text = position
    }
}

