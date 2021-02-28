//
//  RadioService.swift
//  ISSRadio
//
//  Created by Cyril Cermak on 28.02.21.
//

import Foundation
import Combine
import CoreBluetooth

public protocol RadioServicing {
    func connect(connectable: RadioService.Connectable) -> AnyPublisher<Data, Error>
    func disconnect(connectable: RadioService.Connectable)
}

private struct DataFactory {
    static var healthJson: String { """
{
"bloodPressure": "\(Int.random(in: 110...160))/\(Int.random(in: 70...95))",
"bloodOxygen": "\(Int.random(in: 90...100))%",
"heartRate": "\(Int.random(in: 100...140))",
"bodyTemperature": "\(Double.random(in: 35.6...37))"
}
"""
    }
}

public class RadioService: RadioServicing {
    public enum Connectable {
        case spacesuit, cosmonautHealthCheck
    }
    
    // Mocking the radio
    private var healthTimer: Cancellable?
    private var healthPublisher = PassthroughSubject<Data, Error>()
    private var spacesuitPublisher = PassthroughSubject<Data, Error>()
    
    public init() {}
    
    public func connect(connectable: Connectable) -> AnyPublisher<Data, Error> {
        switch connectable {
        case .cosmonautHealthCheck:
            observeHealthValues()
            return healthPublisher.eraseToAnyPublisher()
        case .spacesuit:
            // TODO: Observe spacesuit values
            return spacesuitPublisher.eraseToAnyPublisher()
        }
    }
    
    public func disconnect(connectable: RadioService.Connectable) {
        switch connectable {
        case .cosmonautHealthCheck: break
        case .spacesuit: break
        }
    }
    
    /// Mocking the real radio
    private func observeHealthValues() {
        healthTimer = Timer.publish(every: 2, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { [weak healthPublisher](_) in
                guard let data = DataFactory.healthJson.data(using: .utf8) else { return }
                
                healthPublisher?.send(data)
            })
    }
}
