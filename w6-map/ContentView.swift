//
//  ContentView.swift
//  w6-map
//
//  Created by Default User on 10/9/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: MapContentView()) {
                    Text("Begin")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
