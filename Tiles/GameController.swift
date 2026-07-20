//
//  GameController.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/18/26.
//

import SwiftUI
import WebKit

@Observable
class GameController {
    var page = WebPage()
    
    init() {
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
    }
}
