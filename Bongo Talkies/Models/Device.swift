//
//  Device.swift
//  Bongo Talkies
//
//  Created by Admin on 7/11/22.
//

import UIKit
import Combine
import Network

final class Device: ObservableObject {
    
    var screenWidth : CGFloat {  UIScreen.main.bounds.width }
    
    @Published var isLandscape: Bool = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Network_Monitor")
    @Published private(set) var connected: Bool = true
    
    
    func checkConnection() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.connected = path.status == .satisfied
            }
        }
        
        monitor.start(queue: queue)
    }
}
