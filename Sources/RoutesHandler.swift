//
//  RoutesHandler.swift
//  Swift-WebRTC-SignalingPackageDescription
//
//  Created by kamlesh on 7/26/18.
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectWebSockets

func chatHandler(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        
        // Provide your closure which will return the service handler.
        WebSocketHandler(handlerProducer: {
            (request: HTTPRequest, protocols: [String]) -> WebSocketSessionHandler? in
            
            // Check to make sure the client is requesting our "echo" service.
            guard protocols.contains("chat") else {
                return nil
            }
            
            // Return our service handler.
            return ChatHandler()
        }).handleRequest(request: request, response: response)
    }
}

class ChatHandler: WebSocketSessionHandler {
    
    // The name of the super-protocol we implement.
    // This is optional, but it should match whatever the client-side WebSocket is initialized with.
    let socketProtocol: String? = "chat"
    
    // This function is called by the WebSocketHandler once the connection has been established.
    func handleSession(request: HTTPRequest, socket: WebSocket) {
        
        // Read a message from the client as a String.
        // Alternatively we could call `WebSocket.readBytesMessage` to get the data as a String.
        socket.readStringMessage {
            // This callback is provided:
            //  the received data
            //  the message's op-code
            //  a boolean indicating if the message is complete
            // (as opposed to fragmented)
            string, op, fin in
            
            // The data parameter might be nil here if either a timeout
            // or a network error, such as the client disconnecting, occurred.
            // By default there is no timeout.
            guard let string = string else {
                // This block will be executed if, for example, the browser window is closed.
                print("Socket connection closed")
                RoomHandler.instance.usersList.removeValue(forKey: socket.name)
                socket.close()
                return
            }
            
            // Print some information to the console for to show the incoming messages.
            print("Read msg: \(string) op: \(op) fin: \(fin)")
            
            do {
                guard fin == true,
                    let json = try string.jsonDecode() as? [String: Any] else {
                        return
                }
                let messageRequest = MessageRequest(json: json)
                
                switch messageRequest.type {
                case MessageType.login.rawValue:
                    login(socket, messageRequest)
                    break
                case MessageType.offer.rawValue:
                    offer(socket, messageRequest)
                    break
                case MessageType.answer.rawValue:
                    answer(socket, messageRequest)
                    break
                case MessageType.candidate.rawValue:
                    candidate(socket, messageRequest)
                    break
                case MessageType.leave.rawValue:
                    leave(socket, messageRequest)
                    break
                default:
                    print("Error in connection")
                }
            } catch {
                print("Failed to decode JSON from Received Socket Message")
            }
            
            //Done working on this message? Loop back around and read the next message.
            self.handleSession(request: request, socket: socket)
        }
        
        func login (_ socket: WebSocket, _  messageRequest: MessageRequest) {

            let messageResponse = MessageRequest(json: nil)
            messageResponse.type = MessageType.login.rawValue
            if let userSocket = RoomHandler.instance.usersList[messageRequest.userName] {
                messageResponse.success = false
                do {
                    let jsonResponse = try messageResponse.jsonEncodedString()
                    userSocket.sendStringMessage(string: jsonResponse,
                                                 final: true,
                                                 completion: {
                                                    print("message: was sent by user: \(messageResponse.userName)")
                    })
                } catch {
                    
                }
            } else {
                socket.name = messageRequest.userName
                RoomHandler.instance.usersList[messageRequest.userName] = socket
                messageResponse.success = true
                do {
                    let jsonResponse = try messageResponse.jsonEncodedString()
                    socket.sendStringMessage(string: jsonResponse,
                                                 final: true,
                                                 completion: {
                                                    print("message: was sent by user: \(messageResponse.userName)")
                    })
                } catch {
                    
                }
            }
        }
        
        func offer (_ socket: WebSocket, _  messageRequest: MessageRequest) {
            if let peerSocket = RoomHandler.instance.usersList[messageRequest.peerUserName] {
                let messageResponse = MessageRequest(json: nil)
                messageResponse.type = MessageType.offer.rawValue
                messageResponse.offerSDP = messageRequest.offerSDP
                messageResponse.peerUserName = socket.name
                
                do {
                    let jsonResponse = try messageResponse.jsonEncodedString()
                    peerSocket.sendStringMessage(string: jsonResponse,
                                             final: true,
                                             completion: {
                                                print("Offer is sent to user: \(messageResponse.userName)")
                    })
                } catch {
                    
                }
            }
        }
        
        func answer (_ socket: WebSocket, _  messageRequest: MessageRequest) {
            if let peerSocket = RoomHandler.instance.usersList[messageRequest.peerUserName] {
                let messageResponse = MessageRequest(json: nil)
                messageResponse.type = MessageType.answer.rawValue
                messageResponse.answer = messageRequest.answer
                messageResponse.peerUserName = socket.name
                
                do {
                    let jsonResponse = try messageResponse.jsonEncodedString()
                    peerSocket.sendStringMessage(string: jsonResponse,
                                                 final: true,
                                                 completion: {
                                                    print("answer is sent to user: \(messageResponse.userName)")
                    })
                } catch {
                    
                }
            }
        }
        
        func candidate (_ socket: WebSocket, _  messageRequest: MessageRequest) {            
            if let peerSocket = RoomHandler.instance.usersList[messageRequest.peerUserName] {
                let messageResponse = MessageRequest(json: nil)
                messageResponse.type = MessageType.candidate.rawValue
                messageResponse.iceCandidate = messageRequest.iceCandidate
                do {
                    let jsonResponse = try messageResponse.jsonEncodedString()
                    peerSocket.sendStringMessage(string: jsonResponse,
                                                 final: true,
                                                 completion: {
                                                    print("candidate is sent to user: \(messageResponse.userName)")
                    })
                } catch {
                    
                }
            }
        }
        
        func leave (_ socket: WebSocket, _  messageRequest: MessageRequest) {
            if let peerSocket = RoomHandler.instance.usersList[messageRequest.peerUserName] {
                let messageResponse = MessageRequest(json: nil)
                messageResponse.type = MessageType.leave.rawValue
                do {
                    let jsonResponse = try messageResponse.jsonEncodedString()
                    peerSocket.sendStringMessage(string: jsonResponse,
                                                 final: true,
                                                 completion: {
                                                    print("leave is sent to user: \(messageResponse.userName)")
                    })
                } catch {
                    
                }
            }
        }
    }
}



