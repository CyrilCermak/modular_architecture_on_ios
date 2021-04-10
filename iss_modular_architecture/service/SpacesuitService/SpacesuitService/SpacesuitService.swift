//
//  SpacesuitService.swift
//  ISSSpacesuitService
//
//  Created by Cyril Cermak on 10.04.21.
//

import Foundation
import Combine
import ISSRadio

struct SpacesuitInfo: Codable {
    let outsideTemperature: Double
    let charge: String
    let pressure: Double
}

public class Spacesuit {
    public typealias Measure = (type: String, level: String)
    
    @Published public var outsideTemperature: Measure?
    @Published public var charge: Measure?
    @Published public var pressure: Measure?
    
    func update(measures: SpacesuitInfo) {
        outsideTemperature = (type: "Optimal", level: String(format: "%.3f", measures.outsideTemperature))
        charge = (type: "Optimal", level: measures.charge)
        pressure = (type: "Optimal", level: String(format: "%.3f", measures.pressure))
    }
}


public protocol SpacesuitServicing {
    var spacesuit: Spacesuit { get }
    func startSpacesuitMonitoring()
    func stopSpacesuitMonitoring()
}

public class SpacesuitService: SpacesuitServicing {
    public private(set) var spacesuit: Spacesuit = Spacesuit()
    private var spacesuitDataSubscription: AnyCancellable?
    private let radio: RadioServicing
    
    public init(radio: RadioServicing) {
        self.radio = radio
    }
    
    public func startSpacesuitMonitoring() {
        spacesuitDataSubscription = radio.connect(connectable: .spacesuit)
            .decode(type: SpacesuitInfo.self, decoder: JSONDecoder())
            .sink { (error) in
                // Show error
                print(error)
            } receiveValue: { (measures) in
                self.spacesuit.update(measures: measures)
            }
    }
    
    public func stopSpacesuitMonitoring() {
        spacesuitDataSubscription?.cancel()
        radio.disconnect(connectable: .cosmonautHealthCheck)
    }
}
