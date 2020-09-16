//
//  File.swift
//  
//
//  Created by Aleix Diaz Baggerman on 16/09/2020.
//

import Vapor

final class SocketConnectionController {
    
    func handleMessage(ws: WebSocket, text: String) {
        guard let socketData: SocketData = try? parseJSON(text: text) else {
            return
        }

        switch socketData.messageType {
        case .joinRoom:
            joinRoom(clientID: socketData.clientID)
            break
        case .createRoom:
            createRoom(clientID: socketData.clientID)
            break
        default:
            break
        }
    }
    
    private func joinRoom(clientID: String) {
        
    }
    
    private func createRoom(clientID: String) {
    
    }
    
    private func parseJSON<T>(text: String) throws -> T? where T:Decodable {
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        let object: T = try JSONDecoder().decode(T.self, from: data)
        return object
    }
    
}
