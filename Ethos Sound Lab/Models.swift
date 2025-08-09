import Foundation

/// Stable, unambiguous IDs for tracks and clips.
public struct TrackID: Hashable, Codable, Sendable {
    public let rawValue: UUID
    public init(_ rawValue: UUID = UUID()) { self.rawValue = rawValue }
}

public struct ClipID: Hashable, Codable, Sendable {
    public let rawValue: UUID
    public init(_ rawValue: UUID = UUID()) { self.rawValue = rawValue }
}

/// Audio or MIDI (you can extend later).
public enum TrackKind: String, Codable, Sendable {
    case audio
    case midi
}

/// A track in the multitrack timeline.
public struct StudioTrack: Identifiable, Hashable, Codable, Sendable {
    public let id: TrackID
    public var name: String
    public var kind: TrackKind
    /// Store UI color as hex or name to avoid pulling SwiftUI into model.
    public var colorTag: String?

    public init(id: TrackID = TrackID(),
                name: String,
                kind: TrackKind,
                colorTag: String? = nil) {
        self.id = id
        self.name = name
        self.kind = kind
        self.colorTag = colorTag
    }
}

/// A clip (what many DAWs call a “region”) on the timeline.
/// Replaces ANY older `Region` / `TrackRegion` types.
public struct TimelineClip: Identifiable, Hashable, Codable, Sendable {
    public let id: ClipID
    public var trackID: TrackID
    public var start: TimeInterval      // seconds
    public var duration: TimeInterval   // seconds
    public var url: URL?                // audio file location (nil for MIDI, etc.)

    public init(id: ClipID = ClipID(),
                trackID: TrackID,
                start: TimeInterval,
                duration: TimeInterval,
                url: URL?) {
        self.id = id
        self.trackID = trackID
        self.start = start
        self.duration = duration
        self.url = url
    }
}

// If you previously referenced `TrackRegion`, this keeps old code compiling.
// Make sure this exists in ONE place only.
public typealias TrackRegion = TimelineClip
