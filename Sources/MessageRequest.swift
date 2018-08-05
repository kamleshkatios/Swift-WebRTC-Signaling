//
//  MessageRequest.swift
//  Swift-WebRTC-Signaling
//
//  Created by kamlesh on 7/28/18.
//


import PerfectLib

enum MessageType: String {
    case login
    case offer
    case answer
    case candidate
    case leave
}

class MessageRequest: JSONConvertibleObject {
    var type = ""
    var userName = ""
    var peerUserName = ""
    var offerSDP:[String : Any] = [:]
    var answer:[String : Any] = [:]
    var iceCandidate:[String : Any] = [:]
    var success = true
    
    init(json: [String: Any]?) {
        self.type = json?["type"] as? String ?? ""
        self.userName = json?["userName"] as? String ?? ""
        self.peerUserName = json?["name"] as? String ?? ""
        
        self.offerSDP = json?["offer"] as? [String : Any] ?? [:]
        self.answer = json?["answer"] as? [String : Any] ?? [:]
        self.iceCandidate = json?["candidate"] as? [String : Any] ?? [:]
    }
    
    override public func getJSONValues() -> [String : Any] {
        return [
            "type":type,
            "userName":userName,
            "name": peerUserName,
            "offer":offerSDP,
            "answer":answer,
            "candidate":iceCandidate,
            "success":success
        ]
    }
}
