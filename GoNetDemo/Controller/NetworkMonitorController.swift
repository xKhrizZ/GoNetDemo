//
//  NetworkMonitorController.swift
//  GoNetDemo
//
//  Created by Christian Rojas on 20/02/22.
//

import UIKit
import Network

class NetworkMonitorController {
    
    static let shared = NetworkMonitorController()
    let networkMonitor = NWPathMonitor()
    
    func CheckNetworkConnection(completion: @escaping (Bool) -> Void) {
        networkMonitor.pathUpdateHandler = { path in
            let connection = path.status == .satisfied ? true : false
                completion(connection)
        }
        let queue = DispatchQueue(label: "Network connectivity")
        self.networkMonitor.start(queue: queue)
    }
}
