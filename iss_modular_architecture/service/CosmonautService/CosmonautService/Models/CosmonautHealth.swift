//
//  CosmonautHealth.swift
//  CosmonautServiceTests
//
//  Created by Cyril Cermak on 28.02.21.
//

import Foundation
import Combine

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
