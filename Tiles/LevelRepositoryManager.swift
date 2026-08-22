//
//  LevelRepository.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/28/26.
//

import Foundation
import SwiftUI

enum LevelDifficulty: Hashable {
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

struct Level: Identifiable, Hashable {
    var id: String { level_id }
    
    var level_id: String = "0"
    var difficulty: LevelDifficulty = .tutorial
    var name: String = ""
    var hint: String?
    var tileData: [String] = []
}

class LevelRepositoryManager {
    func get_local(_ from: String) -> [Level] {
        var levels: [Level] = []
        
        let url = Bundle.main.url(forResource: from, withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                for item in json {
                    var level = Level()
                    
                    if let id = item["id"] as? String {
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
                    
                    if let tileMap = item["level"] as? [String] {
                        level.tileData = tileMap
                    } else {
                        print("oh noes")
                    }
                    
                    if let hint = item["hint"] as? String {
                        level.hint = hint
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
