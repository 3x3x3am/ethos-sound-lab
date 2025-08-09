import SwiftUI

struct MixMasterView: View {
    @EnvironmentObject var audio: DefaultAudioGraph
    @State private var lufs: Double = -14.0
    @State private var ceiling: Double = -1.0
    @State private var width: Double = 0.0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Panel(title: "LOUDNESS") {
                        HStack {
                            Spacer()
                            Picker("", selection: $lufs) {
                                Text("-16 (YT)").tag(-16.0)
                                Text("-14 (Spotify)").tag(-14.0)
                                Text("-12 (Apple)").tag(-12.0)
                            }.pickerStyle(.segmented).frame(width: 280)
                        }
                        HStack {
                            Text("Ceiling"); Spacer(); Text(String(format:"%.1f dBTP", ceiling))
                        }
                        Slider(value: $ceiling, in: -2.0 ... -0.1)
                    }
                    Panel(title: "TONE / WIDTH") {
                        HStack { Text("Stereo Width"); Spacer(); Text(String(format:"%.0f%%", (width+1)*50)) }
                        Slider(value: $width, in: -1...1)
                        Button {
                            // later: analyze reference & tone-match
                        } label: {
                            Label("Analyze & Match", systemImage: "wand.and.stars.inverse")
                        }.buttonStyle(.bordered)
                    }
                    Panel(title: "OUTPUT") {
                        Button {
                            // later: export
                        } label: {
                            Label("Export WAV", systemImage: "square.and.arrow.up")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Theme.accent)
                    }
                }
                .padding(20)
            }
            .background(Theme.bg)
            .navigationTitle("Mix & Master")
        }
    }
}

//  MixMasterView.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/9/25.
//

