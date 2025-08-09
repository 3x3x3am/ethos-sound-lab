import SwiftUI


struct ProfileView: View {
    @State private var showPublish = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        Circle().fill(Theme.card2).frame(width: 72, height: 72)
                            .overlay(Text("3x").font(.headline))
                        VStack(alignment: .leading) {
                            Text("3x3x3am").font(.title2.bold())
                            HStack(spacing: 16) {
                                Label("100k", systemImage: "headphones")
                                Label("2k", systemImage: "diamond")
                                Label("1M", systemImage: "person.2")
                            }.font(.caption).foregroundStyle(Theme.subtext)
                        }
                        Spacer()
                    }
                    Panel(title: "ACTIONS") {
                        HStack {
                            Button { showPublish = true } label: {
                                Label("Publish", systemImage: "arrow.up.circle")
                            }
                            .buttonStyle(.borderedProminent).tint(Theme.accent)
                            Button { } label: {
                                Label("Links", systemImage: "link")
                            }.buttonStyle(.bordered)
                            Spacer()
                        }
                    }
                    Panel(title: "DROPS") {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            ForEach(0..<6) { i in
                                RoundedRectangle(cornerRadius: 12).fill(Theme.card2).frame(height: 120)
                                    .overlay(Text("Track \(i+1)"))
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Theme.bg)
            .navigationTitle("Profile")
        }
        .sheet(isPresented: $showPublish) { PublishDialog() }
    }
}

struct PublishDialog: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var tags = ""
    @State private var isPublic = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)
                    TextField("Tags (comma separated)", text: $tags)
                    Toggle("Public", isOn: $isPublic)
                }
                Section {
                    Button {
                        // later: upload + post to feed
                        dismiss()
                    } label: {
                        Label("Publish", systemImage: "paperplane.fill")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.bg)
            .navigationTitle("Publish")
            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } } }
        }
    }
}

//  ProfileView.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/9/25.
//

