//
//  CosmonautService.swift
//  CosmonautServiceTests
//
//  Created by Cyril Cermak on 28.02.21.
//

import Foundation
import Combine
import ISSRadio

public protocol CosmonautHealthServicing {
    var health: CosmonautHealth { get }
    func startHealthMonitoring()
    func stopHealthMonitoring()
}

public class CosmonautHealthService: CosmonautHealthServicing {
    public private(set) var health: CosmonautHealth = CosmonautHealth()
    private var healthSubscription: AnyCancellable?
    private let radio: RadioServicing
    
    public init(radio: RadioServicing) {
        self.radio = radio
    }
    
    public func startHealthMonitoring() {
        healthSubscription = radio.connect(connectable: .cosmonautHealthCheck)
            .decode(type: HealthMeasures.self, decoder: JSONDecoder())
            .sink { (error) in
                // Show error
            } receiveValue: { [weak health](measures) in
                health?.update(measures: measures)
            }
    }
    
    public func stopHealthMonitoring() {
        healthSubscription?.cancel()
        radio.disconnect(connectable: .cosmonautHealthCheck)
    }
}
