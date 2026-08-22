//
//  MainMenuView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/20/26.
//

import SwiftUI
import TipKit

struct MainMenuItemView: View {
    let header: String
    let footer: String
    
    init(header: String, footer: String) {
        self.header = header
        self.footer = footer
    }
    
    var body: some View {
        VStack {
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
}

struct OnboardingTip: Tip {
    var title: Text {
        Text("Start Here!")
    }


    var message: Text? {
        Text("Start learning Tiles here!")
    }


    var image: Image? {
        Image(systemName: "book.pages")
    }
}

struct MainMenuView: View {
    @State private var storage: Storage = Storage()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                NavigationLink {
                    TutorialLevelsView(storage: $storage)
                } label: {
                    MainMenuItemView(header: "Learn the Game", footer: "Tutorial Levels")
                }
                .buttonStyle(.plain)
                .popoverTip(OnboardingTip())
                
                NavigationLink {
                    CoreLevelsView(storage: $storage)
                } label: {
                    MainMenuItemView(header: "Play the Game", footer: "Core Levels")
                }
                .buttonStyle(.plain)
                
                NavigationLink {
                    SettingsView(storage: $storage)
                } label: {
                    MainMenuItemView(header: "Customize the Game", footer: "Settings")
                }
                .buttonStyle(.plain)
            }
            .background(Color(.tertiarySystemBackground))
            .navigationTitle("Tiles")
        }
        .task {
            do {
#if DEBUG
                try Tips.resetDatastore()
#endif
                
                try Tips.configure()
            }
            catch {
                print("Error initializing TipKit \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    MainMenuView()
}
