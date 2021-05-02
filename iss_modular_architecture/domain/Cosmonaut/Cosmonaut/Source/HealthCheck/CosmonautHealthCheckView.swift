//
//  CosmonautHealthCheckView.swift
//  ISSCosmonaut
//
//  Created by Cyril Cermak on 11.04.21.
//

import UIKit
import Combine
import ISSUIComponents

class CosmonautHealthCheckView: UIView {
    
    var healthCheckTapped: AnyPublisher<Void, Never> {
        return heartBeat.tapped.eraseToAnyPublisher()
    }
    
    private let tableView = ISSTableView()
    
    private let heartBeat: ISSButton = {
        return ISSButton(title: "Heart Beat", style: .pink)
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
        [tableView, heartBeat].forEach({ addSubview($0) })
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(heartBeat.snp.top)
        }
        
        heartBeat.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(46)
        }
    }
    
    func bind(models: [ISSTableCellModel]) {
        tableView.register(models: models)
        tableView.reload()
    }
}

