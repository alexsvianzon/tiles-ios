//
//  TutorialLevelsView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/28/26.
//

import SwiftUI

struct TutorialLevelsView: View {
    let repo: LevelRepositoryManager = LevelRepositoryManager()
    var state: GameState = GameState()
    @State var storage: Storage
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(repo.get_local("tutorial")) { level in
                    NavigationLink(destination: GameView(
                        controller: GameController(
                            state,
                            level: level,
                            storage: storage
                        ),
                        state: state
                    )) {
                        LevelPreviewView(
                            level: level,
                            storage: storage
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    TutorialLevelsView(storage: Storage())
}
