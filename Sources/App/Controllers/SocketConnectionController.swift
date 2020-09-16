//
//  File.swift
//  
//
//  Created by Aleix Diaz Baggerman on 16/09/2020.
//

import Vapor

final class SocketConnectionController {
    
    func handleMessage(ws: WebSocket, text: String) {
        guard let socketData: SocketData<String> = try? parseJSON(text: text) else {
            return
        }

        switch socketData.messageType {
        case .joinRoom:
            joinRoom(socketData: socketData, ws: ws)
            break
        case .createRoom:
            createRoom(socketData: socketData, ws: ws)
            break
        default:
            break
        }
    }
    
    private func joinRoom(socketData: SocketData<String>, ws: WebSocket) {
        let player = Player(id: socketData.clientID, socket: ws)
        guard let roomID = socketData.data else {return}
        RoomManager.shared.addPlayerToRoom(roomID: roomID, player: player)
    }
    
    private func createRoom(socketData: SocketData<String>, ws: WebSocket) {
        let player = Player(id: socketData.clientID, socket: ws)
        guard let roomID = socketData.data else {return}
        let newRoom = Room(id: roomID, words: ["1","2"])
        newRoom.players.append(player)
        RoomManager.shared.addRoom(room: newRoom)
    }
    
    private func sendMessage<T>(ws: WebSocket, socketData: SocketData<T>) {
        guard let data = try? JSONEncoder().encode(socketData) else {return}
        guard let stringJSON = String(data: data, encoding: .utf8) else {return}
        ws.send(stringJSON)
    }
    
    private func parseJSON<T>(text: String) throws -> T? where T:Decodable {
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        let object: T = try JSONDecoder().decode(T.self, from: data)
        return object
    }
    
}
