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
    
    func addPlayerToRoom(roomID: String, player: Player) {
        guard let room = self.rooms.filter({return $0.id == roomID}).first else {return}
        guard room.players.count < 2 else {return}
        room.players.append(player)
    }
    
}
