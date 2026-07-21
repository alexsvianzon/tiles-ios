//
//  SwiftUIWKWebView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/21/26.
//

import SwiftUI
import WebKit

struct SwiftUIWKWebView: UIViewRepresentable {
    let url: URL
    let gameController: GameController
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        
        contentController.add(context.coordinator, name: "game")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    class Coordinator: NSObject, WKScriptMessageHandler {
        var parent: SwiftUIWKWebView

        init(_ parent: SwiftUIWKWebView) {
            self.parent = parent
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "game" else { return }
            
            
        }
    }
}

#Preview {
    let htmlURL = Bundle.main.url(forResource: "index", withExtension: "html")!
    SwiftUIWKWebView(url: htmlURL, gameController: GameController(gameState: GameState()))
}
