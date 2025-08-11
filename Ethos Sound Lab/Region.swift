import Foundation
import SwiftUI


#if false
struct TrackRegion: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var url: URL?            // nil for empty/record-armed tracks
    var start: TimeInterval  // seconds in timeline (non-destructive trim start)
    var duration: TimeInterval
}

struct Track: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var color: Color
    var regions: [Region] = []
    var volume: Float = 1.0   // 0…1
    var pan: Float = 0.0      // -1…1
}

@MainActor
final class ProjectStore: ObservableObject {
    @Published var tracks: [Track] = [
        Track(name: "Beats", color: .blue, regions: []),
        Track(name: "Voice", color: .green, regions: [])
    ]
    @Published var isPlaying = false
    @Published var playhead: TimeInterval = 0
    @Published var duration: TimeInterval = 30

    func addRegion(to trackID: UUID, from url: URL, title: String) {
        guard let idx = tracks.firstIndex(where: {$0.id == trackID}) else { return }
        let new = TrackRegion(title: title, url: url, start: 0, duration: 10)
        tracks[idx].regions.append(new)
    }

    func addEmptyTrack() {
        tracks.append(Track(name: "New Track", color: .orange))

   // #endif}
}
    #endif
