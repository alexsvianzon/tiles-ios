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
    
    var onEventReceived: ((String, [String : Int]) -> Void)?
    
    func receive(_ payload: String) {
        do {
            let jsonData = payload.data(using: .utf8)!
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                var event: String = ""
                var data: [String : Int] = [:]
                
                if let event_key = json["event"] as? String {
                    event = event_key
                }
                
                if let data_key = json["data"] as? [String : Int] {
                    data = data_key
                }
                
                onEventReceived?(event, data)
            }
        } catch {
            print("Error prasing JSON: \(error.localizedDescription)")
        }
    }
}
