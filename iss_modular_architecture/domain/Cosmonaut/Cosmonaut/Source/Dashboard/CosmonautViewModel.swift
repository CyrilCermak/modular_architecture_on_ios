//
//  CosmonautViewModel.swift
//  ISSCosmonaut
//
//  Created by Cyril Cermak on 11.04.21.
//

import Combine
import ISSOverviewService

class ComsonautViewModel {
    private let overviewService: StationOverviewServicing
    
    lazy var stationLive: AnyPublisher<String, Error> = {
        return overviewService.currentStationPosition()
            .map { (station) -> String in
                return "lon: \(station.iss_position.longitude), lat: \(station.iss_position.latitude) "
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

    }()
    
    init(overviewService: StationOverviewServicing) {
        self.overviewService = overviewService
    }
}
