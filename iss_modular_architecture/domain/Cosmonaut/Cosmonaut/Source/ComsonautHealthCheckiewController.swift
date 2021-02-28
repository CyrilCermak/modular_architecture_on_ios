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
        let bloodPressure = ISSDetailTableModel(title: "Blood pressure")
        let bloodOxygen = ISSDetailTableModel(title: "Blood Oxygen")
        let heartRate = ISSDetailTableModel(title: "Heart Rate")
        let bodyTemperature = ISSDetailTableModel(title: "Body Temperature")
        
        service.health.$bloodPressure
            .sink(receiveValue: { [weak bloodPressure] (measure) in
                bloodPressure?.subtitle = measure?.type
                bloodPressure?.detail = measure?.level
            }).store(in: &subscriptions)
        
        service.health.$bloodOxygen
            .sink(receiveValue: { [weak bloodOxygen] (measure) in
                bloodOxygen?.subtitle = measure?.type
                bloodOxygen?.detail = measure?.level
            }).store(in: &subscriptions)
        
        service.health.$heartRate
            .sink(receiveValue: { [weak heartRate] (measure) in
                heartRate?.subtitle = measure?.type
                heartRate?.detail = measure?.level
            }).store(in: &subscriptions)
        
        service.health.$bodyTemperature
            .sink(receiveValue: { [weak bodyTemperature] (measure) in
                bodyTemperature?.subtitle = measure?.type
                bodyTemperature?.detail = measure?.level
            }).store(in: &subscriptions)
        
        models = [bloodPressure, bloodOxygen, heartRate, bodyTemperature]
    }
}

class ComsonautHealthCheckViewController: UIViewController, Outputable {
    enum Action { case close, heartBeat }
    
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
        
        title = "Health Check"
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
        self.view = cosmonautView
    }
    
    private func bindView() {
        model.$models
            .sink { [weak cosmonautView] (models) in
                cosmonautView?.bind(models: models)
            }
            .store(in: &subscriptions)
        
        cosmonautView.healthCheckTapped
            .sink { [weak outputAction] in
                outputAction?.send(.heartBeat)
            }
            .store(in: &subscriptions)
    }
    
    @objc
    func didTapClose() {
        outputAction.send(.close)
    }
}

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

