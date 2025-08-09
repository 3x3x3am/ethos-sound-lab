import SwiftUI


struct EQView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var bands = Array(repeating: 0.0, count: 8)
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Panel(title: "GRAPHIC EQ") {
                    HStack(alignment: .bottom, spacing: 10) {
                        ForEach(bands.indices, id: \.self) { i in
                            VStack {
                                Slider(value: $bands[i], in: -12...12)
                                    .rotationEffect(.degrees(-90))
                                    .frame(height: 140)
                                Text("\(i == 0 ? "32" : i == 7 ? "16k" : "\(i*2)00")").font(.caption2)
                                    .foregroundStyle(Theme.subtext)
                            }
                        }
                    }.frame(maxWidth: .infinity)
                }
                Spacer()
            }
            .padding(20)
            .background(Theme.bg)
            .navigationTitle("EQ")
            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } } }
        }
    }
}

//  EQView.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/9/25.
//

