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
        case .wordCompleted:
            wordCompleted(socketData: socketData, ws: ws)
            break
        case .matchWin:
            matchWin(socketData: socketData, ws: ws)
        default:
            break
        }
    }
    
    private func joinRoom(socketData: SocketData<String>, ws: WebSocket) {
        let player = Player(id: socketData.clientID, socket: ws)
        guard let roomID = socketData.data else {return}
        if let room = RoomManager.shared.addPlayerToRoom(roomID: roomID, player: player) {
            sendMessage(ws: ws, socketData: SocketData<[String]>(clientID: socketData.clientID, messageType: .joinRoom, data: room.words))
        } else {
            sendMessage(ws: ws, socketData: SocketData<[String]>(clientID: socketData.clientID, messageType: .joinRoomError))
        }
    }
    
    private func createRoom(socketData: SocketData<String>, ws: WebSocket) {
        let player = Player(id: socketData.clientID, socket: ws)
        guard let roomID = socketData.data else {return}
        let newRoom = Room(id: roomID, words: ["1","2"])
        newRoom.players.append(player)
        RoomManager.shared.addRoom(room: newRoom)
        sendMessage(ws: ws, socketData: SocketData<[String]>(clientID: socketData.clientID, messageType: .createRoom, data: newRoom.words))
    }
    
    private func wordCompleted(socketData: SocketData<String>, ws: WebSocket) {
        guard let opponentPlayer = getOpponentPlayer(clientID: socketData.clientID) else {return}
        let data = SocketData<String>(clientID: opponentPlayer.id, messageType: .wordCompleted)
        sendMessage(ws: opponentPlayer.socket, socketData: data)
    }

    private func matchWin(socketData: SocketData<String>, ws: WebSocket) {
        guard let room = RoomManager.shared.roomFor(playerID: socketData.clientID) else {return}
        guard let opponentPlayer = getOpponentPlayer(clientID: socketData.clientID) else {return}
        let data = SocketData<String>(clientID: opponentPlayer.id, messageType: .matchLose)
        sendMessage(ws: opponentPlayer.socket, socketData: data)
        closeRoom(room: room)
    }
    
    private func getOpponentPlayer(clientID: String) -> Player? {
        guard let room = RoomManager.shared.roomFor(playerID: clientID) else {return nil}
        return room.players.filter({return $0.id != clientID}).first
    }
    
    private func closeRoom(room: Room) {
        RoomManager.shared.removeRoomWith(id: room.id)
        room.players.forEach({$0.socket.close()})
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
