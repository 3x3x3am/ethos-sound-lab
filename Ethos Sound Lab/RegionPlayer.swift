import Foundation
import AVFoundation
import Combine

/// Simple per-track player that can schedule and play a single file.
/// Conforms to ObservableObject so you can use @StateObject / @ObservedObject.
@MainActor
public final class RegionPlayer: ObservableObject {

    public let engine = AVAudioEngine()
    public let player = AVAudioPlayerNode()
    private let mixer: AVAudioMixerNode

    @Published public private(set) var isRunning = false
    @Published public private(set) var isPlaying = false

    public init() {
        mixer = engine.mainMixerNode
        engine.attach(player)
        engine.connect(player, to: mixer, format: nil)
        try? engine.start()
        isRunning = true
    }

    /// Schedule a file to play from the beginning once.
    public func schedule(url: URL) throws {
        let file = try AVAudioFile(forReading: url)
        player.stop()
        player.scheduleFile(file, at: nil, completionHandler: nil)
    }

    public func play() {
        guard isRunning else { return }
        if !player.isPlaying { player.play(); isPlaying = true }
    }

    public func stop() {
        if player.isPlaying { player.stop(); isPlaying = false }
    }
}
