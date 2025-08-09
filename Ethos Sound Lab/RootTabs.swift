import SwiftUI


struct RootTabs: View {
    var body: some View {
        TabView {
            CreateFlow()
                .tabItem { Label("Create", systemImage: "sparkles") }
            FeedView()
                .tabItem { Label("Feed", systemImage: "chart.bar") }
            MixMasterView()
                .tabItem { Label("Master", systemImage: "slider.horizontal.3") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .tint(Theme.accent)
        .background(Theme.bg.ignoresSafeArea())
    }
}

//  RootTabs.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/9/25.
//

