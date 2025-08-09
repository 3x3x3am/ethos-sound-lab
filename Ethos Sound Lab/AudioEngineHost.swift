import Foundation

/// Simple wrapper so SwiftUI views can hold one engine instance.
@MainActor
final class AudioEngineHost: ObservableObject {
    private let engine = AudioEngine()
    @Published private(set) var isRunning = false

    /// Keep the most recent clips to play.
    private var currentClips: [TimelineClip] = []

    func load(clips: [TimelineClip]) {
        do {
            try engine.load(clips: clips)
            currentClips = clips
            isRunning = true
        } catch {
            print("Engine load failed:", error)
            isRunning = false
        }
    }

    func play() {
        engine.play(clips: currentClips)
    }

    func stop() {
        engine.stop()
        isRunning = false
    }

    func setGain(for clipID: ClipID, to linear: Float) {
        engine.setGain(for: clipID, linearGain: linear)
    }
}
