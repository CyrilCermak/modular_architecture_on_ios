//
//  ComsonautHealthCheckViewController.swift
//  ISSCosmonaut
//
//  Created by Cyril Cermak on 27.02.21.
//

import UIKit
import Combine
import ISSUIComponents

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
