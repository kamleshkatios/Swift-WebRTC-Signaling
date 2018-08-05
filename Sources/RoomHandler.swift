//
//  RoomHandler.swift
//  Swift-WebRTC-Signaling
//
//  Created by kamlesh on 7/30/18.
//

import Foundation


import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectWebSockets

class RoomHandler {
    
    //This line makes this a singleton, where you only use one shared instance of this class across the whole project. Singletons are VERY useful as a dataservice where data moves in and out, but needs to be shown in many places.
    static let instance = RoomHandler()
    
    var usersList: [String: WebSocket] = [:]
}
