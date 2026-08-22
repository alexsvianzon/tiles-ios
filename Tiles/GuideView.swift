//
//  GuideView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 8/18/26.
//

import SwiftUI

struct GuideViewFirstPage: View {
    var body: some View {
        VStack {
            Text("Movement")
                .bold()
            
            if let videoURL = Bundle.main.url(forResource: "movement-example", withExtension: "mp4") {
                VideoPlayer(url: videoURL, delaySeconds: 5.0)
                    .frame(height: 200)
            } else {
                Text("Video tutorial resource could not be located")
            }
            
            Text("Press the arrow keys to move in the direction you want to go.")
        }
    }
}

struct GuideViewSecondPage: View {
    var body: some View {
        VStack {
            Text("The Grid")
                .bold()
            
            if let videoURL = Bundle.main.url(forResource: "grid-example", withExtension: "mp4") {
                VideoPlayer(url: videoURL, delaySeconds: 5.0)
                    .frame(height: 200)
            } else {
                Text("Video tutorial resource could not be located")
            }
            
            Text("You play on a grid of tiles. Each tile limits you with a unique rule of movement.")
        }
    }
}

struct GuideViewThirdPage: View {
    var body: some View {
        VStack {
            Text("The Goal")
                .bold()
            
            if let videoURL = Bundle.main.url(forResource: "goal-example", withExtension: "mp4") {
                VideoPlayer(url: videoURL, delaySeconds: 5.0)
                    .frame(height: 200)
            } else {
                Text("Video tutorial resource could not be located")
            }
            
            Text("You must move across the grid of tiles to get to the white 'goal' tile.")
        }
    }
}

struct GuideView: View {
    var body: some View {
        Spacer()
        
        TabView {
            GuideViewFirstPage()
            
            GuideViewSecondPage()
            
            GuideViewThirdPage()
        }
        .tabViewStyle(.page)
        .frame(height: 400)
        .padding()
    }
}

#Preview {
    GuideView()
}
