//
//  File.swift
//  
//
//  Created by Aleix Diaz Baggerman on 16/09/2020.
//

import Vapor

final class Player {
    
    var id: String!
    var socket: WebSocket!
    
    init(id: String, socket: WebSocket) {
        self.id = id
        self.socket = socket
    }
    
}
