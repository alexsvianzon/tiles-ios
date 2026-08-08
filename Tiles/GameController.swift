//
//  GameController.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/18/26.
//

import SwiftUI
import WebKit

enum GameInput {
    case reset
    case up
    case down
    case left
    case right
    case inject_level
}

@Observable
class GameState {
    var levelCompleted: Bool = false
    var isFalling: Bool = false
    var time: Int = 0
}

class GameController {
    var level: Level
    var bridge: JSBridge = JSBridge()
    var state: GameState
    var storage: Storage
    var playTime: TimeInterval = 0.0
    
    init(_ state: GameState, level: Level, storage: Storage) {
        self.state = state
        self.level = level
        self.storage = storage
    }
    
    func initialize() {
        bridge.onEventReceived = { [weak self] event in
            guard let self = self else { return }
            
            switch event as String {
            case "finished":
                self.state.levelCompleted = true
                
                var data = storage.levelSaveData ?? [:]
                data["\(level.level_id)", default: [:]]["completed"] = 1
                data["\(level.level_id)", default: [:]]["time"] = state.time
                
                storage.levelSaveData = data
            case "player_fell":
                self.state.isFalling = true
            case "did_reset":
                self.state.isFalling = false
            case "game_loaded":
                self.emit(.inject_level)
                
                var data = storage.levelSaveData ?? [:]
                if data["\(level.level_id)", default: [:]]["completed"] == nil {
                    data["\(level.level_id)", default: [:]]["completed"] = 0
                }
                
                print(data)
                storage.levelSaveData = data
            default:
                print(event)
                break
            }
        }
    }
    
    func emit(_ input: GameInput) {
        var event: String = ""
        var data: String = ""
        switch input {
        case .up:
            event = "up"
        case .down:
            event = "down"
        case .left:
            event = "left"
        case .right:
            event = "right"
        case .reset:
            event = "reset"
        case .inject_level:
            event = "load_level"
            
            data = """
            {"level":[
            """
            for row in level.tileData {
                data.append("\"\(row)\",")
            }
            
            data.removeLast()
            data.append("]}")
        }
        
        let function = """
        game.bridge.receive("\(event)", '\(data)');
        """
        
        bridge.emit(function)
    }
}
