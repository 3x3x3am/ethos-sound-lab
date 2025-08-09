import SwiftUI


struct TimelineEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showFX = false
    @State private var showTune = false
    @State private var showEQ = false
    @State private var showNoise = false
    @State private var showMaster = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Panel(title: "TRACKS") {
                    timelinePlaceholder
                }
                Panel(title: "TOOLS") {
                    toolRow
                }
                Spacer()
            }
            .padding(20)
            .background(Theme.bg)
            .navigationTitle("Edit")
            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } } }
            .sheet(isPresented: $showFX) { FXControlBoard() }
            .sheet(isPresented: $showTune) { AutoTuneView() }
            .sheet(isPresented: $showEQ) { EQView() }
            .sheet(isPresented: $showNoise) { NoiseReducerView() }
            .sheet(isPresented: $showMaster) { MixMasterView() }
        }
    }

    private var timelinePlaceholder: some View {
        VStack(spacing: 10) {
            trackRow(color: .blue, name: "Beat")
            trackRow(color: .green, name: "Vocals")
            trackRow(color: .purple, name: "Backing")
        }
    }

    private func trackRow(color: Color, name: String) -> some View {
        HStack {
            Circle().fill(color).frame(width: 10, height: 10)
            Text(name).foregroundStyle(Theme.subtext)
            Spacer()
            RoundedRectangle(cornerRadius: 8).fill(Theme.card2).frame(height: 28)
            RoundedRectangle(cornerRadius: 8).fill(Theme.card2).frame(height: 28)
        }.frame(height: 32)
    }

    private var toolRow: some View {
        HStack(spacing: 12) {
            tool("FX", "dial.medium") { showFX = true }
            tool("Perfect Pitch", "waveform") { showTune = true }
            tool("EQ", "slider.horizontal.3") { showEQ = true }
            tool("Noise", "wind") { showNoise = true }
            tool("Master", "gauge.with.dots.needle.bottom.50percent") { showMaster = true }
        }
    }

    private func tool(_ title: String, _ icon: String, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .padding(.vertical, 10).padding(.horizontal, 12)
                .background(Theme.card2).clipShape(Capsule())
                .overlay(Capsule().stroke(Theme.stroke, lineWidth: 1))
        }.foregroundStyle(Theme.text)
    }
}

//  TimelineEditView.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/9/25.
//

