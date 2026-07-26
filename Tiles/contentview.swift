//
//  contentview.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/20/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showSheet = false

    var body: some View {
        VStack {
            Button("Show Bottom Sheet") {
                doSumin()
            }
        }
        .sheet(isPresented: $showSheet) {
            VStack {
                Text("Level Beaten!")
                    .font(Font.custom("NewYorkExtraLarge-Bold", size: 32))
                    .padding()
                
                Spacer()
                
                Button() {
                    
                } label: {
                    Text("Back to Levels")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                
                HStack {
                    Button() {
                        
                    } label: {
                        Text("Stats")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                }
            }
            .padding()
            .presentationDetents([.medium])
        }
    }
    
    func doSumin() {
        showSheet = true
    }
}

#Preview() {
    ContentView()
}
