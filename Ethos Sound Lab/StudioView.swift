import SwiftUI

struct StudioView: View {
    @StateObject private var host = AudioEngineHost()

    // demo data so it compiles and runs
    @State private var clips: [TimelineClip] = {
        // empty demo (no files yet) – you can add URLs later
        let track = StudioTrack(name: "Voice", kind: .audio, colorTag: "green")
        return [
            TimelineClip(trackID: track.id, start: 0, duration: 2, url: nil) // placeholder
        ]
    }()

    init() {} // make the zero-arg init explicit to kill "ambiguous init()"

    var body: some View {
        VStack(spacing: 16) {
            Text("Studio")
                .font(.title).bold()

            HStack(spacing: 12) {
                Button("Load") { host.load(clips: clips) }
                Button("Play") { host.play() }
                Button("Stop") { host.stop() }
            }
            .buttonStyle(.borderedProminent)

            Text(host.isRunning ? "Engine: Running" : "Engine: Stopped")
                .foregroundStyle(host.isRunning ? .green : .secondary)

            Spacer()
        }
        .padding()
    }
}
