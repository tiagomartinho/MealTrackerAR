import Foundation

protocol BiteDetectorDelegate: class {
    func biteDetected()
}

class BiteDetector {

    private var buffer = RunningBuffer(size: 20)
    private let threshold = 6.0
    private let influence = 0.5
    private var state: BiteDetectorState = .idle

    private weak var delegate: BiteDetectorDelegate?
    
    init(delegate: BiteDetectorDelegate) {
        self.delegate = delegate
    }
    
    func input(value: Double) {
        guard buffer.isFull() else { buffer.addSample(value); return }
        let mean = buffer.recentMean()
        let std = buffer.standardDeviation()
        if abs(value - mean) > threshold * std {
            if value > mean && state != .detecting {
                delegate?.biteDetected()
            }
            buffer.addSample(influence * value + (1-influence)*buffer.last)
            state = .detecting
        } else {
            buffer.addSample(value)
            state = .idle
        }
    }
}

enum BiteDetectorState {
    case detecting, idle
}
