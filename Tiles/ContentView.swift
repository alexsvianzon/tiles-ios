//
//  ContentView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/18/26.
//

import SwiftUI
import WebKit

struct ContentView: View {
    var body: some View {
        Text("Tiles!")
            .font(.largeTitle)
        
        GameView()
        
        VStack {
            Button() {
                
            } label: {
                Image(systemName: "arrowshape.up.fill")
                    .foregroundStyle(.blue)
                    .imageScale(.large)
            }
            
            HStack {
                Button() {
                    
                } label: {
                    Image(systemName: "arrowshape.left.fill")
                        .foregroundStyle(.blue)
                        .imageScale(.large)
                }
                
                Button() {
                    
                } label: {
                    Image(systemName: "arrowshape.right.fill")
                        .foregroundStyle(.blue)
                        .imageScale(.large)
                }
            }
            
            Button() {
                
            } label: {
                Image(systemName: "arrowshape.down.fill")
                    .foregroundStyle(.blue)
                    .imageScale(.large)
            }
        }
    }
}

#Preview {
    ContentView()
}
