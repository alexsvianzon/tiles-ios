//
//  LevelPreviewView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/31/26.
//

import SwiftUI

struct LevelPreviewView: View {
    let level: Level
    let levelSaveData: [String: [String: Int]]
    
    var body: some View {
        VStack() {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text(level.name)
                    
                    Spacer()
                    
                    Image(systemName: "play.fill")
                }
                
                if levelSaveData[level.level_id]?["completed"] == 1 {
                    LazyVStack {
                        Text("Completed")
                        
                        HStack {
                            let totalSeconds = levelSaveData["\(level.level_id)"]?["time"] ?? 0
                            let formattedTime = formatTime(totalSeconds)
                            
                            Text(formattedTime)
                            
                            Text("\(levelSaveData[level.level_id]?["moves"] ?? 0) Moves")
                            Text("\(levelSaveData[level.level_id]?["resets"] ?? 0) Resets")
                        }
                    }
                    .bold()
                    .foregroundStyle(.green)
                }
                
                HStack {
                    Text("Level \(String(level.level_id))")
                    Image(systemName: "diamond.fill")
                        .foregroundStyle(Color(level.difficulty.color))
                    
                    Spacer()
                    
                    Text("\(levelSaveData[level.level_id]?["attempts"] ?? 0) Attempts")
                    
                    Text("\(level.tileData.count)x\(level.tileData.count) Grid")
                }
                .foregroundStyle(.gray)
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
    LevelPreviewView(level: Level(), levelSaveData: [:])
}
