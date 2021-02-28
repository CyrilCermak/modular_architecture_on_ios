//
//  ISSDetailTableCell.swift
//  ISSUIComponents
//
//  Created by Cyril Cermak on 28.02.21.
//

import UIKit
import Combine

public class ISSDetailTableModel: ISSTableCellModel {
    public static var cellClass: AnyClass { get { return ISSDetailTableCell.self }}
    
    @Published public var title: String?
    @Published public var subtitle: String?
    @Published public var detail: String?
    
    public init(title: String = "", subtitle: String = "", detail: String = "") {
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
    }
}

public class ISSDetailTableCell: UITableViewCell, ISSTableCellModelBindable {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.issTitle
        label.textColor = UIColor.issBlack
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.issSubtitle
        label.textColor = UIColor.issBlack
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.issTitle
        label.textColor = UIColor.issBlack
        return label
    }()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    private func setup() {
        [titleLabel, subtitleLabel, detailLabel].forEach({ contentView.addSubview($0) })
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.left.equalTo(self.titleLabel)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        contentView.heightAnchor.constraint(equalToConstant: 65).isActive = true
    }
    
    public func bind(model: ISSTableCellModel) {
        guard let model = model as? ISSDetailTableModel else {
            fatalError("Wrong model attached to the cell")
        }
        
        model.$title
            .assign(to: \.text, on: titleLabel)
            .store(in: &subscriptions)
            
        model.$subtitle
            .assign(to: \.text, on: subtitleLabel)
            .store(in: &subscriptions)
        
        model.$detail
            .assign(to: \.text, on: detailLabel)
            .store(in: &subscriptions)
    }
}
