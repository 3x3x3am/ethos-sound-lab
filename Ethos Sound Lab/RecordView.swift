import SwiftUI

struct RecordView: View {
    @EnvironmentObject var store: ProjectStore
    @State private var isRecording = false
    @State private var lyrics: String = ""

    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple.opacity(0.4), .yellow.opacity(0.25), .blue.opacity(0.25)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                SegmentedHeader(selected: .record)

                // “Lyrics page”
                TextEditor(text: $lyrics)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .frame(maxHeight: 300)
                    .background(Theme.panel.opacity(0.6))
                    .cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.1)))

                Spacer()

                HStack(spacing: 24) {
                    Spacer()
                    Button {
                        Task {
                            if !isRecording {
                                _ = try? AudioEngine.shared.startRecording()
                                isRecording = true
                            } else {
                                if let url = AudioEngine.shared.stopRecording() {
                                    // Add to Voice track
                                    if let voice = store.tracks.first(where: {$0.name.lowercased().contains("voice")}) {
                                        store.addRegion(to: voice.id, from: url, title: "Take \(Int.random(in: 1...99))")
                                        try? AudioEngine.shared.load(url: url, to: voice.id)
                                    }
                                }
                                isRecording = false
                            }
                        }
                    } label: {
                        Circle()
                            .fill(isRecording ? .red : .red.opacity(0.9))
                            .frame(width: 78, height: 78)
                            .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 4))
                    }
                    Spacer()
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 20)
        }
        .foregroundStyle(Theme.text)
        .background(Theme.bg)
    }
}
