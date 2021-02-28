//
//  CosmonautService.swift
//  CosmonautServiceTests
//
//  Created by Cyril Cermak on 28.02.21.
//

import Foundation
import Combine
import ISSRadio

struct HealthMeasures: Codable {
    var bloodPressure: String
    var bloodOxygen: String
    var heartRate: String
    var bodyTemperature: String
}

public class CosmonautHealth {
    public typealias Measure = (type: String, level: String)
    
    @Published public var bloodPressure: Measure?
    @Published public var bloodOxygen: Measure?
    @Published public var heartRate: Measure?
    @Published public var bodyTemperature: Measure?
    
    func update(measures: HealthMeasures) {
        bloodPressure = (type: "Optimal", level: measures.bloodPressure)
        bloodOxygen = (type: "Optimal", level: measures.bloodOxygen)
        heartRate = (type: "Optimal", level: measures.heartRate)
        bodyTemperature = (type: "Optimal", level: measures.bodyTemperature)
    }
}

public protocol CosmonautHealthServicing {
    var health: CosmonautHealth { get }
    func startHealthMonitoring()
    func stopHealthMonitoring()
}

public class CosmonautService: CosmonautHealthServicing {
    public private(set) var health: CosmonautHealth = CosmonautHealth()
    private var healthSubscription: AnyCancellable?
    private let radio: RadioService
    
    public init(radio: RadioService) {
        self.radio = radio
    }
    
    public func startHealthMonitoring() {
        healthSubscription = radio.connect(connectable: .cosmonautHealthCheck)
            .decode(type: HealthMeasures.self, decoder: JSONDecoder())
            .sink { (error) in
                print(error)
            } receiveValue: { [weak health](measures) in
                health?.update(measures: measures)
            }
    }
    
    public func stopHealthMonitoring() {
        healthSubscription?.cancel()
        radio.disconnect(connectable: .cosmonautHealthCheck)
    }
}
