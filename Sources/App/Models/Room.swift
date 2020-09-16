//
//  File.swift
//  
//
//  Created by Aleix Diaz Baggerman on 16/09/2020.
//

import Foundation

class Room {
    var players: [Player] = []
    var words: [String]!
    var id: String!
    
    init(id: String, words: [String]) {
        self.id = id
        self.words = words
    }
}
