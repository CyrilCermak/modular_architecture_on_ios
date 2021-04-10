//
//  StationOverviewService.swift
//  ISSOverviewService
//
//  Created by Cyril Cermak on 10.04.21.
//

import Foundation
import Combine
import ISSNetwork

public struct StationLive: Codable {
    public struct Position: Codable {
        public let longitude: String
        public let latitude: String
    }
    
    public let message: String
    public let iss_position: Position
}

enum StationRequest: Request {
    case live
    
    var url: URL { return URL(string: "http://api.open-notify.org/iss-now")! }
    var method: HTTPMethod { return .get }
}

public protocol StationOverviewServicing {
    func currentStationPosition() -> AnyPublisher<StationLive, Error>
}

public class StationOverviewService: StationOverviewServicing {
    
    private let networkService: NetworkServicing
    
    public init(networkService: NetworkServicing) {
        self.networkService = networkService
    }
    
    public func currentStationPosition() -> AnyPublisher<StationLive, Error> {
        return networkService.send(request: StationRequest.live,
                                   type: StationLive.self)
    }
    
}
