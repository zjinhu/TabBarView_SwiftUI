//
//  ContentView.swift
//  TabBarVIewDemo
//
//  Created by 狄烨 on 2024/7/30.
//

import SwiftUI
import TabBarView_SwiftUI
struct ContentView: View {
    @State private var selection: Item = .home

    var body: some View {
        TabBarView(selection: $selection) {
            Text("First Tab")
                .tabItem(for: Item.home)
            
            Text("Second Tab")
                .tabItem(for: Item.favorites)
            
            Text("Third Tab")
                .tabItem(for: Item.profile)

        }
        .environmentObject(TabBarItemSize())///需要传递
    }
}

#Preview {
    ContentView() 
}

enum Item: Int, TabBarItemable {
    case home, favorites, profile
    
    var icon: Image {
        switch self {
        case .home: return Image(systemName: "house")
        case .favorites: return Image(systemName: "heart")
        case .profile: return Image(systemName: "person")
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .favorites: return "Favorites"
        case .profile: return "Profile"
        }
    }
    
    var color: Color {
        switch self {
        case .home: return Color.red
        case .favorites: return Color.blue
        case .profile: return Color.green
        }
    }
}
