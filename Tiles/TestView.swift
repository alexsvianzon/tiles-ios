//
//  TestView.swift
//  Tiles
//
//  Created by Alexander Vianzon on 7/20/26.
//

import SwiftUI

struct TestView: View {
    @State private var showSheet = false

    var body: some View {
        VStack {
            Button("Show Bottom Sheet") {
                doSumin()
            }
        }
        .sheet(isPresented: $showSheet) {
            Spacer()
            
            TabView {
                Text("hi")
                
                Text("hi")
            }
            .tabViewStyle(.page)
            .frame(height: 300)
            .padding()
            .presentationDetents([.medium])
        }
    }
    
    func doSumin() {
        showSheet = true
    }
}

#Preview() {
    TestView()
}
