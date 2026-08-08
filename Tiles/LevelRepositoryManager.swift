//
//  LevelRepository.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/28/26.
//

import Foundation
import SwiftUI

enum LevelDifficulty {
    case tutorial
    case easy
    case medium
    case difficult
    case unknown
    
    var color: Color {
        switch self {
        case .tutorial:
            return .blue
        case .easy:
            return .green
        case .medium:
            return .yellow
        case .difficult:
            return .red
        case .unknown:
            return .gray
        }
    }
}

struct Level: Identifiable {
    let id: UUID = UUID()
    
    var level_id: UInt = 0
    var difficulty: LevelDifficulty = .tutorial
    var name: String = ""
    var tileData: Array<String> = []
}

class LevelRepositoryManager {
    func get_local(_ from: String) -> Array<Level> {
        var levels: Array<Level> = []
        
        let url = Bundle.main.url(forResource: from, withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? Array<[String: Any]> {
                for item in json {
                    var level = Level()
                    
                    if let id = item["id"] as? UInt {
                        level.level_id = id
                    }
                    
                    if let difficulty = item["difficulty"] as? String {
                        switch difficulty {
                        case "tutorial":
                            level.difficulty = .tutorial
                        case "easy":
                            level.difficulty = .easy
                        case "medium":
                            level.difficulty = .medium
                        case "difficult":
                            level.difficulty = .difficult
                        default:
                            level.difficulty = .unknown
                        }
                    }
                    
                    if let name = item["name"] as? String {
                        level.name = name
                    }
                    
                    if let tileMap = item["level"] as? Array<String> {
                        level.tileData = tileMap
                    } else {
                        print("oh noes")
                    }
                    
                    levels.append(level)
                }
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
        
        return levels
    }
}
