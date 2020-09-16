//
//  File.swift
//  
//
//  Created by Aleix Diaz Baggerman on 16/09/2020.
//

import Foundation

enum MessageType {
    case joinRoom
    case createRoom
}

extension MessageType: Codable {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .joinRoom
        case 1:
            self = .createRoom
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .joinRoom:
            try container.encode(0, forKey: .rawValue)
        case .createRoom:
            try container.encode(1, forKey: .rawValue)
        }
    }
    
}
