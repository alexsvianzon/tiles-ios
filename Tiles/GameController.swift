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
    var showLevelCompleteScreen: Bool = false
    var isFalling: Bool = false
    var time: Int = 0
    var moves: Int = 0
    var resets: Int = 0
    var levelHasHint: Bool = false
}

enum GameDifficulty: Int, CaseIterable, Identifiable {
    case beginner
    case standard
    case expert
    
    var id: Self { self }
    var stringValue: String {
        switch self {
        case .beginner: return "Beginner"
        case .standard: return "Standard"
        case .expert: return "Expert"
        }
    }
}

class GameController {
    var level: Level
    var bridge: JSBridge = JSBridge()
    var state: GameState
    @Binding var storage: Storage
    var playTime: TimeInterval = 0.0
    
    init(_ state: GameState, level: Level, storage: Binding<Storage>) {
        self.state = state
        self.level = level
        self._storage = storage
    }
    
    func initialize() {
        bridge.onEventReceived = { [weak self] event, data in
            guard let self = self else { return }
            
            switch event as String {
            case "finished":
                var saveData = storage.levelSaveData ?? [:]
                saveData["\(level.level_id)", default: [:]]["completed"] = 1
                
                if state.time < saveData["\(level.level_id)", default: [:]]["time"] ?? .max {
                    saveData["\(level.level_id)", default: [:]]["time"] = state.time
                }
                
                if data["moves"] ?? .max < saveData["\(level.level_id)", default: [:]]["moves"] ?? .max {
                    saveData["\(level.level_id)", default: [:]]["moves"] = data["moves"]
                }
                
                if state.resets < saveData["\(level.level_id)", default: [:]]["resets"] ?? .max {
                    saveData["\(level.level_id)", default: [:]]["resets"] = state.resets
                }
                
                state.moves = data["moves"] ?? 0
                
                storage.levelSaveData = saveData
                self.state.levelCompleted = true
                self.state.showLevelCompleteScreen = true
            case "player_fell":
                self.state.isFalling = true
            case "did_reset":
                self.state.isFalling = false
                self.state.resets += 1
            case "game_loaded":
                self.emit(.inject_level)
                
                var data = storage.levelSaveData ?? [:]
                if data["\(level.level_id)", default: [:]]["completed"] == nil {
                    data["\(level.level_id)", default: [:]]["completed"] = 0
                }
                
                data["\(level.level_id)", default: [:]]["attempts", default: 0] += 1
                
                storage.levelSaveData = data
            default:
                print(event)
                break
            }
        }
        
        state.levelHasHint = level.hint != nil ? true : false
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
