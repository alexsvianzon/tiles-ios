//
//  LevelPreviewView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/31/26.
//

import SwiftUI

struct LevelPreviewView: View {
    let level: Level
    @State var storage: Storage
    
    var body: some View {
        VStack() {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text(level.name)
                    
                    Spacer()
                    
                    Image(systemName: "play.fill")
                }
                
                if storage.levelSaveData?["\(level.level_id)"]?["completed"] == 1 {
                    LazyVStack {
                        Text("Completed")
                            .bold()
                            .foregroundStyle(.green)
                        
                        let totalSeconds = storage.levelSaveData?["\(level.level_id)"]?["time"] as? Int ?? 0
                        let formattedTime = formatTime(totalSeconds)
                        
                        Text(formattedTime)
                            .bold()
                            .foregroundStyle(.green)
                    }
                }
                
                HStack {
                    Text("Level \(String(level.level_id))")
                    Image(systemName: "diamond.fill")
                        .foregroundStyle(Color(level.difficulty.color))
                    
                    Spacer()
                    
                    Text("\(level.tileData.count)x\(level.tileData.count)")
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    LevelPreviewView(level: Level(), storage: Storage())
}
