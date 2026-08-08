//
//  MainMenuView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/20/26.
//

import SwiftUI

struct MainMenuItemView<Destination: View>: View {
    let destination: Destination
    let header: String
    let footer: String
    
    init(_ destination: Destination, header: String, footer: String) {
        self.destination = destination
        self.header = header
        self.footer = footer
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack() {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text(header)
                            .bold()
                        
                        Spacer()
                        
                        Image(systemName: "play.fill")
                    }
                    
                    Text(footer)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

struct MainMenuView: View {
    @State var storage: Storage = Storage()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                MainMenuItemView(
                    TutorialLevelsView(storage: storage),
                    header: "Learn the Game",
                    footer: "Tutorial Levels")
                
                MainMenuItemView(
                    CoreLevelsView(storage: storage),
                    header: "Play the Game",
                    footer: "Core Levels")
                
                Button() {
                    storage.levelSaveData = [:]
                } label: {
                    Text("Clear Data")
                }
            }
            .background(Color(.tertiarySystemBackground))
            .navigationTitle("Tiles")
        }
    }
}

#Preview {
    MainMenuView()
}
