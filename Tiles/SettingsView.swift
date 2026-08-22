//
//  SettingsView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 8/11/26.
//

import SwiftUI
import TipKit

struct OnboardingView: View {
    var body: some View {
        NavigationLink {
            GuideView()
        } label: {
            Text("Onboarding")
        }
    }
}

struct DifficultyView: View {
    @Binding var storage: Storage
    @State var settings: [String : Int] = [:]
    
    var body: some View {
        NavigationLink {
            List {
                Section(footer: Text("hi")) {
                    ForEach(GameDifficulty.allCases) { difficulty_case in
                        Button() {
                            settings["difficulty"] = difficulty_case.rawValue
                            storage.settings = settings
                        } label: {
                            HStack {
                                Text(difficulty_case.stringValue)
                                
                                Spacer()
                                
                                if settings["difficulty"] == difficulty_case.rawValue {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.blue)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Difficulty")
        } label: {
            HStack {
                Text("Difficulty")
                
                Spacer()
                
                Text(GameDifficulty(rawValue: settings["difficulty"] ?? 0)?.stringValue ?? "Beginner")
                    .foregroundStyle(.gray)
            }
        }
        .onAppear {
            settings = storage.settings ?? [:]
        }
    }
}

struct SettingsView: View {
    @Binding var storage: Storage
    
    @State private var deletingData = false
    
    var body: some View {
        List {
            DifficultyView(storage: $storage)
            
            Button(role: .destructive) {
                deletingData = true
            } label: {
                Text("Clear Data")
            }
            .alert("Clear Data", isPresented: $deletingData) {
                Button("OK", role: .destructive) {
                    storage.levelSaveData = [:]
                }
            } message: {
                Text("Are you sure you want to delete your game data? This removes all level progress!")
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    @Previewable @State var storage = Storage()
    SettingsView(storage: $storage)
}
