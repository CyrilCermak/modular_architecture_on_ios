//
//  ComsonautHealthCheckiewController.swift
//  ISSCosmonaut
//
//  Created by Cyril Cermak on 27.02.21.
//

import UIKit
import Combine
import ISSUIComponents
import ISSCosmonautService
import ISSNetwork

class ComsonautHealthCheckViewModel {
    
    @Published var models: [ISSTableCellModel] = []
    private let service: CosmonautHealthServicing
    private var subscriptions = Set<AnyCancellable>()
    init(service: CosmonautHealthServicing) {
        self.service = service
        
        makeModels()
    }
    
    func start() {
        service.startHealthMonitoring()
    }
    
    func stop() {
        service.stopHealthMonitoring()
    }
    
    private func makeModels() {
        let bloodPressure = ISSDetailTableModel(title: "Blood pressure",
                                                subtitle: "Optimal",
                                                detail: "120/80")
        
        service.health.$bloodPressure
            .sink(receiveValue: { [weak bloodPressure] (measure) in
                print(measure)
                bloodPressure?.detail = measure?.level
            }).store(in: &subscriptions)
        
        models = [bloodPressure]
    }
}

class ComsonautHealthCheckViewController: UIViewController, Outputable {
    enum Action { case close }
    
    /// Outputable protocol fullfilment
    lazy var output: AnyPublisher<Action, Never> = {
        return outputAction.eraseToAnyPublisher()
    }()
    
    private lazy var outputAction = PassthroughSubject<T, Never>()
    private let cosmonautView = CosmonautHealthCheckView(frame: .zero)
    private var model: ComsonautHealthCheckViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    convenience init(viewModel: ComsonautHealthCheckViewModel) {
        self.init()
        self.model = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
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
        self.view = cosmonautView
    }
    
    private func bindView() {
        model.$models
            .sink { [weak cosmonautView] (models) in
                cosmonautView?.bind(models: models)
            }
            .store(in: &subscriptions)
    }
}

class CosmonautHealthCheckView: UIView {
    
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
            make.edges.equalToSuperview()
        }
    }
    
    func bind(models: [ISSTableCellModel]) {
        tableView.register(models: models)
        tableView.reload()
    }
}

