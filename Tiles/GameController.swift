//
//  GameController.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/18/26.
//

import SwiftUI
import WebKit

struct Level {
    var Id: UInt = 0
    var tileData: Array<String> = []
}

struct GameState {
    var isFalling: Bool = false
    var isBeaten: Bool = false
    var moveCount: UInt = 0
    var currentLevel: Level = Level()
}

enum GameInput {
    case RESET
    case UP
    case DOWN
    case LEFT
    case RIGHT
}

enum GameOutput {
    case FINISHED
    case ERROR
}

class GameController {
    var page = WebPage()
    var gameState: GameState
    
    init(gameState: GameState) {
        let htmlURL = Bundle.main.url(forResource: "index", withExtension: "html")!
        let baseURL = htmlURL.deletingLastPathComponent()
        
        var htmlString: String?
        do {
            htmlString = try String.init(contentsOf: htmlURL, encoding: .utf8)
        } catch {
            print("Could not find get string from HTML, error: \(error)")
        }
        
        page.load(html: htmlString!, baseURL: baseURL)
        
        page.isInspectable = true
        self.gameState = gameState
    }
    
    @MainActor
    public func emit(event: GameInput) async {
        do {
            var event_string: String
            
            switch event {
            case .UP:
                event_string = "up"
                gameState.moveCount += 1
                
            case .DOWN:
                event_string = "down"
                gameState.moveCount += 1
                
            case .LEFT:
                event_string = "left"
                gameState.moveCount += 1
                
            case .RIGHT:
                event_string = "right"
                gameState.moveCount += 1
                
            case .RESET:
                event_string = "reset"
                gameState.moveCount = 0
            }
            
            try await page.callJavaScript(
                """
                game.bridge.receive(event);
                """,
                arguments: ["event": event_string]
            )
        } catch {
            print("\(error)")
        }
    }
}
