//
//  CosmonautHeartBeatViewControlller.swift
//  ISSCosmonaut
//
//  Created by Cyril Cermak on 28.02.21.
//

import UIKit
import ISSUIComponents

class CosmonautHeartBeatView: UIView {
    
    private let animationView = ISSAnimationView(animation: Animation(name: "heart-beat",
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
        [animationView].forEach({ addSubview($0) })
        
        animationView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(animationView.snp.width)
            make.center.equalToSuperview()
        }
    }
}


class CosmonautHeartBeatViewController: UIViewController {
    
    private let heartBeatView = CosmonautHeartBeatView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Heart Beat"
    }
    
    override func loadView() {
        self.view = heartBeatView
    }
}
