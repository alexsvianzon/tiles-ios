//
//  ContentView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/18/26.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var game: GameController = GameController()
    
    var body: some View {
        Text("Tiles!")
            .font(.largeTitle)
        
        WebView(game.page)
            .aspectRatio(1.0, contentMode: .fit)
        
        HStack {
            Button() {
                Task {
                    await game.emit(event: "reset")
                }
            } label: {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.large)
            }
            
            Spacer()
            
            VStack {
                Button() {
                    Task {
                        await game.emit(event: "up", data: "")
                    }
                } label: {
                    Image(systemName: "arrowshape.up.fill")
                        .foregroundStyle(.blue)
                        .imageScale(.large)
                }
                
                HStack {
                    Button() {
                        Task {
                            await game.emit(event: "left", data: "")
                        }
                    } label: {
                        Image(systemName: "arrowshape.left.fill")
                            .foregroundStyle(.blue)
                            .imageScale(.large)
                    }
                    
                    Button() {
                        Task {
                            await game.emit(event: "right", data: "")
                        }
                    } label: {
                        Image(systemName: "arrowshape.right.fill")
                            .foregroundStyle(.blue)
                            .imageScale(.large)
                    }
                }
                
                Button() {
                    Task {
                        await game.emit(event: "down", data: "")
                    }
                } label: {
                    Image(systemName: "arrowshape.down.fill")
                        .foregroundStyle(.blue)
                        .imageScale(.large)
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
