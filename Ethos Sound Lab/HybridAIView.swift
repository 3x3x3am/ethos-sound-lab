import SwiftUI


struct HybridAIView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var prompt: String = ""
    @State private var voice: String = "Neon"
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Panel(title: "AI SONG IDEA") {
                        TextField("“Make a moody R&B hook about midnight neon…”", text: $prompt, axis: .vertical)
                            .lineLimit(3...5)
                            .textFieldStyle(.plain)
                            .foregroundStyle(Theme.text)
                        Picker("Voice", selection: $voice) {
                            Text("Neon").tag("Neon")
                            Text("Velvet").tag("Velvet")
                            Text("Retro").tag("Retro")
                        }
                        .pickerStyle(.segmented)
                    }
                    Panel(title: "ACTIONS") {
                        HStack {
                            action("Generate", system: "sparkles")
                            action("Random", system: "dice")
                            Spacer()
                        }
                    }
                }
                .padding(20)
            }
            .background(Theme.bg)
            .navigationTitle("Hybrid AI")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } }
            }
        }
    }

    private func action(_ title: String, system: String) -> some View {
        Button {
            // later: call backend/ML
        } label: {
            Label(title, systemImage: system)
                .padding(.vertical, 10).padding(.horizontal, 14)
                .background(Theme.card2).clipShape(Capsule())
                .overlay(Capsule().stroke(Theme.stroke, lineWidth: 1))
        }.foregroundStyle(Theme.text)
    }
}

//  HybridAIView.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/9/25.
//

