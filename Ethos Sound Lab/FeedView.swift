import SwiftUI


struct FeedView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Charts – Today") {
                    ForEach(1..<6) { i in
                        HStack {
                            Text("#\(i)").foregroundStyle(Theme.subtext)
                            VStack(alignment: .leading) {
                                Text("Song \(i)").font(.headline)
                                Text("@artist\(i)").font(.caption).foregroundStyle(Theme.subtext)
                            }
                            Spacer()
                            Image(systemName: "play.fill")
                        }
                        .listRowBackground(Theme.card)
                        .foregroundStyle(Theme.text)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.bg)
            .navigationTitle("Feed")
        }
    }
}

//  FeedView.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/9/25.
//

