//
//  File.swift
//  
//
//  Created by Aleix Diaz Baggerman on 16/09/2020.
//

import Foundation

import Vapor

func socketHandler(_ app: Application) throws {

    let socketController = SocketConnectionController()
    
    //MARK: New connection
    app.webSocket("connect") { req, ws in
        
        ws.send(UUID().uuidString)
        
        //MARK: Recive message
        ws.onText(socketController.handleMessage)
    }
    
}
