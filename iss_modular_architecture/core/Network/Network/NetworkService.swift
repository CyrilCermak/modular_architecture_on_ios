//
//  NetworkService.swift
//  ISSNetwork
//
//  Created by Cyril Cermak on 10.04.21.
//

import Foundation
import Combine


public enum HTTPMethod: String { case get, post, update, delete }
public protocol Request {
    typealias Headers = [String: String]
    
    var url: URL { get }
    var method: HTTPMethod { get }
    var queryParams: [URLQueryItem]? { get }
    var headers: Headers { get }
    var body: Data? { get }
}

public extension Request {
    var queryParams: [URLQueryItem]? { return [] }
    var headers: Headers { return [:] }
    var body: Data? { return nil }
}

public protocol URLRequestBuilding {
    func build(request: Request) -> URLRequest
}

public struct URLRequestBuilder: URLRequestBuilding {
    public func build(request: Request) -> URLRequest {
        var urlRequest = URLRequest(url: request.url)
        request.headers.forEach({ header in urlRequest.setValue(header.value, forHTTPHeaderField: header.key) })
        
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        return urlRequest
    }
}

public protocol NetworkServicing: AnyObject {
    func send<T>(request: Request, type: T.Type) -> AnyPublisher<T, Error> where T: Decodable
}

public class NetworkService: NetworkServicing {
    
    public init() {}
    
    public func send<T>(request: Request, type: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        let urlRequest = URLRequestBuilder().build(request: request)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
