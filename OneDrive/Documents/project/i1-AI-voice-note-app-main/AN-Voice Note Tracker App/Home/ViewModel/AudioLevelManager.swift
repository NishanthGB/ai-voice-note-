//
//  AudioLevelManager.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 09/11/25.
//

import Foundation
import AVFoundation

@Observable
class AudioLevelManager {
    private let engine = AVAudioEngine()
     var level: Float = 0.0  // 0.0 to 1.0 (normalized)
    
    func start() {
        let input = engine.inputNode
        let format = input.outputFormat(forBus: 0)
        
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            let level = self.calculateLevel(buffer: buffer)
            DispatchQueue.main.async {
                self.level = level
            }
        }
        
        try? engine.start()
    }

    func calculateLevel(buffer: AVAudioPCMBuffer) -> Float {
        guard let channelData = buffer.floatChannelData?[0] else { return 0 }

        let frameLength = Int(buffer.frameLength)
        if frameLength == 0 { return 0 }

        // Compute sum of squares explicitly to avoid complex type inference chains
        var sum: Float = 0
        for i in 0..<frameLength {
            let sample = channelData[i]
            sum += sample * sample
        }

        let meanSquare = sum / Float(frameLength)
        let rms = sqrt(meanSquare)

        // Normalize for UI: scale and clamp between 0 and 1
        let scaled = rms * 20
        let normalized = min(max(scaled, 0), 1)
        return normalized
    }
}
