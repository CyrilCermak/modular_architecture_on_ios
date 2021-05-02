//
//  CosmonautViewController.swift
//  ISSCosmonaut
//
//  Created by Cyril Cermak on 14.02.21.
//

import UIKit
import SnapKit
import Combine
import ISSUIComponents

class ComsonautViewController: UIViewController, Outputable {
    enum Action { case healtCheck, spaceSuit }
    
    /// Outputable protocol fullfilment
    lazy var output: AnyPublisher<Action, Never> = {
        return outputAction.eraseToAnyPublisher()
    }()
    
    private lazy var outputAction = PassthroughSubject<T, Never>()
    private let cosmonautView = CosmonautView(frame: UIScreen.main.bounds)
    private let viewModel: ComsonautViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(viewModel: ComsonautViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cosmonaut"
        bindView()
    }
    
    override func loadView() {
        self.view = cosmonautView
    }
    
    private func bindView() {
        
        viewModel.stationLive
            .sink { (error) in
                print(error)
            } receiveValue: { [weak self] (position) in
                self?.cosmonautView.set(position: position)
            }.store(in: &subscriptions)
        
        cosmonautView.healthCheckTapped
            .sink(receiveValue: { [weak self] in
                self?.outputAction.send(.healtCheck)
            })
            .store(in: &subscriptions)
        
        cosmonautView.spacesuitTapped
            .sink(receiveValue: { [weak self] in
                self?.outputAction.send(.spaceSuit)
            })
            .store(in: &subscriptions)
    }
}
