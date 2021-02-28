//
//  Outputable.swift
//  ISSUIComponents
//
//  Created by Cyril Cermak on 27.02.21.
//

import Combine

public protocol Outputable {
    associatedtype T
    var output: AnyPublisher<T, Never> { get }
}
