import Foundation
import SwiftUI

@MainActor
final class TrackStore: ObservableObject {
    @Published var tracks: [TrackModel] = []

    init() { seedDemo() }

    func seedDemo() {
        // Mutable demo tracks; adjust later
           tracks = [
            TrackModel(name: "Lead Vox", kind: .audio),
            TrackModel(name: "Backing Vox", kind: .audio),
            TrackModel(name: "Keys", kind: .audio),
            TrackModel(name: "Drums", kind: .audio)
        ]
    }
    func addTrack(name: String) {
        tracks.append(TrackModel(name: name, kind: .audio))
    }


    func removeTracks(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
    }

    func moveTracks(from source: IndexSet, to destination: Int) {
        tracks.move(fromOffsets: source, toOffset: destination)
    }
}
