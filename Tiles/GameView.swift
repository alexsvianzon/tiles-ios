//
//  GameView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/18/26.
//

import SwiftUI
import WebKit
import TipKit
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

struct LevelCompletedSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State var state: GameState
    let onBackToLevels: () -> Void
    
    var body: some View {
        VStack {
            Text("Level Beaten!")
                .font(Font.custom("NewYorkExtraLarge-Bold", size: 32))
                .padding()
            
            HStack {
                Text("Time:")
                    .font(.title2)
                
                Text(formatTime(state.time))
                    .bold()
                    .font(.title)
            }
            
            HStack {
                Text("Moves:")
                    .font(.title2)
                
                Text(String(state.moves))
                    .bold()
                    .font(.title)
            }
            
            HStack {
                Text("Resets:")
                    .font(.title2)
                
                Text(String(state.resets))
                    .bold()
                    .font(.title)
            }
            
            Spacer()
            
            Button() {
                state.levelCompleted = false
                dismiss()
                onBackToLevels()
            } label: {
                Text("Back to Levels")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .padding()
    }
}

struct GuideTip: Tip {
    var title: Text {
        Text("Open the Guide")
    }


    var message: Text? {
        Text("Learn the core of the game in the ? menu.")
    }


    var image: Image? {
        Image(systemName: "book.pages")
    }
}

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    let controller: GameController
    @State var state: GameState
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var showingHint = false
    @State private var showingGuide = false
    var tip = GuideTip()
    
    var body: some View {
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
            .sheet(isPresented: $state.showLevelCompleteScreen) {
                LevelCompletedSheetView(state: state) {
                    dismiss()
                }
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingGuide) {
                GuideView()
                    .presentationDetents([.medium])
            }
        }
        .onReceive(timer) { _ in
            if !state.levelCompleted {
                state.time += 1
            }
        }
        .toolbar {
            ToolbarItemGroup {
                if state.levelHasHint {
                    Button {
                        showingHint = true
                    } label: {
                        Image(systemName: "info")
                    }
                    .alert("Hint", isPresented: $showingHint) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(controller.level.hint ?? "No hint could be found")
                    }
                }
                
                Button {
                    showingGuide = true
                } label: {
                    Image(systemName: "questionmark")
                }
                .popoverTip(tip)
            }
            
            ToolbarSpacer()
            
            ToolbarItem {
                Text(formatTime(state.time))
                    .font(.system(.title, design: .monospaced))
                    .padding()
            }
        }
    }
}

#Preview {
    @Previewable @State var storage = Storage()
    let state = GameState()
    let controller = GameController(state, level: Level(), storage: $storage)
    GameView(controller: controller, state: state)
}
