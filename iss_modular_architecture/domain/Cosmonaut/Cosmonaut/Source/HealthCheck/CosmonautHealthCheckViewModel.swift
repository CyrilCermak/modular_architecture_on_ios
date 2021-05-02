//
//  ComsonautHealthCheckViewModel.swift
//  ISSCosmonaut
//
//  Created by Cyril Cermak on 11.04.21.
//

import Foundation
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
