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
}

struct Level {
    var Id: UInt = 0
    var tileData: Array<String> = []
}

@Observable
class GameState {
    var levelCompleted: Bool = false
    var isFalling: Bool = false
}

class GameController {
    var currentLevel: Level = Level()
    var bridge: JSBridge = JSBridge()
    var state: GameState
    
    init(_ state: GameState) {
        self.state = state
    }
    
    func attachBridgeReceiver() {
        bridge.onEventReceived = { [weak self] event in
            guard let self = self else { return }
            
            switch event as String {
            case "finished":
                self.state.levelCompleted = true
            case "player_fell":
                self.state.isFalling = true
            case "did_reset":
                self.state.isFalling = false
            default:
                print(event)
                break
            }
        }
    }
    
    func emit(_ input: GameInput) {
        var event: String = ""
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
        }
        
        let function = """
        game.bridge.receive("\(event)")
        """
        
        bridge.emit(function)
    }
}
