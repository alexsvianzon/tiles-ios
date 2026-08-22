//
//  CoreLevelsView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/30/26.
//

import SwiftUI

struct CoreLevelsView: View {
    let repo = LevelRepositoryManager()
    @Binding var storage: Storage
    @State private var levelSaveData: [String: [String: Int]] = [:]
    
    var body: some View {
        ScrollView {
            ForEach(repo.get_local("core")) { level in
                NavigationLink {
                    let state = GameState()
                    GameView(
                        controller: GameController(
                            state,
                            level: level,
                            storage: $storage
                        ),
                        state: state
                    )
                } label: {
                    LevelPreviewView(level: level, levelSaveData: levelSaveData)
                }
                .buttonStyle(.plain)
            }
        }
        .onAppear {
            levelSaveData = storage.levelSaveData ?? [:]
        }
    }
}
