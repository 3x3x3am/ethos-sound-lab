import SwiftUI
import AVFoundation

struct StudioView: View {
    @StateObject private var player = RegionPlayer()
    @State private var region: TimelineRegion?
    @State private var isImporting = false
    @State private var isLooping = false
    @State private var userDraggingSeek = false
    @State private var pendingSeekTime: Double = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {

                // Timeline header (simple ruler)
                RulerView(length: region?.duration ?? 0)
                    .frame(height: 28)
                    .padding(.horizontal)

                // “Tracks” stub so you can see layout (not the full editor yet)
                TimelineStub()
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal)

                // Seek bar
                VStack(spacing: 6) {
                    let dur = region?.duration ?? 0
                    Slider(
                        value: Binding(
                            get: { userDraggingSeek ? pendingSeekTime : min(player.time, dur) },
                            set: { pendingSeekTime = $0 }
                        ),
                        in: 0...(dur > 0 ? dur : 1),
                        onEditingChanged: { editing in
                            userDraggingSeek = editing
                            guard let _ = region else { return }
                            if !editing {
                                player.seek(to: pendingSeekTime)
                            }
                        }
                    )
                    .disabled(region == nil)

                    HStack {
                        Text(formatTime(player.time))
                        Spacer()
                        Text(region == nil ? "00:00" : formatTime(region!.duration))
                    }
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                }
                .padding(.top, 4)

                // Meters
                MeterRowView(rms: player.rms, peak: player.peak)
                    .padding(.horizontal)

                // Transport
                TransportBar(
                    isPlaying: player.state == .playing,
                    play: { player.play() },
                    pause: { player.pause() },
                    stop: { player.stop() },
                    importAction: { isImporting = true },
                    shareAction: { exportShare() }
                )
                .padding(.horizontal)

                // Channel controls
                ChannelControls(
                    gainChanged: { dB in player.setGain(dB: dB) },
                    panChanged:  { pan in player.setPan(pan) }
                )
                .padding(.horizontal)

                // Loop toggle
                Toggle(isOn: Binding(
                    get: { isLooping },
                    set: { v in
                        isLooping = v
                        player.setLoop(v)
                    })
                ) { Text("Loop Region") }
                .toggleStyle(.switch)
                .padding(.horizontal)

                Spacer(minLength: 6)
            }
            .navigationTitle("Studio")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isImporting = true
                    } label: {
                        Label("Import", systemImage: "square.and.arrow.down")
                    }
                }
            }
            .sheet(isPresented: $isImporting) {
                AudioDocumentPicker { url in
                    guard let url else { return }
                    Task { await loadRegion(url: url) }
                }
                .presentationDetents([.medium, .large])
            }
        }
    }

    // MARK: helpers

    private func exportShare() {
        // Placeholder – hook your render/export here
        print("Export tapped")
    }

    private func loadRegion(url: URL) async {
        do {
            // Probe file duration
            let file = try AVAudioFile(forReading: url)
            let dur = Double(file.length) / file.processingFormat.sampleRate

            let r = TimelineRegion(url: url,
                                   fileStart: 0,
                                   duration: dur,
                                   loop: isLooping,
                                   gain: 0,
                                   pan: 0)
            try player.setRegion(r)
            await MainActor.run {
                region = r
            }
        } catch {
            print("Load failed: \(error)")
        }
    }

    private func formatTime(_ t: TimeInterval) -> String {
        guard t.isFinite, t >= 0 else { return "00:00" }
        let m = Int(t) / 60
        let s = Int(t) % 60
        return String(format: "%02d:%02d", m, s)
    }
}

// MARK: – Small subviews

private struct TransportBar: View {
    let isPlaying: Bool
    let play: () -> Void
    let pause: () -> Void
    let stop: () -> Void
    let importAction: () -> Void
    let shareAction: () -> Void

    var body: some View {
        HStack(spacing: 18) {
            Button(action: importAction) {
                Label("Import", systemImage: "tray.and.arrow.down")
            }
            Spacer()
            Button(action: stop) {
                Image(systemName: "stop.fill")
                    .font(.title2)
            }
            if isPlaying {
                Button(action: pause) {
                    Image(systemName: "pause.fill").font(.largeTitle)
                }
            } else {
                Button(action: play) {
                    Image(systemName: "play.fill").font(.largeTitle)
                }
            }
            Button(action: shareAction) {
                Image(systemName: "square.and.arrow.up").font(.title2)
            }
        }
        .buttonStyle(.plain)
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}

private struct ChannelControls: View {
    var gainChanged: (Float) -> Void
    var panChanged: (Float) -> Void

    @State private var gain: Float = 0     // dB
    @State private var pan: Float = 0      // -1...+1

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Gain")
                Slider(value: Binding(
                    get: { Double(gain) },
                    set: { gain = Float($0); gainChanged(gain) }
                ), in: -24...+24)
                Text(String(format: "%+.0f dB", gain))
                    .font(.caption.monospacedDigit())
                    .frame(width: 64, alignment: .trailing)
            }
            HStack {
                Text("Pan")
                Slider(value: Binding(
                    get: { Double(pan) },
                    set: { pan = Float($0); panChanged(pan) }
                ), in: -1...+1)
                Text(panLabel(pan))
                    .font(.caption.monospacedDigit())
                    .frame(width: 64, alignment: .trailing)
            }
        }
        .padding(12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    private func panLabel(_ p: Float) -> String {
        if abs(p) < 0.01 { return "C" }
        return p < 0 ? "L \(Int(abs(p)*100))" : "R \(Int(abs(p)*100))"
    }
}

private struct MeterRowView: View {
    let rms: Float
    let peak: Float
    var body: some View {
        HStack(spacing: 12) {
            LevelMeter(db: rms, label: "RMS")
            LevelMeter(db: peak, label: "Peak")
            Spacer()
        }
        .padding(12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}

private struct LevelMeter: View {
    let db: Float
    let label: String

    var norm: Double {
        // -60dB..0dB -> 0..1
        let clamped = min(0, max(-60, db))
        return Double((clamped + 60) / 60)
    }

    var color: Color {
        switch db {
        case ..<(-18): return .green
        case -18..<(-3): return .yellow
        default: return .red
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.caption2).foregroundStyle(.secondary)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6).fill(Color.gray.opacity(0.25))
                RoundedRectangle(cornerRadius: 6).fill(color.opacity(0.85))
                    .frame(width: nil)
                    .mask(
                        GeometryReader { geo in
                            Rectangle().frame(width: geo.size.width * norm)
                        }
                    )
            }
            .frame(height: 10)
            Text(String(format: "% .1f dB", db))
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: 160)
    }
}

private struct RulerView: View {
    let length: TimeInterval

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let secs = max(1, Int(length.rounded()))
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.15))
                Path { p in
                    for s in 0...secs {
                        let x = CGFloat(Double(s) / max(1, length) ) * w
                        let h: CGFloat = (s % 4 == 0) ? 14 : 8
                        p.move(to: CGPoint(x: x, y: 18 - h))
                        p.addLine(to: CGPoint(x: x, y: 18))
                    }
                }
                .stroke(Color.white.opacity(0.25), lineWidth: 1)
            }
        }
    }
}

private struct TimelineStub: View {
    var body: some View {
        VStack(spacing: 10) {
            lane(color: .green, title: "Lead Vox")
            lane(color: .red,   title: "Back Vox")
            lane(color: .purple,title: "Keys")
            lane(color: .orange,title: "Drums")
        }
        .padding(12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    private func lane(color: Color, title: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 90, alignment: .leading)
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.8))
                .frame(height: 24)
        }
    }
}
