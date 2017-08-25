//
//  GameService.swift
//  kitura_test
//
//  Created by George Alegre on 8/2/17.
//
//

import Foundation
import KituraWebSocket
import LoggerAPI

class GameService: WebSocketService {
    // Game
    private var inputFileHandle: FileHandle?
    private var outputFileHandle: FileHandle?
    private var process: Process
    
    // Connections
    private var connections: [String: WebSocketConnection] = [:]
    
    init() {
        // Prepare the game
        process = Process()
        
        #if os(macOS)
            process.launchPath = "~/Developer/website/game"
        #else
            process.launchPath = "~/website/game"
        #endif
        
        let inputPipe = Pipe()
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardInput = inputPipe
        inputFileHandle = inputPipe.fileHandleForWriting
        outputFileHandle = outputPipe.fileHandleForReading
        
        #if os(macOS)
            outputFileHandle!.readabilityHandler = gameDidOutput
        #endif
        
        process.terminationHandler = gameEnded
    }
    
    deinit {
        process.terminate()
    }
    
    private func startGame() {
        #if os(macOS)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: .NSFileHandleDataAvailable, object: outputFileHandle, queue: OperationQueue.current, using: dataAvailable)
        
        outputFileHandle!.waitForDataInBackgroundAndNotify()
        #endif
        
        process.launch()
    }
    
    private func gameEnded(process: Process) {
        self.inputFileHandle = nil
        
        switch(process.terminationReason) {
        case .exit:
            Log.info("The game finished running.")
        case .uncaughtSignal:
            Log.error("The game unexpectedly ended with status code: \(process.terminationStatus).")
        }
    }
    
    #if os(macOS)
    @objc private func dataAvailable(notification: Notification) {
        let fileHandle: FileHandle = notification.object as! FileHandle
        let data = fileHandle.availableData
        if data.count > 1 {
            fileHandle.waitForDataInBackgroundAndNotify()
            let string = String(data: data, encoding: .utf8)!
            broadcast(string)
        }
    }
    #endif
    
    private func gameDidOutput(outputFileHandle: FileHandle) {
        let data = outputFileHandle.availableData
        if data.count > 1 {
            let output = String(data: data, encoding: .utf8)!
            broadcast(output)
        }
    }
    
    public func connected(connection: WebSocketConnection) {
        Log.info("New connection from \(connection.id).")
        broadcast("New client connected with id: \(connection.id).", from: connection)
        connections[connection.id] = connection
        
        if !process.isRunning {
            startGame()
        }
    }
    
    public func disconnected(connection: WebSocketConnection, reason: WebSocketCloseReasonCode) {
        Log.info("Disconnected from \(connection.id).")
        connections.removeValue(forKey: connection.id)
        broadcast("Client with id: \(connection.id) disconnected.", from: connection)
    }
    
    public func received(message: Data, from: WebSocketConnection) {
        from.close(reason: .invalidDataType, description: "Chat-Server only accepts text messages")
        connections.removeValue(forKey: from.id)
    }
    
    public func received(message: String, from: WebSocketConnection) {
        Log.info("Got \(message) from \(from.id).")
        inputFileHandle?.write(("\(message)\n").data(using: .utf8)!)
        broadcast(message, from: from)
    }
    
    private func broadcast(_ message: String, from sender: WebSocketConnection? = nil) {
        for client in connections.values where client.id != sender?.id {
            client.send(message: message)
        }
    }
}
