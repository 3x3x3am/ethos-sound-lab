import SwiftUI


struct CreateFlow: View {
    @State private var showHybrid = false
    @State private var showRecord = false
    @State private var showEdit = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("ETHOS SOUND")
                        .font(.caption).kerning(2)
                        .foregroundStyle(Theme.subtext)
                    Text("Create").font(.largeTitle.bold())
                        .foregroundStyle(Theme.text)

                    Grid(horizontalSpacing: 16, verticalSpacing: 16) {
                        GridRow {
                            bigTile(title: "AI", subtitle: "Hybrid AI", icon: "wand.and.stars") { showHybrid = true }
                            bigTile(title: "Record", subtitle: "Voice/Beat", icon: "mic") { showRecord = true }
                        }
                        GridRow {
                            bigTile(title: "Edit", subtitle: "Timeline", icon: "waveform.path.ecg") { showEdit = true }
                            bigTile(title: "FX", subtitle: "Control Board", icon: "dial.medium") { }
                        }
                    }
                }
                .padding(20)
            }
            .background(Theme.bg)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showHybrid) { HybridAIView() }
        .sheet(isPresented: $showRecord) { RecordView() }
        .sheet(isPresented: $showEdit) { StudioView() }
    }

    private func bigTile(title: String, subtitle: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon).font(.title2)
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundStyle(Theme.subtext)
            }
            .frame(maxWidth: .infinity, minHeight: 140, alignment: .leading)
            .padding(16)
            .background(LinearGradient(colors: [Theme.card, Theme.card2], startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Theme.stroke, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .foregroundStyle(Theme.text)
        }
    }
}

//  CreateFlow.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/9/25.
//

