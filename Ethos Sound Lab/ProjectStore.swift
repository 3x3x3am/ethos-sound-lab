import Foundation
import SwiftUI

@MainActor
final class ProjectStore: ObservableObject {
    @Published var tracks: [StudioTrack] = [
        StudioTrack(name: "Beats", kind: .audio, colorTag: "blue"),
        StudioTrack(name: "Voice", kind: .audio, colorTag: "green")
    ]
    @Published var isPlaying: Bool = false
    @Published var playhead: TimeInterval = 0
    @Published var duration: TimeInterval = 30

    func addRegion(to trackID: TrackID, from url: URL, title: String) {
        // This simplified store doesn't keep clip arrays; implement as needed.
    }

    func addEmptyTrack() {
        tracks.append(StudioTrack(name: "New Track", kind: .audio, colorTag: nil))
    }
}
