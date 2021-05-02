//
//  SpacesuitView.swift
//  ISSSpacesuit
//
//  Created by Cyril Cermak on 11.04.21.
//

import Foundation
import UIKit
import ISSUIComponents

class SpacesuitView: UIView {
    
    private let tableView = ISSTableView()
    
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
        [tableView].forEach({ addSubview($0) })
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func bind(models: [ISSTableCellModel]) {
        tableView.register(models: models)
        tableView.reload()
    }
}

