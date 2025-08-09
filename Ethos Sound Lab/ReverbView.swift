import SwiftUI


struct ReverbView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var mix: Double = 0.2
    @State private var time: Double = 1.2
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Panel(title: "REVERB") {
                    VStack {
                        HStack { Text("Mix"); Spacer(); Text(String(format: "%.0f%%", mix*100)) }
                        Slider(value: $mix, in: 0...1)
                        HStack { Text("Time"); Spacer(); Text(String(format: "%.1fs", time)) }
                        Slider(value: $time, in: 0.2...8)
                    }
                }
                Spacer()
            }
            .padding(20)
            .background(Theme.bg)
            .navigationTitle("Reverb")
            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } } }
        }
    }
}

//  ReverbView.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/9/25.
//

