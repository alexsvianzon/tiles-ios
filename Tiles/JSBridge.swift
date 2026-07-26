//
//  JSBridge.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/22/26.
//

import WebKit
import Foundation

class JSBridge {
    var webView: WKWebView?
    var event_queue: Array<String> = []
    
    func attach(_ webView: WKWebView) {
        self.webView = webView
    }
    
    func emit(_ function: String) {
        guard let webView = webView else {
            return
        }
        
        webView.callAsyncJavaScript(
            function,
            in: nil,
            in: .page
        )
    }
    
    var onEventReceived: ((String) -> Void)?
    
    func receive(_ event: String) {
        do {
            let jsonData = event.data(using: .utf8)!
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                if let event_key = json["event"] as? String {
                    onEventReceived?(event_key)
                }
            }
        } catch {
            print("Error prasing JSON: \(error.localizedDescription)")
        }
    }
}
