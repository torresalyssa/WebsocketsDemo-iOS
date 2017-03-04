//
//  SocketIOManager.swift
//  WebsocketsDemo-iOS
//
//  Created by Alyssa Torres on 3/1/17.
//  Copyright © 2017 Ourglass. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    
    static let sharedInstance = SocketIOManager()
    
    var socket = SocketIOClient(socketURL: URL(string: "http://129.65.48.86:3000")!)
    
    override init() {
        super.init()
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func connectToServerWithNickname(nickname: String) {
        socket.emit("connectUser", nickname)
    }
    
    func getUserList(handler: @escaping ([[String: AnyObject]]) -> Void) {
        // Note: socket.on() closure will be invoked automatically every time the server sends the user list
        socket.on("userList") { (dataArray, ack) -> Void in
            handler(dataArray[0] as! [[String: AnyObject]])
        }
    }
    
    func exitChatWithNickname(nickname: String) {
        socket.emit("exitUser", nickname)
    }
    
    func sendMessage(message: String, withNickname nickname: String) {
        socket.emit("chatMessage", nickname, message)
    }
    
    func getMessage(handler: @escaping ([String: String]) -> Void) {
        socket.on("newChatMessage") { (dataArray, ack) -> Void in
            var messageDict = [String: String]()
            messageDict["nickname"] = dataArray[0] as? String
            messageDict["message"] = dataArray[1] as? String
            messageDict["date"] = dataArray[2] as? String
            
            handler(messageDict)
        }
    }
}
