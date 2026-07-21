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
    var currentLevel: Level = Level()
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
    
    /*
     internal version of emit that runs alongside public calls
     
     mainly used for updating
     */
    
    @MainActor
    private func _emit() async {
        do {
            let result = try await page.callJavaScript(
                """
                return game.player.currentTile;
                """
            )
            
            if (result! as! String == "f") {
                gameState.isFalling = true
            } else {
                gameState.isFalling = false
            }
        } catch {
            print("\(error)")
        }
    }
    
    @MainActor
    public func emit(event: String, data: String = "") async {
        do {
            if (data == "") {
                try await page.callJavaScript(
                    """
                    game.bridge.receive(event);
                    """,
                    arguments: ["event": event]
                )
            } else {
                try await page.callJavaScript(
                    """
                    game.bridge.receive(event, data);
                    """,
                    arguments: ["event": event, "data": data]
                )
            }
        } catch {
            print("\(error)")
        }
        
        await _emit()
    }
}
