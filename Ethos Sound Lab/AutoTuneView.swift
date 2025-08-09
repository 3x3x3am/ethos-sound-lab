import SwiftUI


struct AutoTuneView: View {
    @EnvironmentObject var audio: DefaultAudioGraph
    @Environment(\.dismiss) private var dismiss

    @State private var keys = ["C","C#","D","Eb","E","F","F#","G","Ab","A","Bb","B"]
    @State private var scales = ["Major","Minor","Dorian","Mixolydian"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Panel(title: "KEY / SCALE") {
                        HStack {
                            Picker("Key", selection: $audio.autotune.key) {
                                ForEach(keys, id: \.self) { Text($0).tag($0) }
                            }.pickerStyle(.segmented)
                            Picker("Scale", selection: $audio.autotune.scale) {
                                ForEach(scales, id: \.self) { Text($0).tag($0) }
                            }.pickerStyle(.segmented)
                        }
                    }
                    Panel(title: "RETUNE SPEED") {
                        LabeledContent(value: audio.autotune.retuneSpeed, unit: "x") {
                            Slider(value: $audio.autotune.retuneSpeed, in: 0.05...1.0)
                        }
                    }
                    Panel(title: "HUMANIZE / FORMANT") {
                        LabeledContent(value: audio.autotune.humanize, unit: "") {
                            Slider(value: $audio.autotune.humanize, in: 0...1)
                        }
                        LabeledContent(value: audio.autotune.formant, unit: "") {
                            Slider(value: $audio.autotune.formant, in: -1...1)
                        }
                    }
                    Panel(title: "STYLE") {
                        HStack {
                            chip("Natural"); chip("Pop"); chip("Hard"); chip("Vintage")
                        }
                    }
                }
                .padding(20)
            }
            .background(Theme.bg)
            .navigationTitle("Perfect Pitch")
            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } } }
        }
    }

    private func chip(_ name: String) -> some View {
        Button {
            audio.autotune.style = name
        } label: {
            Text(name)
                .padding(.vertical, 8).padding(.horizontal, 12)
                .background(audio.autotune.style == name ? Theme.accent.opacity(0.25) : Theme.card2)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Theme.stroke, lineWidth: 1))
        }.foregroundStyle(Theme.text)
    }
}

struct LabeledContent<Control: View>: View {
    var value: Double
    var unit: String
    @ViewBuilder var control: Control
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(String(format: "%.2f%@", value, unit)).foregroundStyle(Theme.subtext)
                Spacer()
            }
            control
        }
    }
}

//  AutoTuneView.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/9/25.
//

