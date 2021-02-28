//
//  ISSTableView.swift
//  ISSUIComponents
//
//  Created by Cyril Cermak on 27.02.21.
//

import UIKit
import Combine

/// Protocols
public protocol ISSCellProviding {
    static var cellClass: AnyClass { get }
}

public protocol ISSTableCellModel: ISSCellProviding {}

public protocol ISSTableCellModelBindable {
    func bind(model: ISSTableCellModel)
}

/// Implementation
public class ISSTableView: UITableView {
    
    private var models: [ISSTableCellModel] = []

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        delegate = self
        dataSource = self
        clipsToBounds = false
        separatorStyle = .none
        backgroundColor = .clear
    }
    
    public func register(models: [ISSTableCellModel]) {
        self.models = models
        
        models
            .map({ type(of: $0).cellClass })
            .forEach { (cellClass) in
                self.register(cellClass, forCellReuseIdentifier: cellClass.description())
            }
    }
    
    public func reload() {
        reloadData()
    }
}

extension ISSTableView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: type(of: model).cellClass.description()) else {
            fatalError("Model was not registered in the context")
        }
        
        guard let bindableCell = cell as? ISSTableCellModelBindable else {
            fatalError("Provided cell on the model does not conform to `ISSTableCellModelBindable`")
        }
        
        bindableCell.bind(model: model)
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
