import SwiftUI


struct FXControlBoard: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Grid(horizontalSpacing: 16, verticalSpacing: 16) {
                    GridRow {
                        fxTile(color: .purple, title: "Pitch/Speed")
                        fxTile(color: .green, title: "Reverb")
                    }
                    GridRow {
                        fxTile(color: .yellow, title: "Volume")
                        fxTile(color: .blue, title: "EQ")
                    }
                    GridRow {
                        fxTile(color: .teal, title: "Noise Reduction")
                        fxTile(color: .orange, title: "Delay")
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .padding(20)
            .background(Theme.bg)
            .navigationTitle("FX Board")
            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } } }
        }
    }

    private func fxTile(color: Color, title: String) -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 16).fill(color.opacity(0.25))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.stroke, lineWidth: 1))
                .overlay(Text(title).font(.headline))
                .frame(height: 120)
        }
    }
}

//  FXControlBoard.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/9/25.
//

