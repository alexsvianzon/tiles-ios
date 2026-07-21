//
//  GameView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/18/26.
//

import SwiftUI
import WebKit

struct PlayerButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .foregroundColor(.blue)
            .frame(width: 48, height: 48)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 2)
            )
    }
}

extension View {
    func playerButtonModifier() -> some View {
        modifier(PlayerButtonModifier())
    }
}


struct GameView: View {
    @State private var gameState: GameState
    private var game: GameController
    
    init() {
        let initGameState = GameState()
        gameState = initGameState
        game = GameController(gameState: initGameState)
    }
    
    var body: some View {
        Text("Demo Level")
            .font(Font.custom("NewYorkExtraLarge-Bold", size: 42))
        
        WebView(game.page)
            .aspectRatio(1.0, contentMode: .fit)
        
        VStack {
            Button() {
                Task {
                    await game.emit(event: "up", data: "")
                }
            } label: {
                Image(systemName: "arrowshape.up.fill")
                    .playerButtonModifier()
            }
        
            HStack {
                Button() {
                    Task {
                        await game.emit(event: "left", data: "")
                    }
                } label: {
                    Image(systemName: "arrowshape.left.fill")
                        .playerButtonModifier()
                }
                
                Button() {
                    Task {
                        await game.emit(event: "reset")
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .playerButtonModifier()
                }
                
                Button() {
                    Task {
                        await game.emit(event: "right", data: "")
                    }
                } label: {
                    Image(systemName: "arrowshape.right.fill")
                        .playerButtonModifier()
                }
            }
            
            Button() {
                Task {
                    await game.emit(event: "down", data: "")
                }
            } label: {
                Image(systemName: "arrowshape.down.fill")
                    .playerButtonModifier()
            }
        }
        .padding()
    }
}

#Preview {
    GameView()
}
