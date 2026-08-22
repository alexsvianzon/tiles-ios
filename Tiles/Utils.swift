//
//  Utils.swift
//  Tiles
//
//  Created by Alexander Vianzon on 8/8/26.
//

import Foundation

func formatTime(_ time: Int) -> String {
    let minutes = time / 60
    let seconds = time % 60
    
    return String(format: "%02d:%02d", minutes, seconds)
}
