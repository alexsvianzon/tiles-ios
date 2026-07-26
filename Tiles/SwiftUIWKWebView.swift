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
    var bridge: JSBridge
    
    init(bridge: JSBridge) {
        url = Bundle.main.url(forResource: "index", withExtension: "html")!
        
        self.bridge = bridge
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, bridge: bridge)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        
        contentController.add(context.coordinator, name: "game")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.load(URLRequest(url: url))
        bridge.attach(webView)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    class Coordinator: NSObject, WKScriptMessageHandler {
        var parent: SwiftUIWKWebView
        var bridge: JSBridge

        init(_ parent: SwiftUIWKWebView, bridge: JSBridge) {
            self.parent = parent
            self.bridge = bridge
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "game" else { return }
            
            bridge.receive(message.body as! String)
        }
    }
}
