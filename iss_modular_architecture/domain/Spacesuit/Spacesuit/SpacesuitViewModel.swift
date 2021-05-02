//
//  SpacesuitViewModel.swift
//  ISSSpacesuit
//
//  Created by Cyril Cermak on 11.04.21.
//

import UIKit
import Combine
import ISSUIComponents
import ISSSpacesuitService
import ISSNetwork

class SpacesuitViewModel {
    
    @Published var models: [ISSTableCellModel] = []
    
    private let service: SpacesuitServicing
    private var subscriptions = Set<AnyCancellable>()
    init(service: SpacesuitServicing) {
        self.service = service
        
        makeModels()
    }
    
    func start() {
        service.startSpacesuitMonitoring()
    }
    
    func stop() {
        service.stopSpacesuitMonitoring()
    }
    
    private func makeModels() {
        let outsideTemperature = ISSDetailTableModel(title: "Outside Temperature")
        let charge = ISSDetailTableModel(title: "Charge")
        let pressure = ISSDetailTableModel(title: "Atmosphere Pressure")
        
        service.spacesuit.$outsideTemperature
            .sink(receiveValue: { [weak outsideTemperature] (measure) in
                outsideTemperature?.subtitle = measure?.type
                outsideTemperature?.detail = measure?.level
            }).store(in: &subscriptions)
        
        service.spacesuit.$charge
            .sink(receiveValue: { [weak charge] (measure) in
                charge?.subtitle = measure?.type
                charge?.detail = measure?.level
            }).store(in: &subscriptions)
        
        service.spacesuit.$pressure
            .sink(receiveValue: { [weak pressure] (measure) in
                pressure?.subtitle = measure?.type
                pressure?.detail = measure?.level
            }).store(in: &subscriptions)
        
        models = [outsideTemperature, charge, pressure]
    }
}
