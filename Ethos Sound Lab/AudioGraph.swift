import SwiftUI
import Foundation
import Combine
//import Foundation
import Combine

/// Minimal API the UI talks to. Replace with a real AVAudioEngine/Metal graph later.
protocol AudioGraph: ObservableObject {
    // Recording
    var isArmed: Bool { get set }
    var isRecording: Bool { get set }
    func requestMic(completion: @escaping (Bool) -> Void)
    func startRecording()
    func stopRecording()
    // Simple meters (0...1)
    var inputLevel: Double { get }
    // Settings stubs
    var autotune: AutotuneSettings { get set }
    var denoiseAmount: Double { get set }
    var masterGain: Double { get set }
}

struct AutotuneSettings {
    var key: String = "C"
    var scale: String = "Major"
    var retuneSpeed: Double = 0.4
    var humanize: Double = 0.5
    var formant: Double = 0.0
    var style: String = "Natural"
}

/// Safe no-op implementation so the app runs.
final class DefaultAudioGraph: AudioGraph {
    @Published var isArmed: Bool = false
    @Published var isRecording: Bool = false
    @Published var autotune: AutotuneSettings = .init()
    @Published var denoiseAmount: Double = 0.0
    @Published var masterGain: Double = 0.0

    private var timer: Timer?
    @Published private(set) var inputLevel: Double = 0.0

    func requestMic(completion: @escaping (Bool) -> Void) {
        // Real app: AVAudioSession.sharedInstance().requestRecordPermission
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { completion(true) }
    }

    func startRecording() {
        isRecording = true
        isArmed = true
        // Fake meter animation
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.inputLevel = Double.random(in: 0.02...0.95)
        }
    }

    func stopRecording() {
        isRecording = false
        timer?.invalidate()
        inputLevel = 0.0
    }
}

//  AudioGraph.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/9/25.
//

