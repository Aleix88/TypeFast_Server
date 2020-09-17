//
//  File.swift
//  
//
//  Created by Aleix Diaz Baggerman on 16/09/2020.
//

import Foundation

class RoomManager {
    
    static var shared = RoomManager()
    
    private var rooms: [Room] = []
    
    private init() {}
    
    func addRoom(room: Room) {
        self.rooms.append(room)
    }
    
    func addPlayerToRoom(roomID: String, player: Player) -> Room? {
        guard let room = self.rooms.filter({return $0.id == roomID}).first else {return nil}
        guard room.players.count < 2 else {return nil}
        room.players.append(player)
        return room
    }
    
    func roomFor(playerID: String) -> Room? {
        return rooms.filter({return $0.players.contains(where: {player in player.id == playerID})}).first
    }
    
    func removeRoomWith(id: String) {
        self.rooms = self.rooms.filter({$0.id != id})
    }
}
