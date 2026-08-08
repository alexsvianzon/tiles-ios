//
//  GameView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/18/26.
//

import SwiftUI
import WebKit
internal import Combine

struct ActionButton: ViewModifier {
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
    func actionButton() -> some View {
        modifier(ActionButton())
    }
}


struct GameView: View {
    @Environment(\.dismiss) var dismiss
    let controller: GameController
    @State var state: GameState
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            VStack {
                SwiftUIWKWebView(bridge: controller.bridge)
                    .aspectRatio(1.0, contentMode: .fit)
                    .onAppear {
                        controller.initialize()
                        state.time = 0
                    }
                
                VStack {
                    Button() {
                        controller.emit(.up)
                    } label: {
                        Image(systemName: "chevron.up")
                            .actionButton()
                    }
                    .disabled(state.isFalling)
                    
                    HStack {
                        Button() {
                            controller.emit(.left)
                        } label: {
                            Image(systemName: "chevron.left")
                                .actionButton()
                        }
                        
                        Button() {
                            controller.emit(.reset)
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .actionButton()
                        }
                        
                        Button() {
                            controller.emit(.right)
                        } label: {
                            Image(systemName: "chevron.right")
                                .actionButton()
                        }
                    }
                    
                    Button() {
                        controller.emit(.down)
                    } label: {
                        Image(systemName: "chevron.down")
                            .actionButton()
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
                            state.levelCompleted = false
                            dismiss()
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
            .onReceive(timer) { _ in
                state.time += 1
            }
            .toolbar {
                ToolbarItem {
                    Text(formatTime(state.time))
                        .font(.system(.title, design: .monospaced))
                        .padding()
                }
            }
        }
    }
}

#Preview {
    let state = GameState()
    let controller = GameController(state, level: Level(), storage: Storage())
    GameView(controller: controller, state: state)
}
