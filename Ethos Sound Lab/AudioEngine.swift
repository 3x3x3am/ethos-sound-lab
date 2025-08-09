import Foundation
import AVFoundation

/// Very small, working audio host you can extend later.
/// It loads clips (TimelineClip) and plays them from 0 with their offsets.
public final class AudioEngine: @unchecked Sendable {

    // MARK: Public state
    public private(set) var isRunning = false

    // MARK: Private
    private let engine = AVAudioEngine()
    private let mainMixer: AVAudioMixerNode
    private var players: [ClipID: AVAudioPlayerNode] = [:]
    private var files: [ClipID: AVAudioFile] = [:]

    public init() {
        mainMixer = engine.mainMixerNode
    }

    /// Call once when you have your clips for the current project.
    /// You can call again to reload—this will stop and rebuild graph.
    public func load(clips: [TimelineClip]) throws {
        stop()
        players.removeAll()
        files.removeAll()

        // Build a player node per audio clip (ignore MIDI for now).
        for clip in clips {
            guard let url = clip.url else { continue } // MIDI or empty clip
            let file = try AVAudioFile(forReading: url)
            let player = AVAudioPlayerNode()
            engine.attach(player)

            // Connect each player to the main mixer at the file's format.
            let format = file.processingFormat
            engine.connect(player, to: mainMixer, format: format)

            players[clip.id] = player
            files[clip.id] = file
        }

        // Prepare engine
        if !engine.isRunning {
            try engine.start()
        }
        isRunning = true
    }

    /// Start playback from timeline 0. (Simple: schedules all clips with offsets.)
    public func play(clips: [TimelineClip]) {
        guard isRunning else { return }

        let now = AVAudioTime(hostTime: mach_absolute_time())
        for clip in clips {
            guard let player = players[clip.id],
                  let file = files[clip.id] else { continue }

            // Schedule to start at clip.start seconds from now.
            let sampleRate = file.processingFormat.sampleRate
            let startOffsetSamples = AVAudioFramePosition(clip.start * sampleRate)
            let frameCount = AVAudioFrameCount(clip.duration * file.processingFormat.sampleRate)

            player.stop()
            player.scheduleSegment(
                file,
                startingFrame: startOffsetSamples,
                frameCount: frameCount,
                at: now.offset(seconds: clip.start),
                completionHandler: nil
            )
            player.play()
        }
    }

    public func stop() {
        for (_, p) in players { p.stop() }
        engine.stop()
        isRunning = false
    }

    // Optional convenience
    public func setGain(for clipID: ClipID, linearGain: Float) {
        // Quick per-clip gain using player’s volume (0…1+).
        players[clipID]?.volume = max(0, linearGain)
    }

    public func setPan(for clipID: ClipID, pan: Float) {
        // PlayerNode has no pan; use mixer tap or per-clip mixer if you like.
        // For now, keep a simple global pan by inserting a mixer per clip if needed.
        // Placeholder—left for future extension.
    }
}

// MARK: - Small helper

private extension AVAudioTime {
    func offset(seconds: TimeInterval) -> AVAudioTime {
        // Convert a seconds offset to hostTime offset.
        let hostTimeSeconds = Double(AVAudioTime.hostTime(forSeconds: seconds))
        let newHostTime = self.hostTime + UInt64(hostTimeSeconds)
        return AVAudioTime(hostTime: newHostTime)
    }
}
