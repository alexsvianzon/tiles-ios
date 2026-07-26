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
    @Environment(\.dismiss) var dismiss
    let controller: GameController
    @State var state: GameState
    
    var body: some View {
        SwiftUIWKWebView(bridge: controller.bridge)
            .aspectRatio(1.0, contentMode: .fit)
            .onAppear {
                controller.attachBridgeReceiver()
            }
        
        VStack {
            Button() {
                controller.emit(.up)
            } label: {
                Image(systemName: "chevron.up")
                    .playerButtonModifier()
            }
            .disabled(state.isFalling)
        
            HStack {
                Button() {
                    controller.emit(.left)
                } label: {
                    Image(systemName: "chevron.left")
                        .playerButtonModifier()
                }
                
                Button() {
                    controller.emit(.reset)
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .playerButtonModifier()
                }
                
                Button() {
                    controller.emit(.right)
                } label: {
                    Image(systemName: "chevron.right")
                        .playerButtonModifier()
                }
            }
            
            Button() {
                controller.emit(.down)
            } label: {
                Image(systemName: "chevron.down")
                    .playerButtonModifier()
            }
        }
        .padding()
        .sheet(isPresented: $state.levelCompleted) {
            VStack {
                Text("Level Beaten!")
                    .font(Font.custom("NewYorkExtraLarge-Bold", size: 32))
                    .padding()
                
                Spacer()
                
                Button() {
                    
                } label: {
                    Text("Back to Levels")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                
                HStack {
                    Button() {
                        
                    } label: {
                        Text("Stats")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                }
            }
            .padding()
            .presentationDetents([.medium])
        }
    }
}

#Preview {
    let state = GameState()
    let controller = GameController(state)
    GameView(controller: controller, state: state)
}
