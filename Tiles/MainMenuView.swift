//
//  MainMenuView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/20/26.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                NavigationLink(destination: GameView()) {
                    VStack() {
                        VStack(alignment: .leading, spacing: 24) {
                            HStack {
                                Text("Play Demo")
                                Spacer()
                                
                                Image(systemName: "play.fill")
                            }
                            
                            Text("Level 1")
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
            .background(Color(.tertiarySystemBackground))
            .navigationTitle("Welcome")
        }
    }
}

#Preview {
    MainMenuView()
}
