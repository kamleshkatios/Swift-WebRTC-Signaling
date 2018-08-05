//
//  SocketExtension.swift
//  Swift-WebRTC-Signaling
//
//  Created by kamlesh on 8/2/18.
//

import PerfectWebSockets

extension WebSocket {
    private struct NameHolder {
        static var _name = ""
    }
    
    var name: String {
        get {
            return NameHolder._name
        }
        set(newValue) {
            NameHolder._name = newValue
        }
    }
}

