//
//  CoreLevelsView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/30/26.
//

import SwiftUI

struct CoreLevelsView: View {
    let repo: LevelRepositoryManager = LevelRepositoryManager()
    var state: GameState = GameState()
    var storage: Storage
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack() {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Text("Level Difficulties")
                        }
                        
                        HStack {
                            Group {
                                Text("Tutorial")
                                Image(systemName: "diamond.fill")
                                    .foregroundStyle(.blue)
                            }
                            
                            Group {
                                Text("Easy")
                                Image(systemName: "diamond.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                        
                        
                        HStack {
                            Group {
                                Text("Medium")
                                Image(systemName: "diamond.fill")
                                    .foregroundStyle(.yellow)
                            }
                            
                            Group {
                                Text("Difficult")
                                Image(systemName: "diamond.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                }
                .padding()
                .frame(maxWidth: .infinity)
                
                ForEach(repo.get_local("core")) { level in
                    NavigationLink(destination: GameView(
                        controller: GameController(
                            state,
                            level: level,
                            storage: storage
                        ),
                        state: state
                    )) {
                        LevelPreviewView(level: level,
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
    CoreLevelsView(storage: Storage())
}
