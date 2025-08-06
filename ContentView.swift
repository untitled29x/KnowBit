//
//  ContentView.swift
//  KnowBit
//
//  Created by Yann Belov on 8/6/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            .tabItem {
                Image(systemName: "plus")
                Text("Home")
            Text("Tab 1")
                .tabItem {
                    Image(systemName: "house")
                        }
                Text("Tab 2")
                    .tabItem {
                        Image(systemName: "pencil")
                        Text("Tab 3")
                    }
                
                    
                            
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
