
//
//  SpacesuitViewController.swift
//  ISSSpacesuit
//
//  Created by Cyril Cermak on 27.02.21.
//

import UIKit
import Combine
import ISSUIComponents
import ISSSpacesuitService
import ISSNetwork

class SpacesuitViewModel {
    
    @Published var models: [ISSTableCellModel] = []
    
    private let service: SpacesuitServicing
    private var subscriptions = Set<AnyCancellable>()
    init(service: SpacesuitServicing) {
        self.service = service
        
        makeModels()
    }
    
    func start() {
        service.startSpacesuitMonitoring()
    }
    
    func stop() {
        service.stopSpacesuitMonitoring()
    }
    
    private func makeModels() {
        let outsideTemperature = ISSDetailTableModel(title: "Outside Temperature")
        let charge = ISSDetailTableModel(title: "Charge")
        let pressure = ISSDetailTableModel(title: "Atmosphere Pressure")
        
        service.spacesuit.$outsideTemperature
            .sink(receiveValue: { [weak outsideTemperature] (measure) in
                outsideTemperature?.subtitle = measure?.type
                outsideTemperature?.detail = measure?.level
            }).store(in: &subscriptions)
        
        service.spacesuit.$charge
            .sink(receiveValue: { [weak charge] (measure) in
                charge?.subtitle = measure?.type
                charge?.detail = measure?.level
            }).store(in: &subscriptions)
        
        service.spacesuit.$pressure
            .sink(receiveValue: { [weak pressure] (measure) in
                pressure?.subtitle = measure?.type
                pressure?.detail = measure?.level
            }).store(in: &subscriptions)
        
        models = [outsideTemperature, charge, pressure]
    }
}

class SpacesuitViewController: UIViewController, Outputable {
    enum Action { case close }
    
    /// Outputable protocol fullfilment
    lazy var output: AnyPublisher<Action, Never> = {
        return outputAction.eraseToAnyPublisher()
    }()
    
    private lazy var outputAction = PassthroughSubject<T, Never>()
    private let spacesuitView = SpacesuitView(frame: .zero)
    private var model: SpacesuitViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    convenience init(viewModel: SpacesuitViewModel) {
        self.init()
        self.model = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spacesuit"
        bindView()
        
        // Close button in Navigation
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        model.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.stop()
    }
    
    override func loadView() {
        self.view = spacesuitView
    }
    
    private func bindView() {
        model.$models
            .sink { [weak spacesuitView] (models) in
                spacesuitView?.bind(models: models)
            }
            .store(in: &subscriptions)
    }
    
    @objc
    func didTapClose() {
        outputAction.send(.close)
    }
}

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

