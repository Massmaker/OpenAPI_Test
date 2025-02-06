//
//  NetworkStatusWorker.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation
import Network
import Combine

final class NetworkStatusWorker :ObservableObject {
    
    private let queue:DispatchQueue
    private let monitor:NWPathMonitor
    @Published var isConnected:Bool = true
    
    let passThrough:PassthroughSubject<Bool, Never> = .init()
    var subscription:AnyCancellable?
    
    init() {
        
        queue = DispatchQueue(label: "Network.Connection.monitoring")
        
        //setup monitoring
        monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = updateStatus(for:)
        
        //subscribe for the updates
        subscription =
        passThrough
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: \.isConnected, on: self)
        
        
        //start monitoring
        monitor.start(queue: queue)
    }
    
    private func updateStatus(for path:NWPath) {
        switch path.status {
        case .satisfied:
            passThrough.send(true)
        case .unsatisfied:
            passThrough.send(false)
        case .requiresConnection:
            passThrough.send(false)
        @unknown default:
            passThrough.send(false)
        }
    }
}
