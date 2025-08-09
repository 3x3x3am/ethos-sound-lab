import Foundation

struct EngineRegion: Identifiable, Hashable, Equatable {
    var id = UUID()
    var trackID: UUID
    var name: String
    var startBeats: Double
    var lengthBeats: Double
    var colorHex: UInt32
}
//
//  Untitled.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/9/25.
//

