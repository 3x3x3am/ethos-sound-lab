import SwiftUI


struct NoiseReducerView: View {
    @EnvironmentObject var audio: DefaultAudioGraph
    @Environment(\.dismiss) private var dismiss
    @State private var previewB = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Panel(title: "AMOUNT") {
                    Slider(value: $audio.denoiseAmount, in: 0...1)
                    HStack { Text("Dry"); Spacer(); Text("Clean") }
                        .foregroundStyle(Theme.subtext)
                        .font(.caption)
                }
                Panel(title: "A/B") {
                    Toggle(isOn: $previewB) { Text(previewB ? "B" : "A") }
                        .toggleStyle(.switch)
                }
                Spacer()
            }
            .padding(20)
            .background(Theme.bg)
            .navigationTitle("Noise Reducer")
            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } } }
        }
    }
}

//  NoiseReducerView.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/9/25.
//

