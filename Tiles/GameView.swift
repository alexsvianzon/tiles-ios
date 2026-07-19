//
//  GameView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/18/26.
//

import SwiftUI
import WebKit

struct GameView: View {
    @State private var page = WebPage()
    
    init() {
        let htmlURL = Bundle.main.url(forResource: "index", withExtension: "html")!
        let baseURL = htmlURL.deletingLastPathComponent()
        var htmlString: String?
        
        print(htmlURL)
        print(baseURL)
        
        do {
            htmlString = try String.init(contentsOf: htmlURL, encoding: .utf8)
        } catch {
            print("Could not find get string from HTML, error: \(error)")
        }
        
        page.load(html: htmlString!, baseURL: baseURL)
    }
    
    var body: some View {
        WebView(page)
            .onAppear {
                page.isInspectable = true
            }
        
        Button() {
            
        } label: {
            Image(systemName: "info.bubble.fill")
                .imageScale(.large)
        }
    }
}

#Preview {
    GameView()
}
